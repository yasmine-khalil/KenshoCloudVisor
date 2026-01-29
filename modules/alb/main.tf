################################################################################
# Application Load Balancer
################################################################################
resource "aws_lb" "alb" {
  name               = "${var.env}-${var.project}-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = concat([aws_security_group.alb_sg.id], var.additional_security_groups)
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = true

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-alb"
  })
}

################################################################################
# Security Group
################################################################################
resource "aws_security_group" "alb_sg" {
  name        = "${var.env}-${var.project}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description

      # Use prefix_list_ids if defined, otherwise fallback to cidr_blocks
      prefix_list_ids = lookup(ingress.value, "prefix_list_ids", null)
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-alb-sg"
  })
}


################################################################################
# Target Group
################################################################################
resource "aws_lb_target_group" "tg" {
  name        = "${var.env}-${var.project}-frontend-tg"
  port        = var.frontend_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = var.target_group_protocol
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-frontend-tg"
  })
}

################################################################################
# Target Group for Port 3000
################################################################################
resource "aws_lb_target_group" "tg_3000" {
  name        = "${var.env}-${var.project}-backend-tg"
  port        = var.backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-backend-tg"
  })
}

################################################################################
# HTTP Listener (redirect to HTTPS if certificate provided)
################################################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != null ? "redirect" : "forward"

    dynamic "redirect" {
      for_each = var.certificate_arn != null ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    dynamic "forward" {
      for_each = var.certificate_arn == null ? [1] : []
      content {
        target_group {
          arn = aws_lb_target_group.tg.arn
        }
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-http-listener"
  })
}

################################################################################
# HTTPS Listener (only if certificate provided)
################################################################################
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-https-listener"
  })
}

################################################################################
# HTTP 3000 Listener
################################################################################
resource "aws_lb_listener" "http_3000" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_3000.arn
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.project}-http-3000-listener"
  })
}