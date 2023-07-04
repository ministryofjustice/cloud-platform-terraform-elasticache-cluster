#################
# Configuration #
#################
variable "vpc_name" {
  description = "The name of the vpc (eg.: live-1)"
  type        = string
}

variable "engine_version" {
  description = "Engine version (e.g. 7.0)"
  type        = string
}

variable "parameter_group_name" {
  description = "Name of the parameter group aligned with the version specified in engine_version (e.g. default.redis7)"
  type        = string
}

variable "node_type" {
  description = "Instance class to be used"
  type        = string
}

variable "number_cache_clusters" {
  description = "Number of cache clusters (primary and replicas) this replication group will have"
  type        = string
  default     = "2"
}

variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00"
  default     = ""
}

variable "maintenance_window" {
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is `ddd:hh24:mi-ddd:hh24:mi` (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: `sun:05:00-sun:09:00`."
  default     = ""
}

variable "auth_token_rotated_date" {
  type        = string
  default     = ""
  description = "Process to spin new auth token. Pass date to regenerate new token"
}

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}
