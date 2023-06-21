output "function_name" {
  description = "Name of the App Service."
  value       = azurerm_windows_function_app.function_app.name
}

output "function_id" {
  description = "ID of the App Service."
  value       = azurerm_windows_function_app.function_app.id
}

output "function_default_site_hostname" {
  description = "The Default Hostname associated with the App Service - such as mysite.azurewebsites.net"
  value       = azurerm_windows_function_app.function_app.default_hostname
}

