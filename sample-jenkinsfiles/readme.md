## Sample Jenkinsfiles

**Purpose**: Jenkinsfiles in this directory serve as examples/demo files to be used with the infrastructure-as-code setup in this repository.

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

Also ensure that the Jenkins installation has the following plugins at least:

1. Pipeline
1. Git
1. Docker

## How to use

**Create Jenkins Pipeline Job**

1. Jenkins > New Job > Pipeline
1. Choose "Pipeline Script from SCM" and provide this repository i.e `https://github.com/savishy/infrastructure-as-code`.
1. Provide the path to the Jenkinsfile relative to the root directory, e.g. `sample-jenkinsfiles/Jenkinsfile.groovy`. 
1. Disable "Lightweight Checkout".
