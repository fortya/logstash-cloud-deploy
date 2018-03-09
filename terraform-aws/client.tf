resource "aws_launch_configuration" "client" {
  name_prefix                 = "${var.logstash_cluster}-logstash-client-launch-conf"
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
  name                 = "${var.logstash_cluster}-logstash-nodes-asg"
  max_size             = "${var.nodes_count}"
  min_size             = "${var.nodes_count}"
  desired_capacity     = "${var.nodes_count}"
  default_cooldown     = 30
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.client.id}"
  vpc_zone_identifier  = ["${var.private_subnets}"]

  tags = ["${concat(
    list(
      map("key", "Name", "value", "${var.logstash_cluster}-logstash-nodes-asg", "propagate_at_launch", true),
      map("key", "Role", "value", "logstash", "propagate_at_launch", true)
    ),
    var.global_tags_for_asg)
  }"]

  lifecycle {
    create_before_destroy = true
  }
}
