// Find the latest available AMI for Logstash
data "aws_ami" "logstash" {
  filter {
    name = "state"
    values = ["available"]
  }
  filter {
    name = "tag:ImageType"
    values = ["logstash-packer-image"]
  }
  most_recent = true
}
