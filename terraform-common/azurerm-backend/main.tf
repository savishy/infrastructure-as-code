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
  name                  = "${var.tfstoragecontainer_name}"
  resource_group_name   = "${azurerm_resource_group.tfstoragerg.name}"
  storage_account_name  = "${azurerm_storage_account.tfstorageaccount.name}"
  container_access_type = "blob"
}


# Configure a Data Source that retrieves the SAS Token for this storage account.
# https://www.terraform.io/docs/providers/azurerm/d/storage_account_sas.html
data "azurerm_storage_account_sas" "tfsas" {
    connection_string = "${azurerm_storage_account.tfstorageaccount.primary_connection_string}"
    https_only        = true
    resource_types {
        service   = true
        container = false
        object    = false
    }
    services {
        blob  = true
        queue = false
        table = false
        file  = false
    }
    start   = "2018-09-10"
    expiry  = "2035-03-21"
    permissions {
        read    = true
        write   = true
        delete  = true
        list    = true
        add     = true
        create  = true
        update  = true
        process = true
    }
}

# Configure a Data Source that gets the secondary access key for this storage account.
# https://www.terraform.io/docs/providers/azurerm/d/storage_account.html

data "azurerm_storage_account" "tfstorageaccount_data" {
  name = "${var.tfstorageaccount_name}"
  resource_group_name = "${azurerm_resource_group.tfstoragerg.name}"
}
