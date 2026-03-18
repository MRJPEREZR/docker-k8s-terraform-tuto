resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_zone
  project  = var.project_id

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = var.node_pool_name
  location   = var.cluster_zone
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

resource "google_compute_disk" "default" {
  name                      = var.gke_disk_name
  type                      = var.gke_disk_type
  zone                      = var.gke_disk_zone
  image                     = var.gke_disk_image
  labels                    = var.gke_disk_labels
  physical_block_size_bytes = var.gke_disk_physical_block_size_bytes
}
