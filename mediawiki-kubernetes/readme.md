# MediaWiki on Kubernetes on AWS

This directory contains an end-to-end provisioner for a Load-balanced MediaWiki instance on Kubernetes on AWS.

## Architecture

Two instances of MediaWiki in a Kubernetes cluster with a common instance of MySQL Database.

![image](https://user-images.githubusercontent.com/13379978/45090003-a3865500-b12b-11e8-89d2-67b40db57e9a.png)


## Technology Stack

| Item | Technology | Notes |
|-|-|-|
| Database | MySQL in a Docker Container on an EC2 `t2.medium` instance | Uses a customized MySQL Docker Image with the MediaWiki Database Schema pre-loaded. |
| MediaWiki | MediaWiki in a Docker Container as a Kubernetes service. | Uses a customized MediaWiki image with MediaWiki "installed" i.e ready for use. |
| Automation Tool | Ansible 2.5.x, Docker and `kubectl` on an EC2 `t2.small` instance. | Overall Controller |
| Container Registry | ECS Repositories | |

## Prerequisites

1. Ansible 2.5.x on Ubuntu 16.04.
1. AWS Account and environment variables configured as appropriate.
1. AWS Keypair stored locally.
1. Ansible Vault Password (provided on request)

## How to run

### Download Prerequisites (one-time action)

```
ansible-galaxy install -r requirements.yml
```

### Load Environment Variables (one-time action per terminal session)

```
export AWS_ACCESS_KEY=<something>
export AWS_SECRET_KEY=<something>
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_KEY
```

### Run the playbook

`ansible-playbook -vvv --ask-vault-pass -i inventories/dev/ playbook.yml -e ansible_ssh_private_key_file=/path/to/keypair.pem`

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
1. https://kubernetes.io/docs/tutorials/stateless-application/expose-external-ip-address/, https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport
1. https://github.com/weaveworks/weave/issues/2888
1. External DB Access: https://kubernetes.io/docs/concepts/services-networking/service/#services-without-selectors
   https://groups.google.com/forum/#!msg/kubernetes-dev/TD4v5710jkQ/EWoMXVJCHAAJ
