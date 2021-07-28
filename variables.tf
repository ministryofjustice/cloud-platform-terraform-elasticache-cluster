variable "cluster_name" {
  description = "The name of the cluster (eg.: cloud-platform-live-0)"
}

variable "team_name" {
}

variable "application" {
}

variable "environment-name" {
}

variable "is-production" {
  default = "false"
}

variable "namespace" {
}

variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  default     = "mojdigital"
}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
}

variable "engine_version" {
  description = "The engine version that your ElastiCache Cluster will use. This will differ between the use of 'redis' or 'memcached'. The default is '5.0.6' with redis being the assumed engine."
  type        = string
  default     = "5.0.6"
}

variable "parameter_group_name" {
  description = "Name of the parameter group to associate with this cache cluster. Again this will differ between the use of 'redis' or 'memcached' and your engine version. The default is 'default.redis5.0'."
  type        = string
  default     = "default.redis5.0"
}

variable "number_cache_clusters" {
  description = "The number of cache clusters (primary and replicas) this replication group will have. Default is 2"
  type        = string
  default     = "2"
}

variable "node_type" {
  description = "The cache node type for your cluster. The next size up is cache.m4.large "
  type        = string
  default     = "cache.t2.medium"
}

variable "maintenance_window" {
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: `sun:05:00-sun:09:00`."
  default     = ""
}
