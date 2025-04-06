locals {
  common_tags = {
    Project     = "Cloud Resume Challenge"
    Environment = var.environment
  }
}

resource "azurerm_resource_group" "crc" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = "eastus"
  tags     = local.common_tags
}

resource "azurerm_storage_account" "frontend" {
  name                     = "${lower(var.project_name)}${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.crc.name
  location                 = azurerm_resource_group.crc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  tags                     = local.common_tags
}

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account_static_website" "frontend" {
  storage_account_id = azurerm_storage_account.frontend.id
  index_document     = "index.html"
}

resource "azurerm_cdn_profile" "frontend" {
  name                = "${var.project_name}-${var.environment}-cdn"
  location            = azurerm_resource_group.crc.location
  resource_group_name = azurerm_resource_group.crc.name
  sku                 = "Standard_Microsoft"
  tags                = local.common_tags
}

resource "azurerm_cdn_endpoint" "frontend" {
  name                = "${var.project_name}-${var.environment}-endpoint"
  profile_name        = azurerm_cdn_profile.frontend.name
  location            = azurerm_resource_group.crc.location
  resource_group_name = azurerm_resource_group.crc.name
  origin_host_header  = azurerm_storage_account.frontend.primary_web_host
  
  origin {
    name      = "storagestaticwebsite"
    host_name = azurerm_storage_account.frontend.primary_web_host
  }
  
  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1
    
    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }
    
    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }
  
  tags = local.common_tags
}
