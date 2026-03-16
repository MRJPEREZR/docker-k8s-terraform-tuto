provider "google" {
  project     = "cloud-login-489913"
  region      = "europe-west3"
  zone        = "europe-west3-a"
}

provider "kubernetes" {
  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

provider "docker" {
}