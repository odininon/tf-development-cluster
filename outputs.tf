output "acr_username" {
  description = "Username for connecting to ACR"
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_password" {
  description = "Password for connecting to ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "acr_login" {
  description = "Login_user for connecting to ACR"
  value       = azurerm_container_registry.acr.login_server
}
