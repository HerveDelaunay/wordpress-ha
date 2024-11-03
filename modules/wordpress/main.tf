locals {
  user_data = templatefile("${path.module}/install_wordpress.sh",
    {
      db_name     = var.db_name,
      db_username = var.db_username,
      db_password = var.db_password,
      db_hostname = var.db_hostname
  })
  instance_type = "t2.micro"
}
resource "aws_key_pair" "datascientest_aws" {
  key_name   = "datascientest_aws"
  public_key = file("~/.ssh/datascientest_aws.pub")
}
data "aws_ami" "wordpress-ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

module "datascientest-auto-scaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~>7.4"

  name            = "wordpress-auto-scaling"
  use_name_prefix = false
  instance_name   = "wordpress"

  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  default_instance_warmup   = 300
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.private_subnets

  # Traffic source attachment
  create_traffic_source_attachment = true
  traffic_source_identifier        = module.alb.target_groups["asg"].arn
  traffic_source_type              = "elbv2"

  # Launch template
  launch_template_name        = "wordpress-launch-template"
  launch_template_description = "wordress-instance"
  update_default_version      = true

  image_id      = data.aws_ami.wordpress-ami.id
  instance_type = local.instance_type
  user_data     = base64encode(local.user_data)
  key_name      = aws_key_pair.datascientest_aws.key_name

  security_groups = [var.allow_private_ssh_id, var.allow_public_http_id, var.allow_all_outbound_id]

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]

  tags = {
    Owner = "hde"
  }

  scaling_policies = {
    avg-cpu-policy-greater-than-50 = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
      }
    }
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.7.0"

  name = "wordpress-lb"

  vpc_id  = var.vpc_id
  subnets = var.vpc_public_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr_block
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "asg"
      }
    }
  }

  target_groups = {
    asg = {
      backend_protocol                  = "HTTP"
      backend_port                      = 80
      target_type                       = "instance"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      # There's nothing to attach here in this definition.
      # The attachment happens in the ASG module above
      create_attachment = false
    }
  }

  tags = {
    Owner = "hde"
  }
}
