variable azure_client_id {}
variable azure_client_secret {}
variable azure_tenant_id {}
variable azure_subscription_id {}

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

# Call module to create k8s cluster

module "k8s" {
  source = "./k8s"
  azure_client_id = "${var.azure_client_id}"
  azure_client_secret = "${var.azure_client_secret}"
  azure_tenant_id = "${var.azure_tenant_id}"
  azure_subscription_id = "${var.azure_subscription_id}"

}

module "deploy" {
  source = "./deploy"
  username = "${module.k8s.username}"
  password = "${module.k8s.password}"
  host = "${module.k8s.host}"
  client_certificate = "${module.k8s.client_certificate}"
  client_key = "${module.k8s.client_key}"
  cluster_ca_certificate = "${module.k8s.cluster_ca_certificate}"

}
