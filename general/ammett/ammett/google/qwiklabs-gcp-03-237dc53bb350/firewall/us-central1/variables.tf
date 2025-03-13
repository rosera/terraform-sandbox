data "terraform_remote_state" "networks" {
  backend = "local"

  config = {
    path = "../../../../../generated/google/qwiklabs-gcp-03-237dc53bb350/networks/us-central1/terraform.tfstate"
  }
}
