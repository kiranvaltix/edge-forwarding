output "vpc" {
  value = {
    id   = aws_vpc.vpc.id
    name = aws_vpc.vpc.tags.Name
  }
}

output "region" {
  value = var.region
}

output "app_subnet" {
  value = { for zone, dummy in var.zones :
    zone => {
      cidr             = aws_subnet.app[zone].cidr_block
      subnet_id        = aws_subnet.app[zone].id
      subnet_name      = aws_subnet.app[zone].tags.Name
      route_table_id   = aws_route_table.app[zone].id
      route_table_name = aws_route_table.app[zone].tags.Name
    }
  }
}

output "app_security_group" {
  value = {
    id   = aws_security_group.app.id
    name = aws_security_group.app.name
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

output "bastionvm" {
  value = {
    id         = aws_instance.bastionvm.id
    name       = aws_instance.bastionvm.tags.Name
    private_ip = aws_instance.bastionvm.private_ip
    public_ip  = aws_instance.bastionvm.public_ip
    ssh        = "ssh ubuntu@${aws_instance.bastionvm.public_ip}"
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

output "valtix_gw" {
  value = { for inst in valtix_gateway.fwd_gw.instance_details :
    inst.availability_zone => {
      datapath_private_ip = inst.datapath_private_ip
      datapath_public_ip  = inst.datapath_public_ip
      mgmt_private_ip     = inst.mgmt_private_ip
      mgmt_public_ip      = inst.mgmt_public_ip
      gwlbe               = local.gwlbe_by_zones[inst.availability_zone]
    }
  }
}

output "z_console_urls" {
  value = {
    instances       = "https://console.aws.amazon.com/ec2/home?#Instances:tag:prefix=${var.prefix};sort=tag:Name"
    route_tables    = "https://console.aws.amazon.com/vpc/home?#RouteTables:tag:prefix=${var.prefix};sort=tag:Name"
    security_groups = "https://console.aws.amazon.com/ec2/home?#SecurityGroups:tag:prefix=${var.prefix};sort=tag:Name"
    subnets         = "https://console.aws.amazon.com/vpc/home?#subnets:tag:prefix=${var.prefix};sort=tag:Name"
    subnets         = "https://console.aws.amazon.com/vpc/home?#subnets:tag:prefix=${var.prefix};sort=tag:Name"
    vpc             = "https://console.aws.amazon.com/vpc/home?#vpcs:tag:prefix=${var.prefix};sort=tag:Name"
  }
}
