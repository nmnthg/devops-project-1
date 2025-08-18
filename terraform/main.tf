terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lb" "alb" {
    name = "${var.Name_prefix}-alb" 
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb-sg.id]
    subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    tags = { 
        Name = "${var.Name_prefix}-alb" 
    }
}

resource "aws_lb_target_group" "lb-tg" {
    name     = "${var.Name_prefix}-tg" 
    port     = var.container_port
    protocol = "HTTP"
    target_type = "ip"
    vpc_id   = aws_vpc.projVPC.id
    health_check {
        enabled             = true
        protocol            = "HTTP"
        path                = "/"
        matcher             = "200-399"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 5
        timeout             = 5
    }
    tags = { 
        Name = "${var.Name_prefix}-tg" 
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.lb-tg.arn
    }
}