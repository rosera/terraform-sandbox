# Create BASE64 based on JSON

locals {
  arcade_info = {
    project_id = var.gcp_project_id
    region     = var.gcp_region
  }

  # Create JSON
  arcade_json   = jsonencode(local.arcade_info)
  arcade_base64 = base64encode(local.arcade_json)
}
