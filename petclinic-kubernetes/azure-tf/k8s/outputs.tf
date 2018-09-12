# Ref:
# https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html
# Sensitive Outputs: https://www.terraform.io/docs/configuration/outputs.html#sensitive-outputs

output "id" {
  value     = "${azurerm_kubernetes_cluster.k8s.id}"
}

output "kube_config" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
  sensitive = true
}

output "client_certificate" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate}"
  sensitive = true
}

output "client_key" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_key}"
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate}"
  sensitive = true
}

output "host" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}

output "username" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.username}"
}

output "password" {
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.password}"
  sensitive = true
}
