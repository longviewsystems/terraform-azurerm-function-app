## Overview
This Terraform module provisions a Azure Function with a PowerShell as the Application Stack.

Functionality Supported:
- Create a Function App
- Test with Terratest
- Generate README.md pdf

Note: 

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->





## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.61.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diagnostic_sets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_storage_account.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_windows_function_app.function_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [random_string.storage_account_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_diagnostics"></a> [create\_diagnostics](#input\_create\_diagnostics) | If the value is false, no Diagnostics data will be sent the Storage Account set in diag\_storage\_account\_id. | `bool` | `true` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the service app. | `string` | n/a | yes |
| <a name="input_function_site_config"></a> [function\_site\_config](#input\_function\_site\_config) | Application site config for the App Service.  This maps to the azurerm\_windows\_function\_app site\_config. | <pre>object({<br>    always_on                              = bool,<br>    ftps_state                             = string,<br>    application_insights_connection_string = string,<br>    application_insights_key               = string<br>  })</pre> | <pre>{<br>  "always_on": false,<br>  "application_insights_connection_string": null,<br>  "application_insights_key": null,<br>  "ftps_state": "AllAllowed"<br>}</pre> | no |
| <a name="input_function_storage_account_name"></a> [function\_storage\_account\_name](#input\_function\_storage\_account\_name) | The backend storage account name which will be used by this Function App. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location used to deploy the resources | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_service_plan_id"></a> [service\_plan\_id](#input\_service\_plan\_id) | The ID of the App Service Plan which will host this Function App. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be assigned to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_default_site_hostname"></a> [function\_default\_site\_hostname](#output\_function\_default\_site\_hostname) | The Default Hostname associated with the App Service - such as mysite.azurewebsites.net |
| <a name="output_function_id"></a> [function\_id](#output\_function\_id) | ID of the App Service. |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the App Service. |
<!-- END_TF_DOCS -->    

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->