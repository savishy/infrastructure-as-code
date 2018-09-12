variable rg_name { default = "KubeDev" }
variable cluster_name { default = "kubedev" }
variable location { default = "eastus" }
variable dns_prefix { default = "kubedev" }
variable admin_username { default = "ubuntu" }
variable ssh_public_key { default = "~/.ssh/id_rsa.pub" }
variable agent_count { default = 1 }
variable agent_size { default = "Standard_B2s" }
variable azure_client_id {}
variable azure_client_secret {}
variable azure_subscription_id {}
variable azure_tenant_id {}