# GSP608

Migrate to local terraform to Terraform-Lab-Foundations

Three resources defined for internal, external and partner environments.

- [x] VPC
- [x] FW
- [x] GCE

## Internal: internal.tf

### VPC

- [x] vpc
- [x] subnet

| VPC | Region | Type | subnet |
|-----|--------|------|--------|
| internal-network | var.gcp_region   | custom | internal-subnet-${var.gcp_region}   |

| Subnet | Region | Type | CIDR |
|--------|--------|------|------|
| internal-network-${var.gcp_region}   | var.gcp_region   | custom | 10.0.0.0/16 |

### FW

| VPC | Rule | Source Range | Protocol | Port |
|-----|------|--------------|----------|------|
| internal-network | internal-allow-ssh  | 0.0.0.0/0 | tcp |   22 |

### GCE

| Name | Type | Zone | Image | Subnet |
|------|------|------|-------|--------|
| internal-server-1 | e2-micro | var.gcp_zone   | debian-cloud/debian-11 | internal-network-${var.gcp_region}   |
| internal-server-2 | e2-micro | var.gcp_zone   | debian-cloud/debian-11 | internal-network-${var.gcp_region}   |


## External: external.tf

### VPC

| VPC | Region | Type | subnet |
|-----|--------|------|--------|
| external-network | var.gcp_region_1 | custom | external_subnet-${var.gcp_region_1} |

| Subnet | Region | Type | CIDR |
|--------|--------|------|------|
| external-network-${var.gcp_region_1} | var.gcp_region_1 | custom | 10.1.0.0/16 |

### FW

| VPC | Rule | Source Range | Protocol | Port |
|-----|------|--------------|----------|------|
| external-network | external-allow-http | 0.0.0.0/0 | tcp |   80 |

### GCE

| Name | Type | Zone | Image | Subnet |
|------|------|------|-------|--------|
| external-server-1 | e2-micro | var.gcp_zone_1 | debian-cloud/debian-11 | external-network-${var.gcp_region_1} |




## Partner: partner.tf

### VPC 

| VPC | Region | Type | subnet |
|-----|--------|------|--------|
| partner-network  | var.gcp_region_2 | custom | partner-network-${var.gcp_region_2} |

| Subnet | Region | Type | CIDR |
|--------|--------|------|------|
| partner-network-${var.gcp_region_2}  | var.gcp_region_2 | custom | 10.2.0.0/16 |


### FW

| VPC | Rule | Source Range | Protocol | Port |
|-----|------|--------------|----------|------|
| partner-network  | partner-allow-rdp   | 0.0.0.0/0 | tcp | 3389 |


###  GCE 

| Name | Type | Zone | Image | Subnet |
|------|------|------|-------|--------|
| partner-server-1  | e2-micro | var.gcp_zone_2 | debian-cloud/debian-11 | partner-network-${var.gcp_region_2}  |
