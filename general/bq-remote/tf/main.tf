# API Service:   Enable Googleapis 
# Local:  modules/[channel]
# Remote: github.com://CloudVLab/terraform-lab-foundation//[module]/[channel]

# Module: Cloud Run 
module "la_api_run" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_service_name = "run.googleapis.com"  
}

# Module: BiqQuery 
module "la_api_bq_connection" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_service_name = "bigqueryconnection.googleapis.com"  
}

# Module: Cloud Functions 
module "la_api_cf" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_service_name = "cloudfunctions.googleapis.com"  
}

# Module: Cloud Build 
module "la_api_cb" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_service_name = "cloudbuild.googleapis.com"  
}

# Module: Cloud Build 
module "la_api_ar" {
  source = "github.com/CloudVLab/terraform-lab-foundation//basics/api_service/stable"

  # Pass values to the module
  gcp_project_id = var.gcp_project_id
  gcp_region     = var.gcp_region
  gcp_zone       = var.gcp_zone

  # Customise the GCE instance
  api_service_name = "artifactregistry.googleapis.com"  
}

#-----------------------------------------------------------------------------

