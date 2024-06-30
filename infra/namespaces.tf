resource "kubernetes_namespace" "app" {
  metadata {
    name = var.weather_app_namespace
  }
}

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
  }
}

