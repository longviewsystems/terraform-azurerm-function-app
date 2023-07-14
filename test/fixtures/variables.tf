variable "function_name" {
  type        = string
  description = "Name of the service app."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location used to deploy the resources"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to the resources"
  default     = {}
}

variable "service_plan_name" {
  type        = string
  description = "Name of the service plan."
}

variable "service_plan_sku" {
  type        = string
  description = "SKU of the service plan."
  default     = "Y1"
}

/***************************************************************/
/*** Function App Settings
/***************************************************************/

variable "function_site_config" {
  type = object({
    always_on                              = bool,
    ftps_state                             = string,
    application_insights_connection_string = string,
    application_insights_key               = string
  })
  description = "Application site config for the App Service.  This maps to the azurerm_windows_function_app site_config."
  default = {
    always_on                              = false
    ftps_state                             = "AllAllowed"
    application_insights_connection_string = null
    application_insights_key               = null
  }
}

variable "fuction_app_settings" {
  type = map(string)
  description = "Application settings for the App Service.  This maps to the azurerm_windows_function_app app_settings."
  default = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    
  }
}

/***************************************************************/
/*** Function App Storage Account
/***************************************************************/

variable "function_storage_account_name" {
  type        = string
  description = " The backend storage account name which will be used by this Function App."
}

/***************************************************************/
/***  Logging and diagnostics
/***************************************************************/

variable "create_diagnostics" {
  type        = bool
  description = "If the value is false, no Diagnostics data will be sent the Storage Account set in diag_storage_account_id."
  default     = true
}
variable "application_type_insights" {
  type        = string
  description = "If the value is true, Application Insights will be enabled for the Function App."
  default     = "other"
}

