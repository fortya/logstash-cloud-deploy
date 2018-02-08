provider "aws" {
  region = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}


##############################################################################
# Logstash
##############################################################################

resource "aws_security_group" "logstash_security_group" {
  name = "logstash-${var.logstash_cluster}-security-group"
  description = "Logstash ports with ssh"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.logstash_cluster}-logstash"
    cluster = "${var.logstash_cluster}"
  }

  # ssh access from everywhere
  ingress {
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 5044
    to_port           = 5044
    protocol          = "tcp"
    self              = true
  }

  # allow inter-cluster ping
  ingress {
    from_port         = 8
    to_port           = 0
    protocol          = "icmp"
    self              = true
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "logstash_elb_security_group" {
  name = "logstash-${var.logstash_cluster}-elb-security-group"
  description = "Logstash HTTP access from outside"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.logstash_cluster}-kibana"
    cluster = "${var.logstash_cluster}"
  }

  # allow HTTP access to client nodes via port 8080 - better to disable, and either way always password protect!
  ingress {
    from_port         = 5044
    to_port           = 5044
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "client" {
  name_prefix = "logstash-${var.es_cluster}-client-nodes"
  image_id = "${data.aws_ami.logstash.id}"
  instance_type = "${var.node_instance_type}"
  security_groups = ["${aws_security_group.logstash_security_group.id}"]
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.logstash.id}"
  user_data = "${data.template_file.client_userdata_script.rendered}"
  key_name = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "client_nodes" {
  name = "logstash-${var.logstash_cluster}-logstash-nodes"
  max_size = "${var.nodes_count}"
  min_size = "${var.nodes_count}"
  desired_capacity = "${var.nodes_count}"
  default_cooldown = 30
  force_delete = true
  launch_configuration = "${aws_launch_configuration.client.id}"

  load_balancers = ["${aws_elb.logstash_client_lb.id}"]

  vpc_zone_identifier = ["${data.aws_subnet_ids.selected.ids}"]

  tag {
    key                 = "Name"
    value               = "${format("%s-logstash-node", var.logstash_cluster)}"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key = "Cluster"
    value = "${var.environment}-${var.logstash_cluster}"
    propagate_at_launch = true
  }

  tag {
    key = "Role"
    value = "client"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
