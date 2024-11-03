resource "aws_key_pair" "datascientest_aws" {
  key_name   = "datascientest_aws"
  public_key = file("~/.ssh/datascientest_aws.pub")
}

data "aws_ami" "bastion-ami" {
  // we want the most recent version of the image
  most_recent = true
  owners      = ["amazon"]

  // dynamically fetch the ami
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "bastion"

  instance_type          = "t2.micro"
  key_name               = aws_key_pair.datascientest_aws.key_name
  vpc_security_group_ids = [var.allow_public_ssh_sg_id, var.allow_all_outbound_sg_id]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Owner = "hde"
  }
}
