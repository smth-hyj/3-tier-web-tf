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


resource "aws_launch_configuration" "front-end" {
  name          = "web_config"
  image_id      = data.aws_ami.amzLinux.id
  instance_type = "t2.micro"
  user_data = file("../modules/asg/front/userdata.tpl")
  security_groups = [var.webSGid]
}

resource "aws_autoscaling_group" "front-end-asg" {
  vpc_zone_identifier       = var.webSBids
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_type         = "ELB"
  force_delete              = true
  
  launch_configuration = aws_launch_configuration.front-end.name
}

resource "aws_lb" "webLB" {
  name               = "web-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.webSGid]
  subnets            = var.webSBids

  # enable_deletion_protection = true

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "front-end"
  }
}

resource "aws_lb_target_group" "webTG" {
  name     = "front-end-tg"
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

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.front-end-asg.id
  lb_target_group_arn    = aws_lb_target_group.webTG.arn
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.webLB.arn
  port              = 80
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webTG.arn
  }
}
