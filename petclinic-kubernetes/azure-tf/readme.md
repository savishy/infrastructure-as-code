# Kubernetes on Azure

This Terraform plan creates a Kubernetes cluster on Azure (AKS) and creates a service for a sample application, [Petclinic](http://github.com/savishy/spring-petclinic).

## Prerequisites

1. Terraform for [your Operating System](https://www.terraform.io/downloads.html).
1. Azure CLI.
1. Azure Account. Azure CLI must be logged in.
1. (Optional) Ansible (specifically Ansible Vault). This is because I use Ansible Vault to store the Azure credentials encrypted.

## How to run

Set the Azure environment variables as well as other required environment variables.

A helper script is available in the `terraform-common` dir which has the credentials encrypted with Ansible Vault.

You can set them in the environment via:

`. <(ansible-vault view setenv-azure.sh)``

Next you can run the usual flow of `terraform init | plan | apply`.

## References

1. https://www.hashicorp.com/blog/kubernetes-cluster-with-aks-and-terraform
1. https://www.terraform.io/docs/backends/types/azurerm.html
