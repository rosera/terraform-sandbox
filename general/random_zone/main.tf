## Create a randomised Zonal list

# 1. Get the zones for the Region
data "google_compute_zones" "available_zones" {
  region = var.gcp_region
}

# 2. Define an index based on available_zones
resource random_integer "random_index" {
  min = 0
  max = length(data.google_compute_zones.available_zones.names) -1
}

# 3. Create a filtered zone list - minus the current QL allocated zone
locals {
  # Option 1. For Loop
  filtered_zones =  [
  for zone in data.google_compute_zones.available_zones.names :
    zone if zone != var.gcp_zone
  ]

  # Option 2. setsubtract
  filtered_zones2 = setsubtract(data.google_compute_zones.available_zones.names, [var.gcp_zone])

  random_zone  = local.filtered_zones[random_integer.random_index.result]
}

# 4. Create an output variable for the random zone
output "zone_random" {
  value = local.random_zone
}

# 5. Create an output variable for filtered_zones list
output "zone_list" {
  value = local.filtered_zones
}

# 6. Create an output variable for filtered_zones list
output "zone_list2" {
  value = local.filtered_zones2
}
