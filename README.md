# Edge VPC with Valtix Gateway in Forwarding Mode

1. Create the following subnets in each of the availability zones:
    * datapath subnet and datapath route table associated to it, default route to igw
    * mgmt subnet and mgmt route table associated to it, default route to igw
    * app subnet and app route table associated to it, default route via Valtix GWLBE
1. Create security groups in the VPC
    * datapath: allow all ingress and egress traffic
    * mgmt: allow all egress traffic and port 22 on ingress
1. Create bastionvm in the mgmt subnet and associate the mgmt security group
1. Create a route table in each of the availability zones and associate that to the IGW
1. Add a route to the app subnet via Valtix GWLBE
1. Create Valtix Egress Gateway, policy rule set and forwarding rule, service without snt

## Variables
* `prefix` - Prefix used for all the resources created, defaults to `valtix_svpc`
* `aws_creds_profile` - AWS Credentials (profile name)
* `vpc_cidr` - If a new VPC needs to be created, then use this CIDR for the VPC
* `region` - AWS region where Valtix Gateways are deployed
* `zones` - Availability zones, a map of zone name to cidrs. *Note* If nat_cidr is provided, then public subnets with the defined CIDR are created. NAT Gateways are created in thos public subnets and used as next hop in the datapath and mgmt route tables. If you dont' want NAT GW, make this empty string. If a new VPC is created, then specifying `app_cidr` would also create app subnets and vm instances in those subnets

    ```
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
    ```
* `vm_key_name` - SSH Key pair name for the VM
* `valtix_api_key` - Valtix API Key file (json file)
* `cloud_account_name` - Cloud account name used on the Valtix Dashboard to onboard the AWS Account
* `gw_iam_role_name` - IAM Role name to assign to the Valtix Gateway Instances

## Running

```
cp values-sample.tfvars values
```

Edit `values` with appropriate values

```
terraform init
terraform apply -var-file values
```
