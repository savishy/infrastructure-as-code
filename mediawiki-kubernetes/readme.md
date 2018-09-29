# MediaWiki on Kubernetes on AWS

This directory contains an end-to-end provisioner for a Load-balanced MediaWiki instance on Kubernetes on AWS.

The end product looks like this: 

![capture](https://user-images.githubusercontent.com/13379978/45091084-f6154080-b12e-11e8-92b5-7f3b3854302c.PNG)

The Kanban Board for this project can be found here: https://github.com/savishy/infrastructure-as-code/projects/1

## Features

* :heavy_check_mark: Infrastructure is disposable and fully-automated.
* :heavy_check_mark: MediaWiki instances come up pre-installed and pre-configured with access to DB. One admin user is also pre-created.
* :heavy_check_mark: MediaWiki instances are load-balanced through a Kubernetes service.
* :heavy_check_mark: MediaWiki connects to Database using a Kubernetes Service. In other words, connection to the DB is independent of DB IP address or hostname.

## Architecture

Two instances of MediaWiki in a Kubernetes cluster with a common instance of MySQL Database.


<img src="https://user-images.githubusercontent.com/13379978/45090003-a3865500-b12b-11e8-89d2-67b40db57e9a.png" alt="architecture" width="500"/>


## Technology Stack

| Item | Technology | Notes |
|-|-|-|
| Database | MySQL in a Docker Container on an EC2 `t2.medium` instance | Uses a customized MySQL Docker Image with the MediaWiki Database Schema pre-loaded. |
| MediaWiki | MediaWiki in a Docker Container as a Kubernetes service. | Uses a customized MediaWiki image with MediaWiki "installed" i.e ready for use. |
| Automation Tool | Ansible 2.5.x, Docker and `kubectl` on an EC2 `t2.small` instance. | Overall Controller |
| Container Registry | ECS Repositories | |


## How to run

### Prerequisites

1. Ansible 2.5.x on Ubuntu 16.04.
1. AWS Account and environment variables configured as appropriate.
1. AWS Keypair PEM file stored locally.
1. Ansible Vault Password (provided on request)

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

### Create ECS Registries (one-time action)

```
`ansible-playbook -vvv --ask-vault-pass -i inventories/dev/ createecr.yml -e ansible_ssh_private_key_file=/path/to/keypair.pem`
```

### Run the playbook

`ansible-playbook -vvv --ask-vault-pass -i inventories/dev/ playbook.yml -e ansible_ssh_private_key_file=/path/to/keypair.pem`

This asks you for the vault password, type that in. 

## Implementation Details

A High Level Overview Diagram: 

<img src="https://user-images.githubusercontent.com/13379978/45088507-cfeba280-b126-11e8-8ac0-09be1965d83e.png" alt="implementation flow" width="500"/>

### Kubernetes provisioning on AWS

Ansible role: [`kube-eks`](roles/kube-eks). The role creates a VPC and Subnets, creates an EKS Cluster and 2 nodes.

1. I referred to the steps provided in the [official getting-started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) and automated them using a mix of
   1. Ansible
   1. Ansible's CloudFormation modules and CloudFormation Templates provided from the above link
   1. `kubectl`

Note: I initially referenced Jeff Geerling's role `geerlingguy.kubernetes` for the Kubernetes provisioning. However, I had trouble resolving DNS from within the pods. As a result I switched to provisioning a cluster on EKS.

**Access to external DB from Kubernetes Cluster**

I created a Kubernetes Service and endpoint that points to the DB.

:bulb: This allows Kubernetes pods to use the service name to access the DB (instead of its IP) i.e MediaWiki does not need to use the DB IP to access the database :+1:

### MediaWiki and MySQL DB Images

Ansible role: [`images`](roles/images). This role creates images for MediaWiki and MySQL DB and pushes them to the ECS Registry.

1. With constraints of time, I chose to use the official MediaWiki and MySQL Docker Image as my base image.
1. The official image still requires one to perform "installation" or "initial setup". 

To achieve the objective of a ready-to-go MediaWiki:

1. I first "manually" ran a MediaWiki container connected to a MySQL container on the same Docker network.
1. After performing initial setup I extracted the `LocalSettings.php` from MediaWiki and a `mysqldump` of the MySQL MediaWiki DB. These are stored as templates in Ansible.
1. I then wrote the playbook to manage creation of 
   1. A MediaWiki image which has the `LocalSettings.php` preloaded with connection to the DB;
   1. A MySQL image with the DB schema baked in.

:bulb: The MediaWiki `LocalSettings.php` references the DB using the DNS Name of the Kubernetes DB Service. This helps us keep the image immutable.

### Variables and Secrets

1. Environment-independent data is stored in role defaults, and environment-dependent data goes into `inventories/<env>/`.
1. Secrets are environment-specific and stored in `vault.yml` files.

## Known Issues & Improvements

Please take a look at [future.md](future.md).

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
