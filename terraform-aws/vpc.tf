# data "aws_vpc" "selected" {
#   id = "${var.vpc_id}"
# }

# # TODO: USE TAGS FOR FLITERING PUBLIC/PRIVATE SUBNETS
# data "aws_subnet_ids" "public" {
#   vpc_id = "${var.vpc_id}"

#   tags {
#     Name = "*public*"
#   }
# }

# data "aws_subnet_ids" "private" {
#   vpc_id = "${var.vpc_id}"

#   tags {
#     Name = "*private*"
#   }
# }
