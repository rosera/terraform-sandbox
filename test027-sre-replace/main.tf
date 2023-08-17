module "asm_test" {
  # source = "./module"
  # source = "github.com/CloudVLab/terraform-lab-foundation//solutions/asm_cluster/dev"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/asm_cluster/dev?ref=asm_basics_vp"

  gcp_project_id           = var.gcp_project_id
  gcp_region               = var.gcp_region
  gcp_zone                 = var.gcp_zone
  gcp_username             = var.gcp_username

  # Custom properties - defined in qwiklabs.yaml 
  service_account_key_file = var.service_account_key_file
  gke_cluster_name         = var.gke_cluster_name
}
