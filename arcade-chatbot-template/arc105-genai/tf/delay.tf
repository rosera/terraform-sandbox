## Add a Delay/WAIT before creating a resource

resource "time_sleep" "wait_api_delay" {
  create_duration = "300s"
  depends_on = [ module.la_api_batch.api_services ]
}

resource "time_sleep" "wait_build_delay" {
  create_duration = "60s"
  depends_on = [ module.cloudbuild_script ]
}
