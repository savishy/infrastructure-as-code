module "azurerm-backend" {
  source = "../../../terraform-common/azurerm-backend"
  azure_client_id = "${var.azure_client_id}"
  azure_client_secret = "${var.azure_client_secret}"
  azure_tenant_id = "${var.azure_tenant_id}"
  azure_subscription_id = "${var.azure_subscription_id}"
}

resource "local_file" "tfsecrets" {
  content     = <<EOF
export ARM_ACCESS_KEY='${module.azurerm-backend.access_key}'
EOF
  filename = "${path.module}/tfsecrets.sh"
}
