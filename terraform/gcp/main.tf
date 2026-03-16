# --- Cluster creation
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.node_pool_name
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  project    = var.project_id
  node_count = var.node_count

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

resource "kubernetes_manifest" "storages" {
  depends_on = [google_container_cluster.primary]
  for_each   = { for f in fileset("${path.root}/../../k8s/storages", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.root}/../../k8s/storages/${each.value}"))
}

resource "kubernetes_manifest" "deployments" {
  depends_on = [kubernetes_manifest.storages]
  for_each   = { for f in fileset("${path.root}/../../k8s/deployments", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.root}/../../k8s/deployments/${each.value}"))
}

resource "kubernetes_manifest" "services" {
  depends_on = [google_container_cluster.primary]
  for_each   = { for f in fileset("${path.root}/../../k8s/services", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.root}/../../k8s/services/${each.value}"))
}

resource "kubernetes_manifest" "ingress" {
  depends_on = [kubernetes_manifest.services]
  for_each   = { for f in fileset("${path.root}/../../k8s/ingress", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.root}/../../k8s/ingress/${each.value}"))
}

resource "kubernetes_manifest" "jobs" {
  depends_on = [kubernetes_manifest.deployments, kubernetes_manifest.services]
  for_each   = { for f in fileset("${path.root}/../../k8s/jobs", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.root}/../../k8s/jobs/${each.value}"))
}
