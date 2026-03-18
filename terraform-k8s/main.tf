module "k8s" {
  source = "./modules/k8s"

  cluster_endpoint       = data.terraform_remote_state.gke.outputs.cluster_endpoint
  cluster_ca_certificate = data.terraform_remote_state.gke.outputs.cluster_ca_certificate
}