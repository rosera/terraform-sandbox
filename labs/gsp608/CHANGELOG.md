# GSP608

Migrate to local terraform to Terraform-Lab-Foundations

- [x] VPC
- [x] FW
- [x] GCE

## VPC

3 x custom VPC
3 x region

Create the following VPC

| VPC | Region | Type | subnet |
|-----|--------|------|--------|
| internal-network | var.gcp_region   | custom | internal-subnet-${var.gcp_region}   |
| external-network | var.gcp_region_1 | custom | external_subnet-${var.gcp_region_1} |
| partner-network  | var.gcp_region_2 | custom | partner-network-${var.gcp_region_2} |

Create the following Subnet

| Subnet | Region | Type | CIDR |
|--------|--------|------|------|
| internal-network-${var.gcp_region}   | var.gcp_region   | custom | 10.0.0.0/16 |
| external-network-${var.gcp_region_1} | var.gcp_region_1 | custom | 10.1.0.0/16 |
| partner-network-${var.gcp_region_2}  | var.gcp_region_2 | custom | 10.2.0.0/16 |

## FW

3 x FW

Fixes
- [ ] Rule names i.e. SSH/RDP
- [ ] Protocols to match rule names
- [ ] Add Tags

| VPC | Rule | Source Range | Protocol | Port |
|-----|------|--------------|----------|------|
| internal-network | internal-allow-ssh  | 0.0.0.0/0 | tcp |   22 |
| external-network | external-allow-http | 0.0.0.0/0 | tcp |   80 |
| partner-network  | partner-allow-rdp   | 0.0.0.0/0 | tcp | 3389 |


## GCE

4 x GCE instances

Fixes
- [ ] Make the Zones associate with the selected regions
- [ ] Amend GCE naming scheme 

| Name | Type | Zone | Image | Subnet |
|------|------|------|-------|--------|
| internal-server-1 | e2-micro | var.gcp_zone   | debian-cloud/debian-11 | internal-network-${var.gcp_region}   |
| internal-server-2 | e2-micro | var.gcp_zone   | debian-cloud/debian-11 | internal-network-${var.gcp_region}   |
| external-server-1 | e2-micro | var.gcp_zone_1 | debian-cloud/debian-11 | external-network-${var.gcp_region_1} |
| partner-server-1  | e2-micro | var.gcp_zone_2 | debian-cloud/debian-11 | partner-network-${var.gcp_region_2}  |
