resource "azurerm_storage_account" "storage_account" {
  name                     = var.function_storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags

}

resource "azurerm_private_endpoint" "sa" {
  count               = var.create_private_endpoint ? 1 : 0
  name                = "testprivateendpoint"  #change this
  location            = var.location
  resource_group_name = var.sa_rg_name
  subnet_id           = var.private_endpoint_subnet_id

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = var.storage_blob_private_dns_zone_ids
  }

  private_service_connection {
    name                           = "testpeconnection"   #change this
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.tags

}

resource "azurerm_virtual_network" "vnet" {
  name                 = var.virtual_network_id
  resource_group_name  = var.resource_group_name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "vnet_subnet" {
  name                 = "function-app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/16"]

}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  name                 = var.private_dns_zone_link_name
  resource_group_name = var.resource_group_name
  virtual_network_id   = azurerm_virtual_network.vnet.id
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                 = var.private_dns_zone_name
  resource_group_name  = var.resource_group_name
}


resource "azurerm_windows_function_app" "function_app" {
  name                        = var.function_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = var.service_plan_id
  storage_account_name        = azurerm_storage_account.storage_account.name
  storage_account_access_key  = azurerm_storage_account.storage_account.primary_access_key
  functions_extension_version = "~4"
  enabled                     = true

  site_config {
    always_on                              = try(var.function_site_config.always_on, true)
    ftps_state                             = try(var.function_site_config.ftps_state, "Disabled")
    application_insights_connection_string = try(var.function_site_config.application_insights_connection_string, null)
    application_insights_key               = try(var.function_site_config.application_insights_key, null)

    application_stack {
      powershell_core_version = "7.2"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }

  app_settings = var.fuction_app_settings
  
  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-resource-id"],
      tags["hidden-link: /app-insights-instrumentation-key"],
    ]
  }

}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_sets" {
  count              = var.create_diagnostics ? 1 : 0
  name               = "${var.function_name}-diag-setting"
  target_resource_id = azurerm_windows_function_app.function_app.id
  storage_account_id = azurerm_storage_account.storage_account.id

  enabled_log {
    category = "FunctionAppLogs"
    retention_policy {
      days    = 90
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    retention_policy {
      days    = 90
      enabled = true
    }
  }

}