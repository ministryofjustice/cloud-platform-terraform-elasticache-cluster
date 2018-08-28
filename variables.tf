variable "team_name" {}

variable "ec_engine" {
    description = "The engine which your ElastiCache Cluster will use. You have a choice of either 'redis' or 'memcached'. The default is 'redis'"
    type = "string"
    default = "redis"
}

variable "engine_version" {
    description = "The engine version that your ElastiCache Cluster will use. This will differ between thr use of 'redis' or 'memcached'. The default is '4.0.10' with redis being the assumed engine."
    type = "string"
    default = "4.0.10"
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