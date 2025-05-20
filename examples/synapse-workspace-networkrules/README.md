<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
  backend "local" {

  }
}


provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}
## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = "germanywestcentral"
  name     = module.naming.resource_group.name_unique
}

## Section
module "avm_res_storage_storageaccount" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.5.0"

  location                 = azurerm_resource_group.this.location
  name                     = module.naming.storage_account.name_unique
  resource_group_name      = azurerm_resource_group.this.name
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  is_hns_enabled           = true
  network_rules = {
    bypass = [
      "AzureServices",
    ]
    default_action = "Allow"
  }
  public_network_access_enabled = true
  role_assignments = {
    role_assignment_2 = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },

  }
  shared_access_key_enabled = true
  storage_data_lake_gen2_filesystem = {
    name = module.naming.storage_data_lake_gen2_filesystem.name_unique
  }
}

locals {
  synapse_workspace_name = "synws-example-${random_integer.region_index.result}"
}
module "this" {
  source = "../../"

  initial_workspace_admin_object_id = "00000000-0000-0000-0000-000000000000"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location            = azurerm_resource_group.this.location
  name                = local.synapse_workspace_name
  resource_group_name = azurerm_resource_group.this.name
  default_data_lake_storage = {
    resource_id                     = module.avm_res_storage_storageaccount.resource_id
    account_url                     = module.avm_res_storage_storageaccount.resource.primary_dfs_endpoint
    filesystem                      = module.naming.storage_data_lake_gen2_filesystem.name_unique
    create_managed_private_endpoint = true
  }
  enable_telemetry = var.enable_telemetry # see variables.tf
  firewall_rules = {
    rule001 = {
      name             = "rule001"
      start_ip_address = "192.168.127.1"
      end_ip_address   = "192.168.127.1"
    },
    auto_name = {
      name             = "auto_name"
      start_ip_address = "192.168.127.2"
      end_ip_address   = "192.168.127.2"
    }
  }
  generate_sql_admin_password = true
  managed_resource_group_name = "${azurerm_resource_group.this.name}-managed"
  managed_virtual_network_settings = {
    prevent_data_exfiltration = false
  }
  sql_admin_login = "sqladmin"
  subscription_id = data.azurerm_client_config.current.subscription_id
  tags = {
    env = "test"
  }
  trusted_service_bypass_enabled = true
  use_managed_virtual_network    = true

  depends_on = [azurerm_resource_group.this]
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (3.6.2)

## Resources

The following resources are used by this module:

- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/integer) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_avm_res_storage_storageaccount"></a> [avm\_res\_storage\_storageaccount](#module\_avm\_res\_storage\_storageaccount)

Source: Azure/avm-res-storage-storageaccount/azurerm

Version: 0.5.0

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: ~> 0.3

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/avm-utl-regions/azurerm

Version: ~> 0.1

### <a name="module_this"></a> [this](#module\_this)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->