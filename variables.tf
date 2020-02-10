variable "hosted_zone" {
  description = "The Route53 hosted zone to be used for this service (e.g. example.com.)"
  type        = string
}

variable "domain_name" {
  description = "A domain name for which the certificate should be issued (e.g. www.example.com)"
  type        = string
}

variable "tags" {
  description = "Default tags assigned to each resource"
  type        = map
  default     = {}
}
