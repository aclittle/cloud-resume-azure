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
  name                     = "crc${replace(lower(var.project_name), "/[^a-z0-9]/", "")}frontend"
  resource_group_name      = azurerm_resource_group.crc.name
  location                 = azurerm_resource_group.crc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  tags                     = local.common_tags
}

resource "azurerm_storage_account_static_website" "frontend" {
  storage_account_id = azurerm_storage_account.frontend.id
  index_document     = "index.html"
}
