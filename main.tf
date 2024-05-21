resource "azurerm_storage_account" "storage_account" {
  name                     = var.function_storage_account_name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags

}

resource "azure_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = []  # TODO:add this
  Subnets {  
    name          = "function_subnet"
    address_prefixes = ["10.0.1.0/24"]
  }
}

resource "azurerm_subnet_private_endpoint_network_policies" "subnet_policy" {
  name                 = var.vnet_name + "_subnet_policy"
  virtual_network_name = azurerm_virtual_network.vnet.name
  subnet_name          = azurerm_virtual_network.vnet.subnets[0].name
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_endpoint" "function_app_endpoint" {
  name                = var.function_app_endpoint_name
  subnet_id           = azurerm_virtual_network.vnet.subnets[0].id
  location            = var.location
  resource_group_name = var.resource_group_name

  private_service_connection {
    name                           = "[concat(resourceGroup().name, '/providers/Microsoft.Web/locations/', var.location, '/managedHostingEnvironments/', var.function_app_service_plan_name)]"
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
    name = "system"
  }

  tags = var.tags
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