module "gke" {
  source = "./modules/gke"

  cluster_name   = var.cluster_name
  zone           = var.zone
  project_id     = var.project_id
  node_pool_name = var.node_pool_name
  node_count     = var.node_count
  machine_type   = var.machine_type
}

module "k8s" {
  source = "./modules/k8s"

  depends_on = [module.gke]

  cluster_endpoint       = module.gke.cluster_endpoint
  cluster_ca_certificate = module.gke.cluster_ca_certificate
}