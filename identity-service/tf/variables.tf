variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to create resources in."
}

variable "gcp_region" {
  type        = string
  description = "Region to create resources in."
}

variable "gcp_zone" {
  type        = string
  description = "Zone to create resources in."
}

variable "workbench_name" {
  type        = string
  description = "Notebook name"
  default     = "vertex-ai-jupyterlab"
}

variable "notebook_name" {
  type        = string
  description = "Notebook name"
  default     = "intro_Vertex_AI_embeddings"
}

variable "notebook_version" {
  type        = string
  description = "Semantic version of the notebook (e.g., '1.0.0')"
  default     = "v1.0.0"
}

variable "requirements_file_path" {
  type        = string
  description = "Path to the requirements file"
  default     = "scripts/requirements.txt"
}
