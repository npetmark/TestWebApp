variable "location" {
  description = "The Azure Region in which all resources groups should be created."
  type        = list(any)
  default     = ["eastus"]
}

variable "rg_location" {
  description = "The location of the Resource Group"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS Zone"
  type        = string
}

variable "front_door_profile_name" {
  description = "The name of the Front Door Profile"
  type        = string
}

variable "front_door_sku_name" {
  description = "The name of the Front Door Profile"
  type        = string
}

variable "front_door_custom_domain_name" {
  description = "The name of the Front Door Profile"
  type        = string
}

variable "cdn_host_name" {
  description = "The name of the Front Door Profile"
  type        = string
}

variable "service_plan_name_client" {
  description = "The name of the service plan"
  type        = string
}

variable "web_app_name_client" {
  description = "The name of the HRC Client web app"
  type        = string
}

variable "service_plan_name_admin" {
  description = "The name of the HRC Admin service plan"
  type        = string
}

variable "web_app_name_admin" {
  description = "The name of the HRC Admin web app"
  type        = string
}

variable "redis_cache_name" {
  description = "The name of the Azure Cache for Redis resource"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}
variable "storage_account_tier" {
  description = "Storage Account Tier"
  type        = string
}
variable "storage_account_replication_type" {
  description = "Storage Account Replication Type"
  type        = string
}
variable "storage_account_kind" {
  description = "Storage Account Kind"
  type        = string
}

variable "blob_names" {
  description = "A list with blob names for FE and BE"
  type        = list(any)
}

variable "address_spaces_to_locations" {
  description = "A dictionary for Vnet address spaces and locations"
  type        = map(string)
}

variable "address_prefixes_to_locations" {
  description = "A dictionary for Vnet address spaces and locations"
  type        = map(string)
}

variable "private_connection_resource_id" {
  description = "A list of Private Link Connections"
  type        = map(string)
}

variable "tags" {
  description = "Tags for Azure resources"
  type        = map(string)

}