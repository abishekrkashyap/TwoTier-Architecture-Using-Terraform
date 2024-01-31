#Create Application Load balancer

resource "aws_alb" "applicationLoadBalancer" {
    name = "${var.projectName}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ var.ALB_SG_ID ]
    subnets = [var.PUB_SUB_1_A_ID,var.PUB_SUB_2_B_ID]
    enable_deletion_protection = false

    tags = {
      name = "${var.projectName}-alb"
    }
}

#Create target group

resource "aws_alb_target_group" "albTargetGroup" {
  name = "${var.projectName}-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = var.VPC_ID

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action

resource "aws_lb_listener" "albHttpListner" {
    load_balancer_arn = aws_alb.applicationLoadBalancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.albTargetGroup.arn
    }

}