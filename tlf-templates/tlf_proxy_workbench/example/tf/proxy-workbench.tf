# ------------------ Proxy: Vertex Workbench 
# ------------------ Module Definition 

module "la_vertex_workbench" {
  ## REMOTE: GitHub (Public) access - working 
  ## source = "github.com/CloudVLab/terraform-lab-foundation//solutions/proxy_vertex_workbench/stable"
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/proxy_vertex_workbench/stable/v1?ref=tlf-proxy"
  ## source = "gcs::https://www.googleapis.com/storage/v1/terraform-lab-foundation/solutions/proxy_vertex_workbench/stable/v1"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id  = var.gcp_project_id 
  gcp_region      = var.gcp_region 
  gcp_zone        = var.gcp_zone 

  ## Custom Properties
  # workbench_name                = "cls-workbench"
  # workbench_service_name        = "workbench-proxy"
  # workbench_proxy_image         = "gcr.io/qwiklabs-resources/workbench-proxy:latest"
  # workbench_sa_name             = "vertex-ai"
  # workbench_sa_description      = "Vertex Workbench lab service account"
  # workbench_sa_iam_role         = "roles/editor"
  # workbench_post_startup_script = "https://storage.googleapis.com/spls/[LAB_ID]/lab-init.sh"
}

