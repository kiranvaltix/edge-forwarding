output "app_vms" {
  value = { for zone, dummy in var.zones :
    zone => {
      name = "${aws_instance.vm[zone].tags.Name} / ${aws_instance.vm[zone].id}"
      ip   = "${aws_instance.vm[zone].public_ip} / ${aws_instance.vm[zone].private_ip}"
    }
  }
}

output "bastion_vm" {
  value = {
    name = "${aws_instance.bastionvm.tags.Name} / ${aws_instance.bastionvm.id}"
    ip   = "${aws_instance.bastionvm.public_ip} / ${aws_instance.bastionvm.private_ip}"
    ssh  = "ssh ubuntu@${aws_instance.bastionvm.public_ip}"
  }
}

output "valtix_gw" {
  value = { for inst in valtix_gateway.fwd_gw.instance_details :
    inst.availability_zone => {
      datapath_ip = "${inst.datapath_public_ip} / ${inst.datapath_private_ip}"
      mgmt_ip     = "${inst.mgmt_public_ip} / ${inst.mgmt_private_ip}"
      gwlbe       = local.gwlbe_by_zones[inst.availability_zone]
    }
  }
}

output "z_aws_console_urls" {
  value = {
    instances       = "https://console.aws.amazon.com/ec2/home?#Instances:tag:prefix=${var.prefix};sort=tag:Name"
    route_tables    = "https://console.aws.amazon.com/vpc/home?#RouteTables:tag:prefix=${var.prefix};sort=tag:Name"
    security_groups = "https://console.aws.amazon.com/ec2/home?#SecurityGroups:tag:prefix=${var.prefix};sort=tag:Name"
    subnets         = "https://console.aws.amazon.com/vpc/home?#subnets:tag:prefix=${var.prefix};sort=tag:Name"
    subnets         = "https://console.aws.amazon.com/vpc/home?#subnets:tag:prefix=${var.prefix};sort=tag:Name"
    vpc             = "https://console.aws.amazon.com/vpc/home?#vpcs:tag:prefix=${var.prefix};sort=tag:Name"
  }
}
