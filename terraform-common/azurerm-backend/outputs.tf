# Retrieve Data from Data Sources configured in main.tf.
# Ref https://www.terraform.io/docs/providers/azurerm/d/storage_account.html

output "access_key" {
  value = "${data.azurerm_storage_account.tfstorageaccount_data.secondary_access_key}"
}

output "sas_token" {
  value = "${data.azurerm_storage_account_sas.tfsas.sas}"
}
