variable "team_name" {}

variable "business-unit" {
  description = " Area of the MOJ responsible for the service"
  default     = "mojdigital"
}

variable "application" {}

variable "is-production" {
  default = "false"
}

variable "environment-name" {}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
}

variable "ec_engine" {
    description = "The engine which your ElastiCache Cluster will use. You have a choice of either 'redis' or 'memcached'. The default is 'redis'"
    type = "string"
    default = "redis"
}

variable "engine_version" {
    description = "The engine version that your ElastiCache Cluster will use. This will differ between the use of 'redis' or 'memcached'. The default is '4.0.10' with redis being the assumed engine."
    type = "string"
    default = "4.0.10"
}

variable "parameter_group_name" {
    description = "Name of the parameter group to associate with this cache cluster. Again this will differ between the use of 'redis' or 'memcached' and your engine version. The default is 'default.redis4.0'."
    type = "string"
    default = "default.redis4.0"
}

variable "cluster_id" {
    description = "The desired name of your ElastiCache cluster"
    type = "string"
}

variable "node_type" {
    description = "The cache node type for your cluster. The default is 'cache.m3.medium' which is considered to have moderate network preformance."
    type = "string"
    default = "cache.m3.medium"
}

variable "number_of_nodes" {
    description = "The number of cache nodes that your cluster will have. Default is '1'."
    default = 1
}

variable "port" {
    description = "The port number of your ElastiCache Cluster. Redis uses '6379' and Memached uses '11211'. The default will be '6379' with Redis being the assumed engine"
    default = 6379
}

variable "ec_subnet_groups" {
    description = "A list of VPC subnet IDs."
    default = ["subnet-7293103a", "subnet-7bf10c21", "subnet-de00b3b8"]
}