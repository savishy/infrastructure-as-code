## Sample Jenkinsfiles

**Purpose**: Jenkinsfiles in this directory serve as examples/demo files to be used with the infrastructure-as-code setup in this repository.

:exclamation: The Jenkinsfile _assumes a Docker registry resides at https://127.0.0.1_. It is meant to be used along with the Jenkins provisioner in _this_ repository. Any different setup will require modifications to the Jenkinsfile. 


## Prerequisites

Using Jenkinsfiles and Docker requires the Docker service to be listening as a daemon, because Docker actions within a Jenkinsfile connect to the TCP Port where Docker is listening (e.g. 2375):

```
$ sudo netstat -tulpn | grep docker
tcp6       0      0 :::2375                 :::*                    LISTEN      32687/dockerd
```

On Ubuntu 16.04 for example, this is easily achieved using a Systemd drop-in:

```
# Create the following file:
/etc/systemd/system/docker.service.d/docker.conf

# Populate it with:

[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock

```

To execute some actions with Docker the user account that Jenkins runs under, needs to be added to the `docker` group, e.g 
`sudo usermod -aG docker jenkins`.



Also ensure that the Jenkins installation has the following plugins at least:

1. Pipeline
1. Git
1. Docker

## How to use: Create Jenkins Pipeline Job

1. Jenkins > New Job > Pipeline
1. Choose "Pipeline Script from SCM" and provide this repository i.e `https://github.com/savishy/infrastructure-as-code`.
1. Provide the path to the Jenkinsfile relative to the root directory, e.g. `sample-jenkinsfiles/Jenkinsfile.groovy`. 
1. Disable "Lightweight Checkout".

## Run Pipeline Job

That's all the configuration needed. If you run the Pipeline you should see the full pipeline flow, including app build, Dockerfile build, tagging and pushing it to the registry. 


![image](https://user-images.githubusercontent.com/13379978/44507182-2c7ea480-a6c7-11e8-83e8-51fb01523429.png)
