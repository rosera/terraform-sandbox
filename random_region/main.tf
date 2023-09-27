## Create a randomised region list

# 1. Define an index based on available_zones
# resource random_integer "random_index" {
#   min = 0
#   max = length(locals.list_length) -1
# }

# 2. Create a filtered zone list - minus the current QL allocated zone
locals {
  # Option 1. For Loop - Create a List 
  filtered_regions =  [
  for region in var.allowed_regions:
    region if region != var.gcp_region
  ]

  # Option 2. setsubtract - Create a List
  filtered_regions2 = setsubtract(var.allowed_regions, [var.gcp_region])

  
#  list_length = length(filtered_regions)
#  list_length2 = length(filtered_regions2)

  # random_region  = local.filtered_regions[random_integer.random_index.result]
#  random_region  = local.filtered_regions[random_integer.random_index.result]
}

# 3. Create an output variable for the random zone
# output "region_random" {
#   value = local.random_region
# }

# 4. Create an output variable for filtered_zones list
output "region_list" {
  value = local.filtered_region
}

# 5. Create an output variable for filtered_zones list
output "region_list2" {
  value = local.filtered_region2
}
