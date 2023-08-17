
# ------------------ GoogleApis: AutoML 
#

# Module: GoogleAPIs 
module "la_api_automl" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Enable API 
  api_service_name = "automl.googleapis.com"
}

# ------------------ GoogleApis: AIPlatform/VertexAI 
#

module "la_api_vertex" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Enable API 
  api_service_name = "aiplatform.googleapis.com"
}

# ------------------ Proxy: Vertex Notebook 
#

module "la_vertex_workbench" {
  ## NOTE: When changing the `source` parameter
  ## `terraform init` is required

  ## Local Modules - working
  ## Module subdirectory needs to be defined within the TF directory
  #source = "./solutions/vertex_proxy_workbench/dev"

  ## REMOTE: GitHub (Public) access - working 
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/proxy_vertex_workbench/stable"

  ## Exchange values between Qwiklabs and Module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone


  ## Enable Proxy on the defined region
  gcrRegion     = var.gcp_region
}


# ------------------ Proxy: AutoML Service 
#

# Module: AutoML  
module "la_automl_proxy" {
  source = "github.com/CloudVLab/terraform-lab-foundation//solutions/proxy_automl/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  ## --------------------------------------------------------------
  ## AutoML Proxy - Cloud Run Service  
  ## Default: Use Environment Variables
  ## --------------------------------------------------------------

  ## Add Environment Variables
  ## Consult Docs to add required settings
  cr_env = [
    { gcr_env_name = "PROJECT_ID", gcr_env_value = var.gcp_project_id },
    { gcr_env_name = "REGION_ID", gcr_env_value = var.gcp_region },
    { gcr_env_name = "ENDPOINT_ID", gcr_env_value = "8236160128693305344" },
    { gcr_env_name = "GATEWAY_URL", gcr_env_value = "https://automl-gateway-kjyo252taq-uc.a.run.app/v1" },
    { gcr_env_name = "GATEWAY_PROJECT", gcr_env_value = "qwiklabs-resources" }
  ]

  cr_service_name = "automl-service"
  # cr_image        = "gcr.io/qwiklabs-resources/automl-proxy:latest"
  cr_image        = "gcr.io/qwiklabs-resources/automl-proxy-test:latest"
}
