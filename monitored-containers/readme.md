# Monitored Container Infrastructure

This directory contains provisioners that automate provisioning of infrastructure on various platforms and create monitored containers.

### Prometheus / Grafana

This provisioner automates the following flow:

1. Create an Azure instance.
1. Install Docker.
1. Install and configure Prometheus and Grafana.
1. Connect Prometheus and Grafana to monitor containers.

## How to run:

`ansible-playbook --ask-vault-pass prometheus-grafana-linux.yml`
