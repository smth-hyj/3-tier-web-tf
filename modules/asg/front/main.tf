resource "aws_launch_template" "front-end" {
  name_prefix   = "front-end-"
  image_id      = "ami-0b8414ae0d8d8b4cc"
  instance_type = "t2.micro"

  user_data = filebase64("../modules/asg/front/userdata.tpl")
}

resource "aws_autoscaling_group" "front-end-asg" {
  availability_zones = ["ap-northeast-2a","ap-northeast-2c"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2


  launch_template {
    id      = aws_launch_template.front-end.id

  }
}