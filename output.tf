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
      gwlbe       = local.gwlbe_by_zones[inst.availability_zone]
      id          = "${inst.instance_id}"
      mgmt_ip     = "${inst.mgmt_public_ip} / ${inst.mgmt_private_ip}"
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
    vpc             = "https://console.aws.amazon.com/vpc/home?#vpcs:tag:prefix=${var.prefix};instanceState=running;sort=tag:Name"
  }
}

output "z_cmds" {
  value = {
    ingress = { for zone, dummy in var.zones :
      zone => [
        "curl ${aws_instance.vm[zone].public_ip}",
        "curl https://${aws_instance.vm[zone].public_ip}",
        "curl --resolve www.app1.com:443:${aws_instance.vm[zone].public_ip} https://www.app1.com",
        "curl --resolve www.app2.com:443:${aws_instance.vm[zone].public_ip} https://www.app2.com",
        "curl --resolve www.app3.com:443:${aws_instance.vm[zone].public_ip} https://www.app3.com",
      ]
    }
    egress = { for zone, dummy in var.zones :
      zone => [
        "ssh ubuntu@${aws_instance.vm[zone].public_ip} git clone https://github.com/valtix-security/sample-web-app.git",
        "ssh ubuntu@${aws_instance.vm[zone].public_ip} curl https://www.google.com -s -o /dev/null -v"
      ]
    }
  }
}
