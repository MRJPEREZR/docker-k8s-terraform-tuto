module "gke" {
  source = "./modules/gke"

  cluster_name   = var.cluster_name
  cluster_zone   = var.cluster_zone
  project_id     = var.project_id
  node_pool_name = var.node_pool_name
  node_count     = var.node_count
  machine_type   = var.machine_type

  gke_disk_name                      = var.gke_disk_name
  gke_disk_type                      = var.gke_disk_type
  gke_disk_zone                      = var.gke_disk_zone
  gke_disk_labels                    = var.gke_disk_labels
  gke_disk_physical_block_size_bytes = var.gke_disk_physical_block_size_bytes
}