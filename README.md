# Overview
This repo contains a Infrastructure Module that creates an Azure Function.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | > 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.61.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.function_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.function_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.diagnostic_sets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.azure_function](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.service_plan](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |
| [azurerm_storage_account.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_windows_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [random_string.storage_account_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_role_definition.contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_diagnostics"></a> [create\_diagnostics](#input\_create\_diagnostics) | If the value is false, no Diagnostics data will be sent the Storage Account set in diag\_storage\_account\_id. | `bool` | `true` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the service app. | `string` | n/a | yes |
| <a name="input_function_storage_account_name"></a> [function\_storage\_account\_name](#input\_function\_storage\_account\_name) | The backend storage account name which will be used by this Function App. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location used to deploy the resources | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | Name of the service plan. | `string` | n/a | yes |
| <a name="input_service_plan_sku"></a> [service\_plan\_sku](#input\_service\_plan\_sku) | SKU of the service plan. | `string` | `"Y1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be assigned to the resources | `map(string)` | `{}` | no |
| <a name="input_user_identity_type"></a> [user\_identity\_type](#input\_user\_identity\_type) | The type of identity used for the Function App.This maps to the azurerm\_windows\_function\_app identity.type. | `string` | `"SystemAssigned"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_default_site_hostname"></a> [function\_default\_site\_hostname](#output\_function\_default\_site\_hostname) | The Default Hostname associated with the App Service - such as mysite.azurewebsites.net |
| <a name="output_function_id"></a> [function\_id](#output\_function\_id) | ID of the App Service. |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the App Service. |

