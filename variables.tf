variable "prefix" {
  description = "Prefix for the resources (subnets, route tables, security groups)"
  default     = "valtix_svpc"
}

variable "aws_creds_profile" {
  description = "AWS Credentials Profile Name"
}

variable "vpc_cidr" {
  description = "If a new VPC is created, use the CIDR block provided here"
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "AWS region where Valtix Gateways are deployed"
  default     = "us-east-1"
}

variable "zones" {
  description = "List of Availability Zone names where the Valtix Gateway instances are deployed. nat_cidr can be empty if NAT GW is not required"
  type = map(object({
    app_cidr      = string
    datapath_cidr = string
    mgmt_cidr     = string
  }))
  default = {
    "us-east-1a" = {
      app_cidr      = ""
      datapath_cidr = "10.0.2.0/24"
      mgmt_cidr     = "10.0.4.0/24"
    }
    "us-east-1b" = {
      app_cidr      = ""
      datapath_cidr = "10.0.3.0/24"
      mgmt_cidr     = "10.0.5.0/24"
    }
  }
}

variable "vm_instance_type" {
  description = "VM Instance Type if app subnets are created"
  default     = "t3a.small"
}

variable "vm_key_name" {
  description = "SSH Keypair Name to assign to the VM"
}

variable "valtix_api_key" {
  description = "Valtix API key file"
}

variable "cloud_account_name" {
  description = "AWS Cloud Account Name onboarded onto the Valtix Controller"
}

variable "gw_iam_role_name" {
  description = "Valtix Gateway IAM Role Name"
}