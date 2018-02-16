resource "aws_launch_configuration" "client" {
  name_prefix                 = "logstash-${var.logstash_cluster}-client-nodes"
  image_id                    = "${data.aws_ami.logstash.id}"
  instance_type               = "${var.node_instance_type}"
  security_groups             = ["${aws_security_group.logstash_security_group.id}"]
  associate_public_ip_address = true

  #iam_instance_profile = "${aws_iam_instance_profile.logstash.id}"
  user_data = "${data.template_file.client_userdata_script.rendered}"
  key_name  = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "client_nodes" {
  name                 = "logstash-${var.logstash_cluster}-logstash-nodes"
  max_size             = "${var.nodes_count}"
  min_size             = "${var.nodes_count}"
  desired_capacity     = "${var.nodes_count}"
  default_cooldown     = 30
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.client.id}"
  vpc_zone_identifier  = ["${var.private_subnets}"]

  tag {
    key                 = "Name"
    value               = "${format("%s-logstash-node", var.logstash_cluster)}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Cluster"
    value               = "${var.environment}-${var.logstash_cluster}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "client"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
