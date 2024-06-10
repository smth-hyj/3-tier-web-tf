data "aws_ami" "amzLinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.*.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

resource "aws_launch_configuration" "back-end" {
  name          = "app_config"
  image_id      = data.aws_ami.amzLinux.id
  instance_type = "t2.micro"
  user_data = file("../modules/asg/back/userdata.tpl")
  security_groups = [var.appSGid]
}

resource "aws_autoscaling_group" "back-end-asg" {
  vpc_zone_identifier       = var.appSBids
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_type         = "ELB"
  force_delete              = true
  
  launch_configuration = aws_launch_configuration.back-end.name
}

resource "aws_lb" "appLB" {
  name               = "app-LB"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.appSGid, var.webSGid]
  subnets            = concat(var.appSBids, var.webSBids)

  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "back-end"
  }
}

resource "aws_lb_target_group" "appTG" {
  name     = "back-end-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  # target_group의 인스턴스의 health_check를 설정합니다.
  health_check {
	interval	= 15
	path		= "/"
	port		= 80
	healthy_threshold = 3
	unhealthy_threshold = 3
  }
}

resource "aws_autoscaling_attachment" "appASGattach" {
  autoscaling_group_name = aws_autoscaling_group.back-end-asg.id
  lb_target_group_arn    = aws_lb_target_group.appTG.arn
}

resource "aws_lb_listener" "appLBlisten" {
  load_balancer_arn = aws_lb.appLB.id

  default_action {
    target_group_arn = aws_lb_target_group.appTG.id
    type             = "forward"
  }
}