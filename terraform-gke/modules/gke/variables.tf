variable "project_id" {
  default = "cloud-login-489913"
}

variable "region" {
  default = "europe-west3"
}

variable "cluster_zone" {
  default = "europe-west3-c"
}

variable "cluster_name" {
  default = "my-cluster"
}

variable "node_pool_name" {
  default = "my-node-pool"
}

variable "machine_type" {
  default = "n2-standard-2"
}

variable "node_count" {
  default = 2
}

variable "gke_disk_name" {
  default = "gce-disk"
}

variable "gke_disk_type" {
  default = "pd-ssd"
}

variable "gke_disk_zone" {
  default = "europe-west3-c"
}

variable "gke_disk_image" {
  default = "debian-11-bullseye-v20220719"
}

variable "gke_disk_labels" {
  type = map(string)
  default = {
    environment = "dev"
  }
}

variable "gke_disk_physical_block_size_bytes" {
  default = 4096
}