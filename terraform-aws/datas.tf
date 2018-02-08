data "template_file" "client_userdata_script" {
  template = "${file("${path.module}/../templates/user_data.sh")}"

  vars {
    cloud_provider          = "aws"
    volume_name             = ""
    logstash_cluster        = "${var.logstash_cluster}"
    logstash_environment    = "${var.environment}-${var.logstash_cluster}"
    security_groups         = "${aws_security_group.logstash_security_group.id}"
    aws_region              = "${var.aws_region}"
    conf_1_name		    = "${var.conf_1_name}"
    conf_1_file		    = "${var.conf_1_file}"
  }
}
