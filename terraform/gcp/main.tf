# --- Cluster creation
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone
  project  = var.project_id 

  remove_default_node_pool = true
  initial_node_count       = 1
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

    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# data "google_client_config" "default" {}

# resource "kubernetes_manifest" "storages" {
#   depends_on = [google_container_cluster.primary]
#   manifest = yamldecode(file("${path.root}/../../k8s/storages.yaml"))
# }

# resource "kubernetes_manifest" "deployments" {
#   depends_on = [kubernetes_manifest.storages]
#   for_each = { for d in yamldecode_all(file("${path.root}/../../k8s/deployments.yaml")) : d.metadata.name => d }

#   manifest = each.value
# }

# resource "kubernetes_manifest" "services" {
#   depends_on = [google_container_cluster.primary]
#   for_each = { for d in yamldecode_all(file("${path.root}/../../k8s/services.yaml")) : d.metadata.name => d }

#   manifest = each.value
# }

# resource "kubernetes_manifest" "ingress" {
#   depends_on = [kubernetes_manifest.services]
#   manifest = yamldecode(file("${path.root}/../../k8s/ingress.yaml"))
# }

# resource "kubernetes_manifest" "jobs" {
#   depends_on = [kubernetes_manifest.deployments, kubernetes_manifest.services]
#   manifest = yamldecode(file("${path.root}/../../k8s/jobs.yaml"))
# }


