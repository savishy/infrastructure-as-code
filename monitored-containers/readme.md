# Monitored Container Infrastructure

This directory contains provisioners that automate provisioning of infrastructure on various platforms and create monitored containers.

### Prometheus / Grafana

This provisioner automates the following flow:

1. Create an Azure instance.
1. Install Docker.
1. Install and configure Prometheus and Grafana.
1. Connect Prometheus and Grafana to monitor containers.

### :exclamation: You need an instrumented application.

* This provisioner by default configures Prometheus to scrape a sample app, Petclinic.
    * Hostname `petclinic`
    * Listening on port `9080`.
    * The default endpoint it listens to is `/manage/prometheus`.
* You can use this Petclinic Docker Image: [`savishy/springboot-petclinic:2.0.0-prometheus`](https://hub.docker.com/r/savishy/springboot-petclinic/)
* Start it with the name `petclinic` and use the same network where the Prometheus and Grafana containers are running.

```
docker run -p 9080:9080 --net=monitoring --name=petclinic savishy/springboot-petclinic:2.0.0-prometheus
```

### How to run:

`ansible-playbook --ask-vault-pass prometheus-grafana-azure.yml` on Azure.

`ansible-playbook --ask-vault-pass prometheus-grafana-local.yml` on localhost.
