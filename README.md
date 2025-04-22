<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~>0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.6.2)

## Resources

The following resources are used by this module:

- [azapi_resource.big_data_pools](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.synapse_workspace_firewall_rules](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.synapse_workspace_firewall_rules_trusted_azure_services](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azapi_resource.this](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint.this_unmanaged_dns_zone_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_password.sql_admin_password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/password) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_key_vault_key.cmk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_key) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_initial_workspace_admin_object_id"></a> [initial\_workspace\_admin\_object\_id](#input\_initial\_workspace\_admin\_object\_id)

Description: (Optional) The object ID of the initial workspace admin. This is used to set the initial workspace admin for the workspace.

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the this resource.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource name of the resource group where the resource should be deployed.

Type: `string`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: The subscription ID where the resource should be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_azure_ad_only_authentication"></a> [azure\_ad\_only\_authentication](#input\_azure\_ad\_only\_authentication)

Description: (Optional) Whether to enable Azure AD only authentication for the workspace. If set to true, only Azure AD authentication will be allowed. If set to false, both Azure AD and SQL authentication will be allowed.

Type: `bool`

Default: `true`

### <a name="input_big_data_pools"></a> [big\_data\_pools](#input\_big\_data\_pools)

Description: A map of Spark pools to create on the Synapse workspace.
- `name` - The name of the Spark pool.
- `node_size` - The size of the nodes in the Spark pool.
- `node_size_family` - The family of the nodes in the Spark pool.
- `spark_version` - The version of Spark to use in the Spark pool.
- `location` - (Optional) The location of the Spark pool. Defaults to the location of the Synapse workspace.
- `auto_pause` - (Optional) A map of auto pause settings for the Spark pool. The following properties can be specified:
  - `delay_in_minutes` - The delay in minutes before the Spark pool is paused.
  - `enabled` - Whether to enable auto pause. Defaults to true.
- `auto_scale` - (Optional) A map of auto scale settings for the Spark pool. The following properties can be specified:
  - `enabled` - Whether to enable auto scale. Defaults to true.
  - `max_node_count` - The maximum number of nodes in the Spark pool. Defaults to 1.
  - `min_node_count` - The minimum number of nodes in the Spark pool. Defaults to 3.
- `cache_size` - (Optional) The size of the cache for the Spark pool.
- `custom_libraries` - (Optional) A list of custom libraries to install in the Spark pool. Each library is specified as an object with the following properties:
  - `name` - The name of the library.
  - `version` - The version of the library.
  - `uri` - The URI of the library.
- `default_spark_log_folder` - (Optional) The default folder for Spark logs.
- `spark_events_folder` - (Optional) The folder for Spark events.
- `dynamic_executor_allocation` - (Optional) A map of dynamic executor allocation settings for the Spark pool. The following properties can be specified:
  - `enabled` - Whether to enable dynamic executor allocation. Defaults to true.
  - `max_executors` - The maximum number of executors in the Spark pool.
  - `min_executors` - The minimum number of executors in the Spark pool.
- `is_autotune_enabled` - (Optional) Whether to enable autotune for the Spark pool. Defaults to false.
- `is_compute_isolation_enabled` - (Optional) Whether to enable compute isolation for the Spark pool. Defaults to false.
- `library_requirements` - (Optional) A map of library requirements for the Spark pool. The following properties can be specified:
  - `content` - The content of the library requirements.
  - `filename` - The filename of the library requirements.
- `node_count` - (Optional) The number of nodes in the Spark pool. Either autos\_scale or node\_count needs to be configured .Defaults to 0.
- `session_level_packages_enabled` - (Optional) Whether to enable session level packages for the Spark pool. Defaults to false.
- `spark_config_properties` - (Optional) A map of Spark configuration properties for the Spark pool. The following properties can be specified:
  - `content` - The content of the Spark configuration properties.
  - `filename` - The filename of the Spark configuration properties.
- `tags` - (Optional) A map of tags to assign to the Spark pool.

Type:

```hcl
map(object({
    name             = string
    node_size        = string
    node_size_family = string
    spark_version    = string
    location         = optional(string, null)
    auto_pause = optional(object({
      delay_in_minutes = optional(number)
      enabled          = optional(bool, true)
    }))
    auto_scale = optional(object({
      enabled        = bool
      max_node_count = optional(number, 1)
      min_node_count = optional(number, 3)
    }))
    cache_size = optional(string, null)
    custom_libraries = optional(list(object({
      name    = string
      version = string
      uri     = string
    })), [])
    default_spark_log_folder = optional(string, null)
    spark_events_folder      = optional(string, null)
    dynamic_executor_allocation = optional(object({
      enabled       = bool
      max_executors = optional(number)
      min_executors = optional(number)
    }))
    is_autotune_enabled          = optional(bool, false)
    is_compute_isolation_enabled = optional(bool, false)
    library_requirements = optional(object({
      content  = string
      filename = string
    }))
    node_count                     = optional(number, 0)
    session_level_packages_enabled = optional(bool, false)
    spark_config_properties = optional(object({
      content  = string
      filename = string
    }))
    tags = optional(map(string), null)
  }))
```

Default: `{}`

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.

Type:

```hcl
object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
```

Default: `null`

### <a name="input_default_data_lake_storage"></a> [default\_data\_lake\_storage](#input\_default\_data\_lake\_storage)

Description: (Optional) The default data lake storage account to associate with the workspace. This is used for data lake integration. The following properties can be specified:
- `account_url` - The URL of the data lake storage account.
- `create_managed_private_endpoint` - (Optional) Whether to create a managed private endpoint for the data lake storage account. Defaults to false.
- `filesystem` - (Optional) The name of the filesystem in the data lake storage account. Defaults to "/".
- `resource_id` - The resource ID of the data lake storage account.

