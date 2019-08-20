provider "kubernetes" {
  version = "~> 1.8"
  host = "https://192.168.50.10:6443"

}


resource "kubernetes_pod" "jenkinsci-pod" {
  metadata {
    name = "jenkinsci-pod-example"
    labels = {
      App = "jenkinsci-pod-example"
    }
  }

  spec {
    container {
      image = "jenkins/jenkins:lts"
      name  = "jenkinsci-container"

      port {
        container_port = 8080
      }
    }
  }
}



resource "kubernetes_service" "jenkinsci-srv" {
  metadata {
    name = "jenkinsci-srv-example"
  }
  spec {
    selector = {
      App = kubernetes_pod.jenkinsci.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    	type = "ClusterIP"
	#type = "LoadBalancer"
  }
}
