# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "HRCenter-2023-Dev"
    storage_account_name = "hrcsharedtfstatedev"
    container_name       = "tfstatefiles"
    key                  = "hrc_shared.tfstate"
  }
}
# Provider Block
provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy    = false
    }
  }
  skip_provider_registration = true
}

resource "random_string" "myrandom" {
  length  = 6
  upper   = false
  special = false
  numeric = false
}