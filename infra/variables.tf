variable "project_name" {
  default = "crc"
}

variable "environment" {
  default = "dev"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}
