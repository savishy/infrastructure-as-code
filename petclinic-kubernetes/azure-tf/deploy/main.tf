# Perform deployment on Kubernetes.
# https://medium.com/@Joachim8675309/deploy-kubernetes-apps-with-terraform-5b74e5891958

provider "kubernetes" {
  host     = "${var.host}"
  username = "${var.username}"
  password = "${var.password}"

  client_certificate     = "${base64decode(var.client_certificate)}"
  client_key             = "${base64decode(var.client_key)}"
  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
}

resource "kubernetes_replication_controller" "petclinicrc" {
  metadata {
    name = "petclinicrc"
    labels {
      app = "petclinic"
      tier = "app"
    }
  }

  spec {
    replicas = 2
    selector = {
      app = "petclinic"
      tier = "app"
    }
    template {
      container {
	image = "${var.app_image}:${var.app_version}"
	name = "petclinic"
	port {
	  container_port = "8080"
	}
	resources {
	  requests {
	    cpu = "200m"
	    memory = "100Mi"
	  }
	}
      }
    }
  }
}
resource "kubernetes_service" "petclinicservice" {
  metadata {
    name = "petclinicservice"
    labels {
      app  = "petclinic"
      tier = "app"
    }
  }

  spec {
    selector {
      app  = "petclinic"
      tier = "app"
    }

    type = "LoadBalancer"

    port {
      port = 8080
    }
  }
}


