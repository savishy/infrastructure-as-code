# https://www.terraform.io/docs/configuration/variables.html
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}
variable "azure_subscription_id" {}
variable "location" { default = "north europe"}
variable "tfstorageaccount_rg_name" { default = "tfstorage_rg" }
variable "tfstorageaccount_name" { default = "terraformstoragetest" }
