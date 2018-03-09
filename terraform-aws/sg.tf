resource "aws_security_group" "logstash_security_group" {
  name        = "logstash-${var.logstash_cluster}-security-group"
  description = "SG for Logstash instances sitting on private subnets"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.global_tags,map("Name","${var.logstash_cluster}-logstash-sg"))}"

  # ssh access from everywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.admin_cidrs}"]
    description = "Allow SSH access to admin users"
  }

  #TODO: We should only allow access from public subnets
  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnets_cidrs}"]
    description = "Allow logstash traffic from public subnets"
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    self        = true
    description = "Allow inter-cluster ping"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbounb traffic"
  }
}

resource "aws_security_group" "logstash_elb_security_group" {
  name        = "logstash-${var.logstash_cluster}-elb-security-group"
  description = "SG for Logstash Load Balancer sitting on public subnets"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.global_tags,map("Name","${var.logstash_cluster}-logstash-lb-sg"))}"

  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow logstash traffic from the internet"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbounb traffic"
  }
}
