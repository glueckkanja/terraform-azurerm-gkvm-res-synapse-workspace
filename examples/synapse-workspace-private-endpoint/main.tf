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

module "avm_res_network_virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.8.1"

  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  name                = module.naming.virtual_network.name_unique
  subnets = {
    synapse_pe = {
      name             = "synapse-pe"
      address_prefixes = ["10.0.0.0/24"]
    }
  }
}

locals {
  endpoints              = ["sql", "sqlOnDemand", "dev"]
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
  enable_telemetry            = var.enable_telemetry # see variables.tf
  generate_sql_admin_password = true
  managed_resource_group_name = "${azurerm_resource_group.this.name}-managed"
  private_endpoints = {
    for endpoint in local.endpoints :
    endpoint => {
      # the name must be set to avoid conflicting resources.
      name               = "pe-${endpoint}-${local.synapse_workspace_name}"
      subnet_resource_id = module.avm_res_network_virtualnetwork.subnets.synapse_pe.resource_id
      subresource_name   = endpoint
      # these are optional but illustrate making well-aligned service connection & NIC names.
      private_service_connection_name = "psc-${endpoint}-${local.synapse_workspace_name}"
      network_interface_name          = "nic-pe-${endpoint}-${local.synapse_workspace_name}"
    }
  }
  sql_admin_login = "sqladmin"
  tags = {
    env = "test"
  }
  use_managed_virtual_network = true

  depends_on = [azurerm_resource_group.this]
}
