data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

# TODO: USE TAGS FOR FLITERING PUBLIC/PRIVATE SUBNETS
data "aws_subnet_ids" "selected" {
  vpc_id = "${var.vpc_id}"
}
