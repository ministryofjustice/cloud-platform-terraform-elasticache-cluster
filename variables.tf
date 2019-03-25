variable "cluster_name" {
  description = "The name of the cluster (eg.: cloud-platform-live-0)"
}

variable "cluster_state_bucket" {
  description = "The name of the S3 bucket holding the terraform state for the cluster"
}

variable "team_name" {}

variable "application" {}

variable "environment-name" {}

variable "is-production" {
  default = "false"
}

variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  default     = "mojdigital"
}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
}

variable "engine_version" {
  description = "The engine version that your ElastiCache Cluster will use. This will differ between the use of 'redis' or 'memcached'. The default is '4.0.10' with redis being the assumed engine."
  type        = "string"
  default     = "4.0.10"
}

variable "parameter_group_name" {
  description = "Name of the parameter group to associate with this cache cluster. Again this will differ between the use of 'redis' or 'memcached' and your engine version. The default is 'default.redis4.0'."
  type        = "string"
  default     = "default.redis4.0"
}

variable "number_cache_clusters" {
  description = "The number of cache clusters (primary and replicas) this replication group will have. Default is 2"
  type        = "string"
  default     = "2"
}

variable "node_type" {
  description = "The cache node type for your cluster. The default is 'cache.m3.medium' which is considered to have moderate network preformance."
  type        = "string"
  default     = "cache.m3.medium"
}

variable "aws_region" {
  description = "Region into which the resource will be created."
  default     = "eu-west-2"
}
