locals {
  user_data = <<EOF
#! /bin/bash
curl -o /tmp/setup.sh https://raw.githubusercontent.com/maskiran/sample-web-app/main/ubuntu/setup_app.sh
bash /tmp/setup.sh &> /tmp/setup.log
EOF
}

resource "aws_instance" "vm" {
  for_each                    = var.zones
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = each.key
  subnet_id                   = aws_subnet.app[each.key].id
  vpc_security_group_ids      = [aws_security_group.app.id]
  instance_type               = var.vm_instance_type
  associate_public_ip_address = true
  key_name                    = var.vm_key_name

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name   = "${var.prefix}-app-${each.key}"
    prefix = var.prefix
  }
  volume_tags = {
    Name   = "${var.prefix}-app-${each.key}"
    prefix = var.prefix
  }

  user_data = local.user_data
}
