# MediaWiki
Load-balanced MediaWiki instance on Kubernetes on AWS.

## Tools Used


| Tool | Notes |
|-|-|
| AWS | Cloud Technology |
| Ansible 2.5.x | Overall Controller.<br>Controller Machine is my Windows 10 laptop and Ansible is running on Windows Subsystem for Linux. |
| Docker 17.03-ce | Docker for Windows used to develop the solution.<br> |


## Overall Flow

1. Create Docker Image for MediaWiki using Ansible-managed Dockerfile.
1. Push to AWS Elastic Container Registry.

```
docker.exe run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD='C4@ng3M3n00w' -e MYSQL_USER=mwiki -e MYSQL_PASSWORD='_fu-EsR9=YZD#=7H' -e MYSQL_DATABASE=mwdatabase --name mysql mysql:5.7
```

MediaWiki admin user: admin  / Adm1nAgility

## Key Points

**Variable Structure**:

1. Environment-independent data is stored in role defaults, and environment-dependent data goes into `inventories/<env>/`.
1. Secrets are environment-specific and stored in `inventories/<env>/group_vars/all/vault.yml`.


## Notes, Tips and Gotchas

Please see [notes.md](notes.md) for observations and notes from developing this code.
