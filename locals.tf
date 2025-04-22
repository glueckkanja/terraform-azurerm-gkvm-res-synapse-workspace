# TODO: insert locals here.
locals {
  managed_identities = {
    this = {
      type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
      user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
    }
  }
  # Private endpoint application security group associations.
  # We merge the nested maps from private endpoints and application security group associations into a single map.
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
  resource_group_id                  = format("%s/%s/%s", local.subscription_scope, local.resource_group_scope, local.resource_group_name)
  resource_group_name                = var.resource_group_name
  resource_group_scope               = "resourceGroups"
  role_definition_resource_substring = "providers/Microsoft.Authorization/roleDefinitions"
  sql_admin_password                 = var.generate_sql_admin_password == true ? random_password.sql_admin_password[0].result : var.sql_admin_password
  subscription_scope                 = format("/subscriptions/%s", var.subscription_id)
  synapse_workspace_id               = azapi_resource.this.id
}
