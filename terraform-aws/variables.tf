variable "logstash_cluster" {
  description = "Name of the logstash cluster"
}

variable "environment" {
  default = "default"
}

variable "vpc_id" {
  description = "VPC ID where logstash should be provisioned"
  type        = "string"
}

variable "aws_region" {
  description = "Aws region where logstash should be provisioned"
  type = "string"
}

# TODO - Use tags for public/private subnets
variable "public_subnets" {
  description = "List of public subnet ids"
  type        = "list"
}

# TODO - Use tags for public/private subnets
variable "private_subnets" {
  description = "List of public subnet ids"
  type        = "list"
}

variable "admin_cidrs" {
  description = "List of CIDRs to whitelist for SSH access"
  type        = "list"
  default     = []
}

variable "nodes_count" {
  default = "2"
}

variable "availability_zones" {
  description = "AWS region to launch servers"
  type        = "list"
  default     = []
}

variable "key_name" {
  description = "Key name to be used with the launched EC2 instances."
  default     = "logstash"
}

variable "node_instance_type" {
  default = "t2.medium"
}

variable "conf_1_name" {
  default = ""
}

variable "conf_1_file" {
  default = ""
}
