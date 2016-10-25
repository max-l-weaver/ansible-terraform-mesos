variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-c"
}

variable "project_name" {
  default = "infect-testing"
}

variable "credentials_file_path" {
  default = "~/.gcloud/client_secret_107026187565116160758.json"
}

variable "public_key_path" {
  default = "~/.ssh/gcloud_id_rsa.pub"
}

variable "private_key_path" {
  default = "~.ssh/gcloud_id_rsa"
}

