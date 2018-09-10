# Example AWS ElastiCache Cluster creation

The configuration in this directory creates an example AWS Redis ElastiCache Cluster. It also creates an ElastiCache subnet group for the `live-0` VPC.  

This example outputs a list of node objects including id, address, port and availability_zone.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you want to destroy these resources created.

