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
    always_on                              = true
    ftps_state                             = "AllAllowed"
    application_insights_connection_string = null
    application_insights_key               = null
  }
}

variable "fuction_app_settings" {
  type        = map(string)
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

variable "diag_storage_account_id" {
  type        = string
  description = "The ID of the Storage Account where the diagnostics data will be sent."
}


variable "private_dns_zone_name" {
  type        = string
  description = "The name of the private DNS zone to create."
}

variable "private_dns_zone_link_name" {
  type        = string
  description = "The name of the private DNS zone link to create."
}

/***************************************************************/

variable "create_private_endpoint" {
  type        = bool
  description = "If the value is false, no private endpoint will be created."
  default     = true
}

variable "sa_rg_name" {
  type        = string
  description = "The name of the resource group where the storage account is located." 
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "The ID of the subnet where the private endpoint will be created."
}

variable "storage_blob_private_dns_zone_ids" {
  type        = list(string)
  description = "The IDs of the private DNS zones to link to the private endpoint."
}

variable "private_dns_zone_group_name" {
  type        = string
  description = "The name of the private DNS zone group to create."
}
