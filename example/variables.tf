variable "vpc_name" {
  description = "The name of the vpc (eg.: live-1)"
  type        = string
}

variable "team_name" {
  description = "The name of your development team"
  type        = string
}

variable "application" {
  description = "The name of your application"
  type        = string
}

variable "environment-name" {
  description = "The name of your environment"
  type        = string
}

variable "is-production" {
  description = "Whether this is a production ElastiCache cluster"
  type        = string
}

variable "namespace" {
  description = "The name of your namespace"
  type        = string
}

variable "business-unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "infrastructure-support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}
