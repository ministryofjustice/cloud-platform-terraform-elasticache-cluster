# Example AWS ElastiCache Cluster configuration

The configuration in this directory creates an example AWS Redis ElastiCache Cluster Replication Group.

This example is designed to be used in the [cloud-platform-environments](https://github.com/ministryofjustice/cloud-platform-environments/) repository.

The output will be in a kubernetes `Secret`, including the the values of `primary_endpoint_address`, `member_clusters` and `auth_token`.

## Usage

In your namespace's path in the [cloud-platform-environments](https://github.com/ministryofjustice/cloud-platform-environments/) repository, create a directory called `resources` (if you have not created one already) and refer to the contents of [elasticache.tf](elasticache.tf) to define the module properties. Make sure to change placeholder values to what is appropriate and refer to the top-level README file in this repository for extra variables that you can use to further customise your resource.

Commit your changes to a branch and raise a pull request. Once approved, you can merge and the changes will be applied. Shortly after, you should be able to access the `Secret` on kubernetes and acccess the resources. You might want to refer to the [documentation on Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).
