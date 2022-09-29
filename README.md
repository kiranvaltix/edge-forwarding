# Prepare existing VPC for AWS by adding Valtix resources

1. Create the following subnets in each of the availability zones:
    * datapath subnet and datapath route table associated to it, default route to igw
    * mgmt subnet and mgmt route table associated to it, default route to igw
1. Create security groups in the VPC
    * datapath: allow all ingress and egress traffic
    * mgmt: allow all egress traffic

## Variables
* `prefix` - Prefix used for all the resources created, defaults to `valtix_svpc`
* `vpc_id` - VPC Id in which the Valtix resources are created, leave this to empty to create a new VPC
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

## Outputs
* `datapath_subnet` - A map for each zone, with subnet names and ids
    ```
    datapath_subnet = {
      "us-east-1a" = {
        "route_table_id" = "rtb-111111"
        "route_table_name" = "valtix_svpc_us-east-1a_datapath"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "valtix_svpc_us-east-1a_datapath"
      }
      "us-east-1b" = {
        "route_table_id" = "rtb-1111"
        "route_table_name" = "valtix_svpc_us-east-1b_datapath"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "valtix_svpc_us-east-1b_datapath"
      }
    }
    ```
* `datapath_security_group` - A map of id and name
    ```
    {
      "id" = "sg-1111"
      "name" = "valtix_svpc_datapath
    }
    ```
* `mgmt_subnet` - A map for each zone, with subnet names and ids
    ```
    mgmt_subnet = {
      "us-east-1a" = {
        "route_table_id" = "rtb-111111"
        "route_table_name" = "valtix_svpc_us-east-1a_mgmt"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "valtix_svpc_us-east-1a_mgmt"
      }
      "us-east-1b" = {
        "route_table_id" = "rtb-1111"
        "route_table_name" = "valtix_svpc_us-east-1b_mgmt"
        "subnet_id" = "subnet-11111"
        "subnet_name" = "valtix_svpc_us-east-1b_mgmt"
      }
    }
    ```
* `mgmt_security_group` - A map of id and name
    ```
    {
      "id" = "sg-1111"
      "name" = "valtix_svpc_mgmt
    }
    ```
* `valtix_gw_instance_details` - A structure suitable to be used as-is in the valtix_gateway terraform resource
    ```
    "us-east-1a" = {
      "availability_zone" = "us-east-1a"
      "mgmt_subnet" = "subnet-11111"
      "datapath_subnet" = "subnet-11112"
    }
    "us-east-1b" = {
      "availability_zone" = "us-east-1b"
      "mgmt_subnet" = "subnet-21111"
      "datapath_subnet" = "subnet-21112"
    }
    ```
* `vpc_id` - VPC Id that was provided
* `region` - AWS Region that was provided    

## Run as root module

```
cp values-sample values
```

Edit `values` with appropriate values

```
terraform init
terraform apply -var-file values
```
