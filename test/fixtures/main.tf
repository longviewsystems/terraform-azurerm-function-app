/***************************************************************/
/*** Terratest only resources
/***************************************************************/
data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.3.0"
  prefix = ["terratest"]  
}
resource "azurerm_resource_group" "resource_group" {
  name     = module.naming.resource_group.name
  location = var.location
}

resource "azurerm_service_plan" "service_plan" {
  name                = module.naming.app_service_plan.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_log_analytics_workspace" "function_analytics_workspace" {
  name                = module.naming.log_analytics_workspace.name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  retention_in_days   = 30
}

resource "azurerm_application_insights" "function_insights" {
  name                = module.naming.application_insights.name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = var.application_type_insights
  workspace_id        = azurerm_log_analytics_workspace.function_analytics_workspace.id
}

/***************************************************************/
/*** Resources to be tested
/***************************************************************/

resource "random_string" "storage_account_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${module.naming.storage_account.name}${random_string.storage_account_suffix.result}"
  location                 = azurerm_resource_group.resource_group.location
  resource_group_name      = azurerm_resource_group.resource_group.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags

}

resource "azurerm_windows_function_app" "function_app" {
  name                        = module.naming.function_app.name
  location                    = azurerm_resource_group.resource_group.location
  resource_group_name         = azurerm_resource_group.resource_group.name
  service_plan_id             = azurerm_service_plan.service_plan.id
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
      allowed_origins     = ["https://portal.azure.com"]      
    }
  }
  app_settings = var.fuction_app_settings
  identity {
    type = "SystemAssigned"
  }
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