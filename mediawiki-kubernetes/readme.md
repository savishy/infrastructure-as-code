# MediaWiki
Load-balanced MediaWiki instance on Kubernetes on AWS.

## Tools Used


| Tool | Notes |
|-|-|
| AWS | Cloud Technology |
| Ansible 2.5.x | Overall Controller.<br>Controller Machine is my Windows 10 laptop and Ansible is running on Windows Subsystem for Linux. |
| Docker 17.03-ce | Docker for Windows used to develop the solution.<br> |
| MySQL 5.7 | Runs within a Docker container. |
| MediaWiki 1.31.0 | Runs within a Docker container. |

## How to run

Run the playbooks in order i.e.

`ansible-playbook -vvv --ask-vault-pass -i inventories/dev/ <PLAYBOOK>.yml -e ansible_ssh_private_key_file=/path/to/keypair.pem`

Replace `PLAYBOOK` with the playbooks to be run.

_Note: you can also run the playbooks all at once if required but I have not validated this._

| Task | Playbook |
|-|-|
| instances | `0vms.yml` |
| docker setup | `1docker.yml` |
| database | `2db.yml` |
| mediawiki | `3mediawiki.yml` |

## Overall Flow

1. Create Docker Image for MediaWiki using Ansible-managed Dockerfile.
1. Push to AWS Elastic Container Registry.

## Key Points

**Variable Structure**:

1. Environment-independent data is stored in role defaults, and environment-dependent data goes into `inventories/<env>/`.
1. Secrets are environment-specific and stored in `inventories/<env>/group_vars/all/vault.yml`.


## Notes, Tips and Gotchas

Please see [notes.md](notes.md) for observations and notes from developing this code.
