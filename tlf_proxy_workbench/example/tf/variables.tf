#
# ------------------  Qwiklabs Values
#
variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}


#
# ------------------  Custom Properties
#

## variable "workbench_vm_name" {
##   type        = string
##   description = "Workbench virtual machine name"
##   default     = "cls-vertex-workbench"
## }
## 
## variable "workbench_service_name" {
##   type        = string
##   description = "Workbench virtual machine name"
##   default     = "workbench-proxy"
## }
## 
## variable "workbench_proxy_image" {
##   type        = string
##   description = "Workbench container image"
##   default     = "gcr.io/qwiklabs-resources/workbench-proxy:latest"
## }
## 
## variable "workbench_sa_name" {
##   type        = string
##   description = "Workbench service account"
##   default     = "vertex-ai"
## }
## 
## variable "workbench_sa_description" {
##   type        = string
##   description = "Workbench lab service account"
##   default     = "Vertex Workbench lab service account"
## }
## 
## variable "workbench_sa_iam_role" {
##   type        = string
##   description = "Workbench IAM role permission"
##   default     = "roles/editor"
## }
## 
## variable "workbench_post_startup_script" {
##   type        = string
##   description = "URL for the startup-script"
##   default     = "https://storage.googleapis.com/spls/[LAB_ID]/lab-init.sh"
## }
