variable "instance_type" {
  description = "type of instance required for cluster"
  type        = string
  default     = "m7i-flex.large"

}

variable "key_name" {
  description = "key for access"
  type        = string
  default     = "base"

}