Type:

```hcl
object({
    account_url                     = optional(string)
    create_managed_private_endpoint = optional(bool, true)
    filesystem                      = optional(string)
    resource_id                     = string
  })
```

Default: `null`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

Type:

```hcl
map(object({
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
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules)

Description: (Optional) A map of firewall rules to create on the workspace. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `name` - (Optional) The name of the firewall rule. One will be generated if not set.
- `start_ip_address` - The start IP address of the firewall rule.
- `end_ip_address` - The end IP address of the firewall rule.

Type:

```hcl
map(object({
    name             = optional(string, null)
    start_ip_address = string
    end_ip_address   = string
  }))
```

Default: `{}`

### <a name="input_generate_sql_admin_password"></a> [generate\_sql\_admin\_password](#input\_generate\_sql\_admin\_password)

Description: (Optional) Whether to generate a random SQL admin password. If set to true, a random password will be generated. If set to false, the password will be set to the value of `sql_admin_password`.

Type: `bool`

Default: `false`

### <a name="input_is_private"></a> [is\_private](#input\_is\_private)

Description: Specifies if every provisioned resource should be private and inaccessible from the Internet.

Type: `bool`

Default: `false`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_managed_resource_group_name"></a> [managed\_resource\_group\_name](#input\_managed\_resource\_group\_name)

Description: (Optional) The name of the managed resource group, which gets created in the same location as the workspace. This is used to manage the resources created by the workspace."

Type: `string`

Default: `null`

### <a name="input_managed_virtual_network_settings"></a> [managed\_virtual\_network\_settings](#input\_managed\_virtual\_network\_settings)

Description: (Optional) The settings for the managed virtual network. This includes the following properties:
- `allowed_aad_tenant_ids_for_linking` - (Optional) A set of Azure AD tenant IDs that are allowed to link to the managed virtual network.
- `linked_access_check_on_target_resource` - (Optional) Whether to perform a linked access check on the target resource. Defaults to false.
- `prevent_data_exfiltration` - (Optional) Whether to prevent data exfiltration from the managed virtual network. Defaults to false.

Type:

```hcl
object({
    allowed_aad_tenant_ids_for_linking     = optional(list(string), [])
    linked_access_check_on_target_resource = optional(bool, false)
    prevent_data_exfiltration              = optional(bool, false)
  })
```

Default: `null`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description: A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

Type:

```hcl
map(object({
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
```

Default: `{}`

### <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group)

Description: Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy.

Type: `bool`

Default: `true`

### <a name="input_purview_resource_id"></a> [purview\_resource\_id](#input\_purview\_resource\_id)

Description: (Optional) The resource ID of the Purview account to associate with the workspace. This is used for Purview integration.

Type: `string`

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_sql_admin_login"></a> [sql\_admin\_login](#input\_sql\_admin\_login)

Description: (Optional) The SQL admin login. This is only used if `azure_ad_only_authentication` is set to false.

Type: `string`

Default: `null`

### <a name="input_sql_admin_password"></a> [sql\_admin\_password](#input\_sql\_admin\_password)

Description: (Optional) The SQL admin password. This is only used if `generate_sql_admin_password` is set to false. If set to true, a random password will be generated.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

### <a name="input_trusted_service_bypass_configuration_enabled"></a> [trusted\_service\_bypass\_configuration\_enabled](#input\_trusted\_service\_bypass\_configuration\_enabled)

Description: (Optional) Whether to enable trusted service bypass configuration for the workspace. If set to true, trusted services will be able to bypass the firewall and access the workspace. If set to false, trusted services will not be able to bypass the firewall.

Type: `bool`

Default: `false`

### <a name="input_trusted_service_bypass_enabled"></a> [trusted\_service\_bypass\_enabled](#input\_trusted\_service\_bypass\_enabled)

Description: (Optional) Whether to enable trusted service bypass for the workspace. If set to true, trusted services will be able to bypass the firewall and access the workspace. If set to false, trusted services will not be able to bypass the firewall.

Type: `bool`

Default: `false`

### <a name="input_use_managed_virtual_network"></a> [use\_managed\_virtual\_network](#input\_use\_managed\_virtual\_network)

Description: (Optional) Whether to use a managed virtual network. If set to true, the workspace will be created in a managed virtual network. If set to false, the workspace will be created in a standard virtual network.

Type: `bool`

Default: `false`

### <a name="input_workspace_repository_configuration"></a> [workspace\_repository\_configuration](#input\_workspace\_repository\_configuration)

Description: (Optional) The workspace repository configuration. This is used for Git integration. The following properties can be specified:
- `account_name` - The name of the Azure DevOps account.
- `collaboration_branch` - The name of the collaboration branch.
- `host_name` - The host name of the Azure DevOps account.
- `project_name` - The name of the Azure DevOps project.
- `repository_name` - The name of the Azure DevOps repository.
- `root_folder` - The root folder in the Azure DevOps repository.
- `tenant_id` - The Azure AD tenant ID.
- `type` - The type of the repository. Possible values are `Git` and `TFVC`.

Type:

```hcl
object({
    account_name         = string
    collaboration_branch = string
    project_name         = string
    repository_name      = string
    root_folder          = string
    tenant_id            = string
    type                 = string
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password)

Description: Returns the sqladmin password if installation is configured to use the password.  Otherwise returns null

### <a name="output_name"></a> [name](#output\_name)

Description: The name of the Synapse Workspace.

### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

Description: A map of private endpoints. The map key is the supplied input to var.private\_endpoints. The map value is the entire azurerm\_private\_endpoint resource.

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full resource output for the Synapse Workspace resource.

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: The ID of the Synapse Workspace.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->