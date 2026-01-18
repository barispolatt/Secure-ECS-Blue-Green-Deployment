provider "aws" {
  region = "us-west-2"
}

# VPC, Subnet ve Security Group Setup
# Security Group just allows 80 (Prod) and 8080 (Test) ports

# Load balancer
resource "aws_lb" "main" {
  name               = "sufle-demo-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

# target group (blue)
resource "aws_lb_target_group" "blue" {
  name        = "demo-tg-blue"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip" # IP instead of instance because EC2 doesn't has instance ID
  vpc_id      = aws_vpc.main.id
  
  # 30 second delay to close blue 
  deregistration_delay = 30 
  
  health_check {
    path = "/health"
  }
}

# target group (green)
resource "aws_lb_target_group" "green" {
  name        = "demo-tg-green" # İkinci grup
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    path = "/health"
  }
}

# Prod Listener (Port 80)
resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn # Traffic goes to blue when terraform first applied
  }

  # In state file it writes "prod listener looks blue", but when code deploy starts, it turns traffic to green
  # When you terraform apply again, terraform returns it to blue again
  # With ignore_changes, terraform ignores default_action, so CodeDeploy manages it

  lifecycle {
    ignore_changes = [default_action]
  }
}

# Test Listener (Port 8080)
resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.main.arn
  port              = "8080"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
  
  lifecycle {
    ignore_changes = [default_action]
  }
}
