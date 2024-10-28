resource "aws_security_group" "sg_wordpress" {
  name   = "sg_wordpress"
  vpc_id = var.vpc_id

  tags = {
    Name        = "hde_sg_wordpress"
  }
}

resource "aws_security_group_rule" "inbound_allow" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_wordpress.id
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type = "egress"

  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_wordpress.id
}