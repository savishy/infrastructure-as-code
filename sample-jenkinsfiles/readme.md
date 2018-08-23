## Sample Jenkinsfiles

**Purpose**: Jenkinsfiles in this directory serve as examples/demo files to be used with the infrastructure-as-code setup in this repository.

## How to use

**Prepare**

1. Setup Jenkins using one of the provisioners in this repository.
1. Make sure Pipeline, Git and Docker plugins are installed in Jenkins.
1. Make sure Docker is listening as a daemon. 

**Create Jenkins Pipeline Job**

1. Jenkins > New Job > Pipeline
1. Choose "Pipeline Script from SCM" and provide this repository i.e `https://github.com/savishy/infrastructure-as-code`.
1. Provide the path to the Jenkinsfile relative to the root directory, e.g. `sample-jenkinsfiles/Jenkinsfile.groovy`. 
1. Disable "Lightweight Checkout".
