output "frontend_url" {
  value = azurerm_storage_account.frontend.primary_web_endpoint
}

output "cdn_endpoint_url" {
  value = "https://${azurerm_cdn_endpoint.frontend.host_name}"
}