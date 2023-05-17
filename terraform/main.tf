#########Resource Group Block#################
resource "azurerm_resource_group" "tw-rg-dev" {
  name     = var.resource_group_name
  location = var.rg_location
  tags     = var.tags
  lifecycle {
    prevent_destroy = true
  }
}
##############################################

#########HRC-Admin App Service Block##########
resource "azurerm_service_plan" "tw-sp-dev-admin" {
  for_each            = toset(slice(var.location, 0, 2))
  name                = "${var.service_plan_name_admin}-${each.value}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  location            = each.key
  sku_name            = "P1v2"
  os_type             = "Windows"
  worker_count        = "1"
  #   maximum_elastic_worker_count = "10"
}

resource "azurerm_windows_web_app" "tw-webapp-dev-admin" {
  for_each            = toset(slice(var.location, 0, 2))
  name                = "${var.web_app_name_admin}-${each.value}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  location            = each.key
  service_plan_id     = azurerm_service_plan.tw-sp-dev-admin[each.key].id

  site_config {}
}
###############################################

#########HRC-Client App Service Block##########
resource "azurerm_service_plan" "tw-sp-dev-client" {
  for_each            = toset(var.location)
  name                = "${var.service_plan_name_client}-${each.value}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  location            = each.key
  sku_name            = "P1v2"
  os_type             = "Windows"
  worker_count        = "3"
  #   maximum_elastic_worker_count = "10"
}

resource "azurerm_windows_web_app" "tw-webapp-dev-client" {
  for_each            = toset(var.location)
  name                = "${var.web_app_name_client}-${each.value}-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  location            = each.key
  service_plan_id     = azurerm_service_plan.tw-sp-dev-client[each.key].id

  site_config {}
}

resource "azurerm_monitor_autoscale_setting" "default_client" {
  for_each            = toset(slice(var.location, 0, 2))
  name                = "myAutoscaleSetting-${each.key}"
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  location            = var.location[0]
  target_resource_id  = azurerm_service_plan.tw-sp-dev-client[each.key].id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }

    rule {
      metric_trigger {
        metric_name        = "CPU Percentage"
        metric_resource_id = azurerm_service_plan.tw-sp-dev-client[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
        metric_namespace   = "Standard metrics"
        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = [azurerm_windows_web_app.tw-webapp-dev-client[each.key].name]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CPU Percentage"
        metric_resource_id = azurerm_service_plan.tw-sp-dev-client[each.key].id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
        metric_namespace   = "Standard metrics"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = true
      send_to_subscription_co_administrator = true
      custom_emails                         = ["npetmarkov@gmail.com"] # switch to A. Rosenfrisk, Erik Riggles, Derek Nicols, etc.
    }
  }
}
##############################################

############Front Door Service Block##########
resource "azurerm_dns_zone" "tw-dns-dev" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
}

resource "azurerm_cdn_frontdoor_profile" "tw-cdn-profile-dev" {
  name                = var.front_door_profile_name
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  sku_name            = var.front_door_sku_name
}

resource "azurerm_cdn_frontdoor_custom_domain" "tw-frontdoor-dev" {
  name                     = var.front_door_custom_domain_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.tw-cdn-profile-dev.id
  dns_zone_id              = azurerm_dns_zone.tw-dns-dev.id
  host_name                = var.cdn_host_name

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}
##############################################

##############Redis Cache Block###############
# resource "azurerm_redis_cache" "tw-redis" {
#   name                = var.redis_cache_name
#   location            = azurerm_resource_group.tw-rg-dev.location
#   resource_group_name = azurerm_resource_group.tw-rg-dev.name
#   capacity            = 2
#   family              = "C"
#   sku_name            = "Standard"
#   enable_non_ssl_port = false
#   minimum_tls_version = "1.2"

#   redis_configuration {
#   }
# }
###################################################

##############Storage Accoount Block###############
resource "azurerm_storage_account" "tw-storage-account" {
  name                = var.storage_account_name
  resource_group_name = azurerm_resource_group.tw-rg-dev.name

  location                 = azurerm_resource_group.tw-rg-dev.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

resource "azurerm_storage_container" "tw-blob" {
  for_each              = toset(var.blob_names)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.tw-storage-account.name
  container_access_type = "private"
}
###################################################
