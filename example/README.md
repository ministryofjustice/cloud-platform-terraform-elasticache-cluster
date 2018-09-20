# Example AWS ElastiCache Cluster creation

The configuration in this directory creates an example AWS Redis ElastiCache Cluster Replication Group. It also creates an ElastiCache subnet group for the `live-0` VPC.  

This example outputs ID, primary_endpoint_address, member_clusters, and the auth_token which is the password to gain access to the Redis Server.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you want to destroy these resources created.

