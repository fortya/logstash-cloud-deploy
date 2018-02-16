resource "aws_security_group" "logstash_security_group" {
  name        = "logstash-${var.logstash_cluster}-security-group"
  description = "Logstash ports with ssh"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name    = "${var.logstash_cluster}-logstash"
    cluster = "${var.logstash_cluster}"
  }

  # ssh access from everywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 5044
    to_port   = 5044
    protocol  = "tcp"
    self      = true
  }

  # allow inter-cluster ping
  ingress {
    from_port = 8
    to_port   = 0
    protocol  = "icmp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "logstash_elb_security_group" {
  name        = "logstash-${var.logstash_cluster}-elb-security-group"
  description = "Logstash HTTP access from outside"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name    = "${var.logstash_cluster}-kibana"
    cluster = "${var.logstash_cluster}"
  }

  # allow HTTP access to client nodes via port 8080 - better to disable, and either way always password protect!
  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
