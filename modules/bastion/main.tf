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

  instance_type               = "t2.micro"
  ami                         = data.aws_ami.bastion-ami.id
  key_name                    = "hde-wp-kp"
  vpc_security_group_ids      = [var.allow_public_ssh_sg_id, var.allow_all_outbound_sg_id]
  subnet_id                   = element(var.vpc_public_subnets, 0)
  associate_public_ip_address = true

  tags = {
    Owner = "hde"
  }
}
