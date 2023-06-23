data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_string" "storage_account_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "function_app" {
  name                     = lower("${var.function_storage_account_name}${random_string.storage_account_suffix.result}")
  location                 = azurerm_resource_group.resource_group.location
  resource_group_name      = azurerm_resource_group.resource_group.name
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags

}

resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

resource "azurerm_windows_function_app" "function_app" {
  name                        = var.function_name
  location                    = azurerm_resource_group.resource_group.location
  resource_group_name         = azurerm_resource_group.resource_group.name
  service_plan_id             = azurerm_service_plan.service_plan.id
  storage_account_name        = azurerm_storage_account.function_app.name
  storage_account_access_key  = azurerm_storage_account.function_app.primary_access_key
  functions_extension_version = "~4"
  enabled                     = true

  identity {

    type = var.user_identity_type

  }
  site_config {
    application_insights_connection_string = try(azurerm_application_insights.function_insights.connection_string, null)
    application_insights_key               = try(azurerm_application_insights.function_insights.instrumentation_key, null)
    application_stack {
      powershell_core_version = "7.2"
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

resource "azurerm_role_assignment" "azure_function" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_windows_function_app.function_app.identity[0].principal_id
}

resource "azurerm_log_analytics_workspace" "function_analytics_workspace" {
  name                = "${var.function_name}-analytics-workspace"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  retention_in_days   = 30
}

resource "azurerm_application_insights" "function_insights" {
  name                = var.function_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  application_type    = var.application_type_insights
  workspace_id        = azurerm_log_analytics_workspace.function_analytics_workspace.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_sets" {
  count              = var.create_diagnostics ? 1 : 0
  name               = "${var.function_name}-diag-setting"
  target_resource_id = azurerm_windows_function_app.function_app.id
  storage_account_id = azurerm_storage_account.function_app.id

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