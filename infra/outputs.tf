output "cdn_endpoint_hostname" {
  value = azurerm_cdn_endpoint.frontend.fqdn
}

output "static_website_url" {
  value = azurerm_storage_account.frontend.primary_web_endpoint
}