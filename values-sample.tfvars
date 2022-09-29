prefix = "valtix_svpc"
aws_creds_profile = "default"
vpc_cidr = "10.0.0.0/16"
region = "us-east-1"
zones = {
  "us-east-1a" = {
    app_cidr      = "10.0.0.0/24"
    datapath_cidr = "10.0.2.0/24"
    mgmt_cidr     = "10.0.4.0/24"
  }
  "us-east-1b" = {
    app_cidr      = "10.0.1.0/24"
    datapath_cidr = "10.0.3.0/24"
    mgmt_cidr     = "10.0.5.0/24"
  }
}

vm_instance_type = "t3a.medium"
vm_key_name      = ""

gw_iam_role_name = ""
cloud_account_name = ""