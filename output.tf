output "vpc" {
  value = aws_vpc.vpc.id
}

output "region" {
  value = var.region
}

output "app_subnet" {
  value = { for zone, dummy in var.zones :
    zone => {
      cidr                        = aws_subnet.app[zone].cidr_block
      subnet_id                   = aws_subnet.app[zone].id
      subnet_name                 = aws_subnet.app[zone].tags.Name
      route_table_id_via_igw      = aws_route_table.app_via_igw[zone].id
      route_table_name_via_igw    = aws_route_table.app_via_igw[zone].tags.Name
      route_table_id_via_valtix   = aws_route_table.app_via_valtix[zone].id
      route_table_name_via_valtix = aws_route_table.app_via_valtix[zone].tags.Name
    }
  }
}

output "app_security_group" {
  value = {
    id   = one(aws_security_group.app[*].id)
    name = one(aws_security_group.app[*].name)
  }
}

output "app_instances" {
  value = { for zone, dummy in var.zones :
    zone => {
      id         = aws_instance.vm[zone].id
      name       = aws_instance.vm[zone].tags.Name
      private_ip = aws_instance.vm[zone].private_ip
      public_ip  = aws_instance.vm[zone].public_ip
    }
  }
}

output "datapath_subnet" {
  value = { for zone, dummy in var.zones :
    zone => {
      cidr             = aws_subnet.datapath[zone].cidr_block
      subnet_id        = aws_subnet.datapath[zone].id
      subnet_name      = aws_subnet.datapath[zone].tags.Name
      route_table_id   = aws_route_table.datapath[zone].id
      route_table_name = aws_route_table.datapath[zone].tags.Name
    }
  }
}

output "datapath_security_group" {
  value = {
    id   = aws_security_group.datapath.id
    name = aws_security_group.datapath.name
  }
}

output "mgmt_subnet" {
  value = { for zone, dummy in var.zones :
    zone => {
      cidr             = aws_subnet.mgmt[zone].cidr_block
      subnet_id        = aws_subnet.mgmt[zone].id
      subnet_name      = aws_subnet.mgmt[zone].tags.Name
      route_table_id   = aws_route_table.mgmt[zone].id
      route_table_name = aws_route_table.mgmt[zone].tags.Name
    }
  }
}

output "mgmt_security_group" {
  value = {
    id   = aws_security_group.mgmt.id
    name = aws_security_group.mgmt.name
  }
}

output "valtix_gw_instance_details" {
  description = "instance_details in valtix_gateway resource"
  value = { for zone, dummy in var.zones :
    zone => {
      availability_zone = zone
      mgmt_subnet       = aws_subnet.mgmt[zone].id
      datapath_subnet   = aws_subnet.datapath[zone].id
    }
  }
}
