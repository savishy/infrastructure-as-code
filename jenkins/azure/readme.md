# Jenkins Azure Provisioner

Creates a Linux VM on Azure, adds it to Ansible's inventory and provisions Jenkins on it. Additionally adds a Docker Registry to the same server to enable Docker-enabled Jenkins pipelines. 

Tasks achieved:
1. Creation of NIC, Public IP, NSG and Azure Disk
1. Adding rules to NSG to allow connectivity only from the Ansible controller machine's IP.
1. Creation of a fully-parameterized Linux VM.
1. Addition of VM to Ansible dynamic inventory.
1. Provisioning Java and Jenkins on VM.
1. Installing Docker.
1. Creating a self-signed certificate.
1. Creation of a Docker Registry with SSL and a Registry Frontend for UI-based viewing of docker images.

## Highlights

* I have kept the playbook simple - vaulted secrets are stored encrypted, but within clear text files (see [ansible-roles/azurevm/defaults/main.yml](https://github.com/savishy/ansible-roles/blob/master/azurevm/defaults/main.yml)

* Demonstrates my belief in reusability - i.e where possible Ansible roles should be externalized and generic. 
  The following roles are used:
  * [savishy/ansible-roles](https://github.com/savishy/ansible-roles) _my repository of existing Ansible Roles._
  * [geerlingguy/ansible-role-java](https://github.com/geerlingguy/ansible-role-java)
  * [geerlingguy/ansible-role-jenkins](https://github.com/geerlingguy/ansible-role-jenkins)
  * [geerlingguy/ansible-role-docker](https://github.com/geerlingguy/ansible-role-docker)

* No static inventory, and no dynamic inventory scripts are necessary - specifically I utilize the great [`add_host`](https://docs.ansible.com/ansible/latest/modules/add_host_module.html) functionality of Ansible to add the host to Ansible's dynamic inventory.

## How to run 

You need:

* A Linux Box with functioning Ansible 2.5+. Note: _Ansible cloud provisioners work well with Windows Subsystem for Linux but I have not tested this specific playbook with WSL._ 
* An Azure Account with a service principal.
* The appropriate Azure Environment Variables for the Service Principal should be configured into your environment. 

First load the requirements, then run the playbook.
```
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass jenkins.yml
```

(Vault Password is available on request.)

## Verify

* Load the Jenkins URL (`http://IP:8080`) in your browser and verify you can access it. For simplicity I use the default Jenkins port, admin user and password which can be retrieved from geerlingguy/ansible-role-jenkins.
* Load the Registry Frontend URL (`http://IP`)

## Note: getting the vaulted password

`ansible-playbook --ask-vault-pass jenkins.yml --tags=password`
