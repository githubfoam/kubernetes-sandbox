provider "kubernetes" {
  version = "~> 1.8"
  host = "https://192.168.50.10:6443"

}

resource "kubernetes_pod" "echo" {
  metadata {
    name = "echo-example"
    labels = {
      App = "echo-app"
    }
  }
  spec {
    container {
      image = "hashicorp/http-echo:0.2.1"
      name  = "example2"
      args = ["-listen=:80", "-text='Hello World'"]
      port {
        container_port = 80
}
}
}
}


resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-example"
  }
  spec {
    selector = {
      #App = "${kubernetes_pod.echo.metadata.0.labels.App}"
      App = "MyApp"
      cluster_ip = "10.0.0.2"
     }
    port {
      port        = 80
      target_port = 80
    }
    #type = "LoadBalancer"
    type = "ClusterIP"
}
}
#
#output "lb_ip" {
#  value = "${kubernetes_service.echo.load_balancer_ingress.0.ip}"
#}
