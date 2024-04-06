variable "az_count" {
  type    = string
  default = "2"
}

variable "cidr_block" {
  type    = string
  default = "172.11.0.0/16"
}

variable "namespace" {
  description = "Namespace (e.g. `fhf`)"
  type        = string
  default     = "cachemoney"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = string
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "chaos" {
  description = "A boolean value that creates chaos in the VPC. Currently denies all traffic in subnets on one AZ"
  type        = bool
  default     = false
}
