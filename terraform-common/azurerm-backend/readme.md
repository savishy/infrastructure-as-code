# Terraform - AzureRM Backend

Creates a storage backend on Azure for state storage for Terraform.

## Prerequisites

* Create an Azure account and get your `AZURE_SUBSCRIPTION_ID`. 
* Create an Azure Service Principal and get the details for `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`.
* Update the values in the `setenv-azure.ps1` script. 

Example through Azure CLI (Cloud Shell):

```
$ az ad sp create-for-rbac
{
  "appId": "this-is-your-client-id",
  "displayName": "azure-cli-2018-08-30-06-58-09",
  "name": "http://azure-cli-2018-08-30-06-58-09",
  "password": "some password - this is your client secret",
  "tenant": "this-is-your-tenant-id"
}
```

Get your Azure Subscription through the Azure CLI (Cloud Shell):

```
$ az account show
{
  "environmentName": "AzureCloud",
  "id": "this-is-your-subscription-id",
  ...
  ...
}
```

## How to run

* Execute `setenv-azure.ps1` in a Powershell Terminal
* Execute `terraform init`
* Execute `terraform plan`
* Execute `terraform apply`.

Verify from the Azure Portal. A storage account with a blob storage container would have been created.

![image](https://user-images.githubusercontent.com/13379978/44835803-e4292e80-ac52-11e8-930d-ccda1e416892.png)
