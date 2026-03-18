output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.gke.cluster_ca_certificate
}

output "cluster_name" {
  value = module.gke.cluster_name
}