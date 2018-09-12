# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.azure_subscription_id}"
  client_id       = "${var.azure_client_id}"
  client_secret   = "${var.azure_client_secret}"
  tenant_id       = "${var.azure_tenant_id}"
}


# # Remote State Storage for the Kubernetes cluster.
# # Uses AzureRM Backend created previously.

terraform {
  backend "azurerm" {
    resource_group_name = "tfstorage_rg"
    storage_account_name = "terraformstoragetest"
    container_name       = "tfstoragecontainer"
    key                  = "petclinic-kubernetes.tfstate"
  }
}
resource "azurerm_resource_group" "k8s" {
  name     = "${var.rg_name}"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name            = "default"
    count           = "${var.agent_count}"
    vm_size         = "Standard_B2s"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.azure_client_id}"
    client_secret = "${var.azure_client_secret}"
  }

}
