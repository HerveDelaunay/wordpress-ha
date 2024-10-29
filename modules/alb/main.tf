resource "aws_security_group" "sg_lb" {
  name   = "sg_lb"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # pas sur ici, il faut peut etre mettre 0.0.0.0/0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hde-alb"
  }
}

resource "aws_lb" "lb" {
  name                       = "hde-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = [var.public_subnet_id_a, var.public_subnet_id_b]
  security_groups            = [aws_security_group.sg_lb.id]
  enable_deletion_protection = false
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hde_vms.arn
  }
}

resource "aws_lb_target_group" "hde_vms" {
  name     = "hde-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "tg_attachment_a" {
  target_group_arn = aws_lb_target_group.hde_vms.arn
  target_id        = var.instance_id_a

  port = 80
}

resource "aws_lb_target_group_attachment" "tg_attachment_b" {
  target_group_arn = aws_lb_target_group.hde_vms.arn
  target_id        = var.instance_id_b
  port             = 80
}
