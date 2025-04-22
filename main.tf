resource "azapi_resource" "this" {
  type = "Microsoft.Synapse/workspaces@2021-06-01-preview"
  body = {
    properties = {
      azureADOnlyAuthentication = var.azure_ad_only_authentication
      cspWorkspaceAdminProperties = {
        initialWorkspaceAdminObjectId = var.initial_workspace_admin_object_id
      }
      defaultDataLakeStorage = {
        accountUrl                   = var.default_data_lake_storage.account_url
        createManagedPrivateEndpoint = var.default_data_lake_storage.create_managed_private_endpoint
        filesystem                   = var.default_data_lake_storage.filesystem
        resourceId                   = var.default_data_lake_storage.resource_id
      }
      encryption = var.customer_managed_key != null ? {
        cmk = {
          kekIdentity = {
            userAssignedIdentity      = var.customer_managed_key.managed_identities.system_assigned == true ? "" : var.customer_managed_key.user_assigned_identity.resource_id
            useSystemAssignedIdentity = var.customer_managed_key.managed_identities.system_assigned == true ? false : true
          }
          key = {
            keyVaultUrl = data.azurerm_key_vault_key.cmk[0].id
            name        = var.customer_managed_key.key_name
          }
        }
      } : {}
      managedResourceGroupName = var.managed_resource_group_name
      managedVirtualNetwork    = var.use_managed_virtual_network ? "default" : null
      managedVirtualNetworkSettings = var.managed_virtual_network_settings != null ? {
        allowedAadTenantIdsForLinking     = var.managed_virtual_network_settings.allowed_aad_tenant_ids_for_linking
        linkedAccessCheckOnTargetResource = var.managed_virtual_network_settings.linked_access_check_on_target_resource
        preventDataExfiltration           = var.managed_virtual_network_settings.prevent_data_exfiltration
      } : null
      publicNetworkAccess = var.is_private ? "Disabled" : "Enabled"
      purviewConfiguration = {
        purviewResourceId = var.purview_resource_id
      }
      sqlAdministratorLogin         = var.sql_admin_login
      sqlAdministratorLoginPassword = local.sql_admin_password
      trustedServiceBypassEnabled   = var.trusted_service_bypass_enabled
      virtualNetworkProfile = {
        computeSubnetId = "string"
      }
      workspaceRepositoryConfiguration = var.workspace_repository_configuration != null ? {
        accountName         = var.workspace_repository_configuration.account_name
        collaborationBranch = var.workspace_repository_configuration.collaboration_branch
        projectName         = var.workspace_repository_configuration.project_name
        repositoryName      = var.workspace_repository_configuration.repository_name
        rootFolder          = var.workspace_repository_configuration.root_folder
        tenantId            = var.workspace_repository_configuration.tenant_id
        type                = var.workspace_repository_configuration.type
        lastCommitId        = null
      } : null
      privateEndpointConnections = []
    }
  }
  ignore_missing_property = true
  location                = var.location
  name                    = var.name
  parent_id               = local.resource_group_id
  response_export_values = [
    "body.properties.workspaceRepositoryConfiguration.lastCommitId",
    "body.properties.privateEndpointConnections"
  ]
  retry = {
    interval_seconds     = 5
    randomization_factor = 0.5 # adds randomization to retry pattern
    multiplier           = 2   # if try fails, multiplies time between next try by this much
    error_message_regex  = ["ResourceNotFound"]
  }
  tags = var.tags

  dynamic "identity" {
    for_each = local.managed_identities

    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  timeouts {
    create = "30m"
  }

  lifecycle {
    ignore_changes = [
      body.properties.workspaceRepositoryConfiguration.lastCommitId,
      body.properties.privateEndpointConnections,
      tags
    ]
  }
}

resource "azapi_resource" "synapse_workspace_firewall_rules" {
  for_each = var.firewall_rules

  type = "Microsoft.Synapse/workspaces/firewallRules@2021-06-01-preview"
  body = {
    properties = {
      endIpAddress   = each.value.end_ip_address
      startIpAddress = each.value.start_ip_address
    }
  }
  ignore_missing_property = true
  name                    = try(each.value.name, each.key)
  parent_id               = azapi_resource.this.id

  depends_on = [azapi_resource.this]
}


resource "azapi_resource" "synapse_workspace_firewall_rules_trusted_azure_services" {
  count = var.trusted_service_bypass_enabled ? 1 : 0

  type = "Microsoft.Synapse/workspaces/firewallRules@2021-06-01-preview"
  body = {
    properties = {
      endIpAddress   = "0.0.0.0"
      startIpAddress = "0.0.0.0"
    }
  }
  name      = "AllowAllWindowsAzureIps"
  parent_id = azapi_resource.this.id

  depends_on = [azapi_resource.this]
}




resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = local.synapse_workspace_id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}


resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
  target_resource_id             = azapi_resource.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
}
