data "terraform_remote_state" "gke" {
  backend = "local"
  config = {
    path = "../terraform-gke/terraform.tfstate"
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.gke.outputs.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.gke.outputs.cluster_ca_certificate)
}