variable "logstash_cluster" {
  description = "Name of the logstash cluster"
}

variable "environment" {
  default = "default"
}

variable "aws_region" {
  description = "Aws region where logstash should be provisioned"
  type        = "string"
}

variable "global_tags" {
  type    = "map"
  default = {}
}

variable "global_tags_for_asg" {
  description = "There is a known issue in terraform where tags for ASG are provided diferently than tags for other resources. ASG tags should have key, value, and propagate_at_launch attributes."
  type        = "list"
  default     = []

  # default = [
  #   {
  #     key = "Foo"
  #     value = "Bar"
  #     propagate_at_launch = true
  #   },
  #   ...
  # ]
}

variable "vpc_id" {
  description = "VPC ID where logstash should be provisioned"
  type        = "string"
}

variable "public_subnets" {
  description = "List of public subnet ids"
  type        = "list"
}

variable "public_subnets_cidrs" {
  description = "Private subnets cidrs (ie. ['10.0.1.0/24', '10.0.1.0/24'])"
  type        = "list"
}

variable "private_subnets" {
  description = "List of private subnet ids"
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
