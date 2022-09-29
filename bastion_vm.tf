locals {
  bastion_zone = keys(var.zones)[0]
}

resource "aws_instance" "bastionvm" {
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = local.bastion_zone
  subnet_id                   = aws_subnet.app[local.bastion_zone].id
  vpc_security_group_ids      = [aws_security_group.mgmt.id]
  instance_type               = var.vm_instance_type
  associate_public_ip_address = true
  key_name                    = var.vm_key_name

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name   = "${var.prefix}-app-${local.bastion_zone}"
    prefix = var.prefix
  }
  volume_tags = {
    Name   = "${var.prefix}-app-${local.bastion_zone}"
    prefix = var.prefix
  }
}
