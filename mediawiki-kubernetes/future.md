# Known Issues & Future Improvements


1. Instances like the DB should be created with private IP instead of a public IP. The Ansible controller can serve as a Jumphost to access them.
1. The 2x MediaWiki instances, 1x DB and 1x Controller should be on the same VPC.
1. Currently (due to time constraints) the DB connection is made via the public IP. I need to join the DB instance to the Kubernetes NodeGroup SG and allow intra-SG communication. This would allow communication via private IPs.
1. At present the entire playbook.yml needs to be run - this is because the roles have some dependencies in terms of fact creation and discovery. We could make the roles modular so that you can run plays individually with tags, for example. One way to achieve this is to externalize the fact creation into `roles/common` and then call them where needed.
1. The controller provisioning should have been automated, something which is quite easy to achieve. Of course, one would need a provisioner like Ansible to provision the Ansible controller (my Windows laptop with WSL is one option). 
