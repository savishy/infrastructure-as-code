# MediaWiki
Load-balanced MediaWiki instance on Kubernetes on AWS.

## Tools Used


| Tool | Notes |
|-|-|
| AWS | Cloud Technology |
| Ansible 2.5.x | Overall Controller.<br>Controller Machine is my Windows 10 laptop and Ansible is running on Windows Subsystem for Linux. |
| Docker 18 | Containerization |
| AWS ECR | Container Registry |
| MySQL 5.7 | Runs within a Docker container. |
| MediaWiki 1.31.0 | Runs within a Docker container. |

## Prerequisites

1. Windows 10 1706+ (_this playbook has been tested working on Windows Subsystem for Linux_).
1. Ansible 2.5.x on Ubuntu 16.04.
1. AWS Account and environment variables configured as appropriate.
1. AWS Keypair stored locally.

## How to run

Run the playbooks in order i.e.

`ansible-playbook -vvv --ask-vault-pass -i inventories/dev/ <PLAYBOOK>.yml -e ansible_ssh_private_key_file=/path/to/keypair.pem`

Replace `PLAYBOOK` with the playbooks to be run.

_Note: you can also run the playbooks all at once if required but I have not validated this._

| Task | Playbook |
|-|-|
| Create EC2 instances | `0vms.yml` |
| Setup prereqs, Create DB and MediaWiki instances. | `1apps.yml` |
| Create ECR | `createecr.yml`|

## Overall Flow

1. Create Docker Image for MediaWiki using Ansible-managed Dockerfile.
1. Push to AWS Elastic Container Registry.

## Key Points

**Variable Structure**:

1. Environment-independent data is stored in role defaults, and environment-dependent data goes into `inventories/<env>/`.
1. Secrets are environment-specific and stored in `inventories/<env>/group_vars/all/vault.yml`.


## Notes, Tips and Gotchas

Please see [notes.md](notes.md) for observations and notes from developing this code.

# References

1. [MySQL on Docker with pre-initialized Databases](https://docs.docker.com/samples/library/mysql/)
1. ECR with Ansible: [1](https://awsbloglink.wordpress.com/2017/06/03/manage-amazon-ec2-container-registry-with-ansible/), [2](https://forums.docker.com/t/docker-push-to-ecr-failing-with-no-basic-auth-credentials/17358/2), [3](https://docs.aws.amazon.com/cli/latest/reference/ecr/get-login.html)
1. [Enabling Debug Logging in MediaWiki](https://www.mediawiki.org/wiki/Topic:U26n1a1pgo0078tt)
1. [`register` runs even on skipped tasks](https://github.com/ansible/ansible/issues/4297)
1. Ansible Tips and Tricks: [1](https://stackoverflow.com/a/34929776)

Kubernetes
1. https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
1. https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment
1. Filtering `kubectl` output: https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba
