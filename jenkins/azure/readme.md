# Jenkins Azure Provisioner

Creates a Linux VM on Azure, adds it to Ansible's inventory and provisions Jenkins on it. 

Tasks achieved:
1. Creation of NIC, Public IP, NSG and Azure Disk
1. Adding rules to NSG to allow connectivity only from the Ansible controller machine's IP.
1. Creation of a fully-parameterized Linux VM.
1. Addition of VM to Ansible dynamic inventory.
1. Provisioning Java and Jenkins on VM.


## Highlights

* I have kept the playbook simple - vaulted secrets are stored encrypted, but within clear text files (see [ansible-roles/azurevm/defaults/main.yml](https://github.com/savishy/ansible-roles/blob/master/azurevm/defaults/main.yml)

* Demonstrates my belief that playbooks should not embed roles, and that where possible roles should be externalized and generic. 
  The following roles are used:
  * savishy/ansible-roles
  * geerlingguy/ansible-role-java
  * geerlingguy/ansible-role-jenkins

* No static inventory, and no dynamic inventory scripts are necessary - specifically I utilize the great [`add_host`](https://docs.ansible.com/ansible/latest/modules/add_host_module.html) functionality of Ansible to add the host to Ansible's dynamic inventory.


## How to run 

You need:

* A Linux Box with functioning Ansible 2.5+. Note: _Ansible cloud provisioners work well with Windows Subsystem for Linux but I have not tested this specific playbook._ 
* An Azure Account with a service principal.
* The appropriate Azure Environment Variables for the Service Principal should be configured into your environment. 

First load the requirements, then run the playbook.
```
ansible-galaxy install -r requirements.yml
ansible-playbook --ask-vault-pass jenkins.yml
```

(Vault Password is available on request.)
