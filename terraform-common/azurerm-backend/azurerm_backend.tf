# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
}

resource "azurerm_resource_group" "tfstoragerg" {
  name     = "${var.tfstorageaccount_rg_name}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "tfstorageaccount" {
  name                     = "${var.tfstorageaccount_name}"
  resource_group_name      = "${azurerm_resource_group.tfstoragerg.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "tfstoragecontainer" {
  name                  = "tfstoragecontainer"
  resource_group_name   = "${azurerm_resource_group.tfstoragerg.name}"
  storage_account_name  = "${azurerm_storage_account.tfstorageaccount.name}"
  container_access_type = "blob"
}
