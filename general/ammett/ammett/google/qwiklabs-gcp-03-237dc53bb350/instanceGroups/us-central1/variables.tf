data "terraform_remote_state" "instanceTemplates" {
  backend = "local"

  config = {
    path = "../../../../../generated/google/qwiklabs-gcp-03-237dc53bb350/instanceTemplates/us-central1/terraform.tfstate"
  }
}
