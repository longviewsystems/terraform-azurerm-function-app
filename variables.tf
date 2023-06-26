/***************************************************************/
/*** Azure Provider Settings
/***************************************************************/

variable "function_name" {
  type        = string
  description = "Name of the service app."
}

variable "location" {
  type        = string
  description = "Location used to deploy the resources"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "tags" {
  type        = map(string)
  description = "Tags to be assigned to the resources"
  default     = {}
}

/***************************************************************/
/*** Function App Settings
/***************************************************************/

variable "service_plan_id" {
  type        = string
  description = "The ID of the App Service Plan which will host this Function App."

}

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

