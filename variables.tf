variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the this resource."

}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource name of the resource group where the resource should be deployed."
}

variable "subscription_id" {
  type        = string
  description = "The subscription ID where the resource should be deployed."
}
# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.
DESCRIPTION
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    subresource_name                        = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
  default     = {}
  description = <<DESCRIPTION
A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.
DESCRIPTION
  nullable    = false
}

# This variable is used to determine if the private_dns_zone_group block should be included,
# or if it is to be managed externally, e.g. using Azure Policy.
# https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault/issues/32
# Alternatively you can use AzAPI, which does not have this issue.
variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  nullable    = false
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}


variable "managed_resource_group_name" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) The name of the managed resource group, which gets created in the same location as the workspace. This is used to manage the resources created by the workspace."
DESCRIPTION

}

variable "use_managed_virtual_network" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
(Optional) Whether to use a managed virtual network. If set to true, the workspace will be created in a managed virtual network. If set to false, the workspace will be created in a standard virtual network.
DESCRIPTION
}

variable "managed_virtual_network_settings" {
  type = object({
    allowed_aad_tenant_ids_for_linking     = optional(list(string), [])
    linked_access_check_on_target_resource = optional(bool, false)
    prevent_data_exfiltration              = optional(bool, false)
  })
  default     = null
  description = <<DESCRIPTION
(Optional) The settings for the managed virtual network. This includes the following properties:
- `allowed_aad_tenant_ids_for_linking` - (Optional) A set of Azure AD tenant IDs that are allowed to link to the managed virtual network.
- `linked_access_check_on_target_resource` - (Optional) Whether to perform a linked access check on the target resource. Defaults to false.
- `prevent_data_exfiltration` - (Optional) Whether to prevent data exfiltration from the managed virtual network. Defaults to false.
DESCRIPTION
  #   validation {
  #     condition     = var.managed_virtual_network_settings != null && var.use_managed_virtual_network == null
  #     error_message = "The `managed_virtual_network_settings` variable can only be set when `use_managed_virtual_network` is set to true."
  #   }
}

variable "generate_sql_admin_password" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
(Optional) Whether to generate a random SQL admin password. If set to true, a random password will be generated. If set to false, the password will be set to the value of `sql_admin_password`.
DESCRIPTION
  # validation {
  #   condition     = var.sql_admin_password == null && var.generate_sql_admin_password != null
  #   error_message = "Only one of `sql_admin_password` or `generate_sql_admin_password` can be set."
  # }
}

variable "sql_admin_password" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) The SQL admin password. This is only used if `generate_sql_admin_password` is set to false. If set to true, a random password will be generated.
DESCRIPTION
  sensitive   = true
  # validation {
  #   condition     = var.sql_admin_password != null && var.generate_sql_admin_password != null
  #   error_message = "Only one of `sql_admin_password` or `generate_sql_admin_password` can be set."
  # }
}

variable "sql_admin_login" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) The SQL admin login. This is only used if `azure_ad_only_authentication` is set to false.
DESCRIPTION

}

variable "is_private" {
  type        = bool
  default     = false
  description = "Specifies if every provisioned resource should be private and inaccessible from the Internet."
}

variable "purview_resource_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
(Optional) The resource ID of the Purview account to associate with the workspace. This is used for Purview integration.
DESCRIPTION
}

variable "trusted_service_bypass_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
(Optional) Whether to enable trusted service bypass for the workspace. If set to true, trusted services will be able to bypass the firewall and access the workspace. If set to false, trusted services will not be able to bypass the firewall.
DESCRIPTION

}

variable "initial_workspace_admin_object_id" {
  type        = string
  description = <<DESCRIPTION
(Optional) The object ID of the initial workspace admin. This is used to set the initial workspace admin for the workspace.
DESCRIPTION

  nullable = false
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.initial_workspace_admin_object_id))
    error_message = "The initial workspace admin object ID must be a valid GUID."
  }
  validation {
    condition     = var.initial_workspace_admin_object_id != null
    error_message = "The initial workspace admin object ID must be set."
  }
}

variable "azure_ad_only_authentication" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
(Optional) Whether to enable Azure AD only authentication for the workspace. If set to true, only Azure AD authentication will be allowed. If set to false, both Azure AD and SQL authentication will be allowed.
DESCRIPTION

}

variable "default_data_lake_storage" {
  type = object({
    account_url                     = optional(string)
    create_managed_private_endpoint = optional(bool, true)
    filesystem                      = optional(string)
    resource_id                     = string
  })
  default     = null
  description = <<DESCRIPTION
(Optional) The default data lake storage account to associate with the workspace. This is used for data lake integration. The following properties can be specified:
- `account_url` - The URL of the data lake storage account.
- `create_managed_private_endpoint` - (Optional) Whether to create a managed private endpoint for the data lake storage account. Defaults to false.
- `filesystem` - (Optional) The name of the filesystem in the data lake storage account. Defaults to "/".
- `resource_id` - The resource ID of the data lake storage account.

DESCRIPTION

}

variable "workspace_repository_configuration" {
  type = object({
    account_name         = string
    collaboration_branch = string
    project_name         = string
    repository_name      = string
    root_folder          = string
    tenant_id            = string
    type                 = string
  })
  default     = null
  description = <<DESCRIPTION
(Optional) The workspace repository configuration. This is used for Git integration. The following properties can be specified:
- `account_name` - The name of the Azure DevOps account.
- `collaboration_branch` - The name of the collaboration branch.
- `host_name` - The host name of the Azure DevOps account.
- `project_name` - The name of the Azure DevOps project.
- `repository_name` - The name of the Azure DevOps repository.
- `root_folder` - The root folder in the Azure DevOps repository.
- `tenant_id` - The Azure AD tenant ID.
- `type` - The type of the repository. Possible values are `Git` and `TFVC`.
DESCRIPTION
}


variable "firewall_rules" {
  type = map(object({
    name             = optional(string, null)
    start_ip_address = string
    end_ip_address   = string
  }))
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of firewall rules to create on the workspace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `name` - (Optional) The name of the firewall rule. One will be generated if not set.
- `start_ip_address` - The start IP address of the firewall rule.
- `end_ip_address` - The end IP address of the firewall rule.
DESCRIPTION
}

variable "trusted_service_bypass_configuration_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
(Optional) Whether to enable trusted service bypass configuration for the workspace. If set to true, trusted services will be able to bypass the firewall and access the workspace. If set to false, trusted services will not be able to bypass the firewall.
DESCRIPTION

}

variable "dedicated_sql_minimal_tls_version" {
  type        = string
  default     = "1.2"
  description = <<DESCRIPTION
(Optional) The minimum TLS version for the dedicated SQL pool. This is used to enforce TLS encryption for the dedicated SQL pool. Possible values are `1.0`, `1.1`, and `1.2`. Defaults to `1.2`.
DESCRIPTION

}
