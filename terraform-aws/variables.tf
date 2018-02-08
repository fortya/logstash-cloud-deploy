variable "logstash_cluster" {
  description = "Name of the logstash cluster"
}

variable "environment" {
  default = "default"
}

variable "vpc_id" {
  description = "VPC ID to create the Logstash cluster in"
  type = "string"
}

variable "aws_region" {
  type = "string"
}


variable "nodes_count" {
  default = "2"
}

variable "availability_zones" {
  type = "list"
  description = "AWS region to launch servers"
  default = []
}

variable "key_name" {
  description = "Key name to be used with the launched EC2 instances."
  default = "logstash"
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
