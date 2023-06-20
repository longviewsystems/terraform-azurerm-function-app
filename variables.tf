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

variable "user_identity_type" {
  type        = string
  description = "The type of identity used for the Function App.This maps to the azurerm_windows_function_app identity.type."
  default     = "SystemAssigned"
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

