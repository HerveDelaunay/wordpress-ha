resource "aws_key_pair" "datascientest_aws" {
  key_name   = "datascientest_aws"
  public_key = file("~/.ssh/datascientest_aws.pub")
}
data "aws_ami" "wordpress-ami" {
  // we want the most recent version of the image
  most_recent = true
  owners      = ["amazon"]

  // dynamically fetch the ami
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
resource "aws_security_group" "sg_wordpress" {
  name   = "sg_wordpress"
  vpc_id = var.vpc_id

  tags = {
    Name = "hde_sg_wordpress"
  }
}

resource "aws_security_group_rule" "inbound_allow" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24", "10.2.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_wordpress.id
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_wordpress.id
}

resource "aws_instance" "wordpress_a" {
  ami                    = data.aws_ami.wordpress-ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id_a
  vpc_security_group_ids = [aws_security_group.sg_wordpress.id]
  key_name               = aws_key_pair.datascientest_aws.key_name
  user_data              = file("install_wordpress.sh")
  tags = {
    Name = "hde_wordpress_a"
  }
}

resource "aws_instance" "wordpress_b" {
  ami                    = data.aws_ami.wordpress-ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id_b
  vpc_security_group_ids = [aws_security_group.sg_wordpress.id]
  key_name               = aws_key_pair.datascientest_aws.key_name
  user_data              = file("install_wordpress.sh")
  tags = {
    Name = "hde_wordpress_b"
  }
}
