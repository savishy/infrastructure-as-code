# Known Issues & Future Improvements

1. I need to create Inspec spec .rb files for each role. I also need to create a test engine which would pick up all the role-level specs and run automated validation as part of infra provisioning.
1. Instances like the DB should be created with private IP instead of a public IP. The Ansible controller can serve as a Jumphost to access them.
1. The 2x MediaWiki instances, 1x DB and 1x Controller should be on the same VPC.
1. Currently (due to time constraints) the DB instance joins the Control Group subnet. This requires a rule to allow communication on port 3306 between the Control Group and Node Group subnets. I need to join the DB instance to the Kubernetes NodeGroup SG and allow intra-SG communication (if not already enabled). This would allow easy communication via private IPs and avoid the extra code for the Control Group SG modification.
1. At present the entire playbook.yml needs to be run - this is because the roles have some dependencies in terms of fact creation and discovery. We could make the roles modular so that you can run plays individually with tags, for example. One way to achieve this is to externalize the fact creation into `roles/common` and then call them where needed.
1. The controller provisioning should have been automated, something which is quite easy to achieve. Of course, one would need a provisioner like Ansible to provision the Ansible controller (my Windows laptop with WSL is one option). 
