# Kubernetes on Azure

This Terraform plan creates a Kubernetes cluster on Azure (AKS) and creates an auto-scaling service for a sample application, [Petclinic](http://github.com/savishy/spring-petclinic).

The containerized form of this service is used, available as [`savishy/springboot-petclinic`](https://hub.docker.com/r/savishy/springboot-petclinic/).

## Prerequisites

1. Tested on Ubuntu 16.04.
1. Terraform for [your Operating System](https://www.terraform.io/downloads.html).
1. Azure CLI.
1. Azure Account. Azure CLI must be logged in.
1. (Optional) Ansible (specifically Ansible Vault). This is because I use Ansible Vault to store the Azure credentials encrypted.

## How to run

* Set the Azure environment variables as well as other required environment variables.
  A helper script is available in the `terraform-common` dir which has the credentials encrypted with Ansible Vault.
  You can set them in the environment via dot-sourcing:
  `. <(ansible-vault view setenv-azure.sh)`

* Create the AzureRM Storage Backend.
  ```
  cd backend/
  terraform init|plan|apply
  ```

* This outputs a file `tfsecrets.sh` which you need to dot-source to set the environment.

Next you can run the usual flow of `terraform init | plan | apply`.

> #### Read the Notes for why you need  to run module-by-module.

`terraform init|plan|apply -target=module.k8s`

At this stage you can check the cluster state with `kubectl`.

```
$ kubectl cluster-info
Kubernetes master is running at https://kubedev-XXXXXXX.hcp.eastus.azmk8s.io:443
Heapster is running at https://kubedev-XXXXXXX.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://kubedev-XXXXXXX.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://kubedev-XXXXXXX.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy

$ kubectl get nodes
NAME                     STATUS    ROLES     AGE       VERSION
aks-default-XXXXXXXX-0   Ready     agent     17h       v1.9.9

```

Next, deploy to the cluster.

`terraform init|plan|apply -target=module.deploy`

Check the deployment status:

```
  $ kubectl get pods
NAME                READY     STATUS    RESTARTS   AGE
petclinicrc-55rtg   1/1       Running   0          20m
petclinicrc-sn8gg   1/1       Running   0          20m

$ kubectl get services
NAME               TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)          AGE
kubernetes         ClusterIP      10.0.0.1      <none>           443/TCP          18h
petclinicservice   LoadBalancer   10.0.XX.211   XX.YY.138.230   8080:30755/TCP   29m

$ kubectl get rc
NAME          DESIRED   CURRENT   READY     AGE
petclinicrc   2         2         2         29m

$ kubectl get hpa
NAME              REFERENCE                           TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
petclinicscaler   ReplicationController/petclinicrc   <unknown>/80%   2         5         2          1m

```

Browse to `<external-ip>:8080` to view the Petclinic application.

## How it works

* The top-level `main.tf` calls the `k8s` module first, then the `deploy` module.
* The `k8s` module provisions an AKS cluster and configures your local `~/.kube/config`.
* The `deploy` module uses credentials from the `k8s` module to deploy Petclinic (`savishy/springboot-petclinic`) on to the cluster.


## Notes

### `-target` needs to be passed to terraform commands.

* Terraform 0.11.x does not handle dependencies very well. In this case if the K8S cluster has not been created (or if local kubeconfig has not been done by Terraform yet) the `deploy` module would fail with an error similar to: `* module.deploy.provider.kubernetes: Failed to load config (/home/vish/.kube/config; default context): invalid configuration: no configuration has been provided`.

  So you need to use the workaround defined [in this link](https://github.com/hashicorp/terraform/issues/2430#issuecomment-195430847) to plan/apply each module at a time.

  ```
  terraform plan -target=module.k8s
  ```

### `kubernetes` provider has issues with `username` and `password` arguments.

Originally I had configured the kubernetes provider with the username and password as per the [references](https://www.hashicorp.com/blog/kubernetes-cluster-with-aks-and-terraform).

```
provider "kubernetes" {
  host     = "${var.host}"
  username = "${var.username}"
  password = "${var.password}"
  config_context_cluster = "${var.cluster_name}"
  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
}

```

This however throws an error which is also [an open issue](https://github.com/terraform-providers/terraform-provider-kubernetes/issues/175).

```
$ terraform plan -target=module.deploy
Acquiring state lock. This may take a few moments...
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

azurerm_resource_group.k8s: Refreshing state... (ID: /subscriptions/8293ee7a-e6fd-4c76-9117-586fdbafa108/resourceGroups/KubeDev)
azurerm_kubernetes_cluster.k8s: Refreshing state... (ID: /subscriptions/8293ee7a-e6fd-4c76-9117-...ntainerService/managedClusters/kubedev)
Releasing state lock. This may take a few moments...

Error: Error refreshing state: 1 error(s) occurred:

* module.deploy.provider.kubernetes: Failed to configure: username/password or bearer token may be set, but not both

```

Solution is to remove the username/password - the client certificate seems to be enough.

### If you get this error, you likely have a too old `kubectl`.

```
$ kubectl get nodes
error: group map[............] is already registered
```

I had Kubectl 1.3 (!) which was the cause.


## References

1. https://www.hashicorp.com/blog/kubernetes-cluster-with-aks-and-terraform
1. https://www.terraform.io/docs/backends/types/azurerm.html
