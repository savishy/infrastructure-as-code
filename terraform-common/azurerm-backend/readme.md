* Create an Azure account and get your `AZURE_SUBSCRIPTION_ID`. 
* Create an Azure Service Principal and get the details for `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`.

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
