terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.2"
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
module "avm-res-storage-storageaccount" {
  source              = "Azure/avm-res-storage-storageaccount/azurerm"
  version             = "0.5.0"
  name                = module.naming.storage_account.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  is_hns_enabled            = true
  shared_access_key_enabled = true
  storage_data_lake_gen2_filesystem = {
    name = module.naming.storage_data_lake_gen2_filesystem.name_unique
  }
  public_network_access_enabled = true
  network_rules = {
    bypass = [
      "AzureServices",
    ]
    default_action = "Allow"
  }
  role_assignments = {
    role_assignment_2 = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },

  }
}

locals {
  synapse_workspace_name = "synws-example-${random_integer.region_index.result}"
}
module "this" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  location                          = azurerm_resource_group.this.location
  name                              = local.synapse_workspace_name
  resource_group_name               = azurerm_resource_group.this.name
  initial_workspace_admin_object_id = "ed4f4edf-8df0-48b4-9026-d86db3de8615"
  sql_admin_login                   = "sqladmin"
  generate_sql_admin_password       = true
  managed_resource_group_name       = "${azurerm_resource_group.this.name}-managed"
  use_managed_virtual_network       = true
  managed_virtual_network_settings = {
    prevent_data_exfiltration = false
  }
  default_data_lake_storage = {
    resource_id                     = module.avm-res-storage-storageaccount.resource_id
    account_url                     = module.avm-res-storage-storageaccount.resource.primary_dfs_endpoint
    filesystem                      = module.naming.storage_data_lake_gen2_filesystem.name_unique
    create_managed_private_endpoint = true
  }

  trusted_service_bypass_enabled = true
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

  tags = {
    env = "test"
  }
  enable_telemetry = var.enable_telemetry # see variables.tf

  depends_on = [azurerm_resource_group.this]
}
