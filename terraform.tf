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
    # DEPRECATED: no resources use modtm any more. It stays declared for one
    # version so Terraform can still decode modtm_telemetry.telemetry from
    # existing state while the removed block in main.deprecated.tf forgets it.
    # Drop together with variable enable_telemetry in the next major version.
    # tflint-ignore: terraform_unused_required_providers
    modtm = {
      source  = "Azure/modtm"
      version = "~>0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}
