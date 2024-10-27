resource "aws_key_pair" "datascientest_aws" {
  key_name   = "datascientest_aws"
  public_key = file("~/.ssh/datascientest_aws.pub")
}

resource "aws_security_group" "sg_22" {

  name   = "sg_22"
  vpc_id = var.vpc.id

  // authorize incoming traffic only on port 22 from all ip addresses
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // authorize outgoing traffic from all ports to all ip addresses
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg-22"
  }
}

// we can fetch external data with the data block
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

resource "aws_instance" "datascientest_bastion_a" {
  ami                    = data.aws_ami.bastion-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_id_a
  vpc_security_group_ids = [aws_security_group.sg_22.id]
  key_name               = aws_key_pair.datascientest_aws.datascientest_aws

  tags = {
    Name        = "hde-bastion-a"
  }

}

resource "aws_instance" "datascientest_bastion_b" {
  ami                    = data.aws_ami.bastion-ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_id_b
  vpc_security_group_ids = [aws_security_group.sg_22.id]
  key_name               = aws_key_pair.datascientest_aws.datascientest_aws

  tags = {
    Name        = "hde-bastion-b"
  }

}