output "task" {
  value = {
    project_id    = var.project_id
    region        = var.region
    zone          = var.zone
    ref           = var.ref
    title         = var.title
    image         = var.image
    resource_name = var.resource_name
    challenges    = var.challenges
    instructions  = var.instructions
  }
}
