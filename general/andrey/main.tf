/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "cli" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0.1"

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_entrypoint    = "chmod +x ${path.module}/scripts/script.sh;${path.module}/scripts/script.sh"
  create_cmd_body          = "${var.gcp_project_id} ${var.gcp_region} ${var.gcp_zone}"
  skip_download            = false
  upgrade                  = false
  gcloud_sdk_version       = "358.0.0"
  service_account_key_file = var.service_account_key_file
}
