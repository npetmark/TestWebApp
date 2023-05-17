location                         = ["northcentralus", "eastus", "eastus2"]
resource_group_name              = "HRCenter-2023-Dev"
service_plan_name_client         = "hrc-client-sp-dev"
web_app_name_client              = "hrc-client-webapp-dev"
service_plan_name_admin          = "hrc-admin-sp-dev"
web_app_name_admin               = "hrc-admin-webapp-dev"
redis_cache_name                 = "hrc-shared-redis-cache-dev"
storage_account_name             = "hrcsadevshared"
storage_account_tier             = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind             = "StorageV2"
blob_names                       = ["hrcenter-admin", "hrcenter-client"]
dns_zone_name                    = "hrc-dns.dev.com"
front_door_profile_name          = "hrc-shared-frontdoor-dev"
front_door_sku_name              = "Standard_AzureFrontDoor"
front_door_custom_domain_name    = "hrc-shared-frontdoor-dev-custom-domain"
cdn_host_name                    = "tempworks.com"
address_spaces_to_locations = {
  "northcentralus" = "10.81.0.0/16"
  "eastus"         = "10.82.0.0/16"
  "eastus2"        = "10.83.0.0/16"
}
address_prefixes_to_locations = {
  "northcentralus" = "10.81.130.0/24"
  "eastus"         = "10.82.130.0/24"
  "eastus2"        = "10.83.130.0/24"
}

private_connection_resource_id = {
  "eastus"     = "/subscriptions/7de7dbb6-ae45-4582-ad54-601570038e6b/resourceGroups/Test-RG/providers/Microsoft.Network/privateLinkServices/myPrivateLinkService"
  "westeurope" = "/subscriptions/7de7dbb6-ae45-4582-ad54-601570038e6b/resourceGroups/Test-RG/providers/Microsoft.Network/privateLinkServices/myPrivateLinkService2"
  "uksouth"    = "/subscriptions/7de7dbb6-ae45-4582-ad54-601570038e6b/resourceGroups/Test-RG/providers/Microsoft.Network/privateLinkServices/myPrivateLinkService3"
}

tags = {
  "provisioning-ticket" = "https://tempworks.freshservice.com/a/tickets/15150"
}