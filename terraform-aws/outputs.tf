output "dns" {
  value = "${aws_lb.logstash.dns_name}:5044"
}
