resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_settings.cluster_name
}

data "template_file" "ecs_init" {
  template = file("${path.module}/templates/ecs_init.tpl")
  vars = {
    cluster_name = var.ecs_cluster_settings.cluster_name
  }
}
#
# launchconfig
#
resource "aws_launch_configuration" "cluster" {
  name_prefix          = "ecs-${var.ecs_cluster_settings.cluster_name}-launchconfig"
  image_id             = var.ecs_cluster_settings.ami_id
  instance_type        = var.ecs_cluster_settings.instance_type
  key_name             = var.ecs_cluster_settings.ssh_key_name
  iam_instance_profile = var.ec2_role
  security_groups      = [var.sg_cluster_id]
  user_data            = data.template_file.ecs_init.rendered
  lifecycle {
    create_before_destroy = true
  }
}

#
# autoscaling
resource "aws_autoscaling_group" "cluster" {
  name                 = "ecs-${var.ecs_cluster_settings.cluster_name}-autoscaling"
  vpc_zone_identifier  = var.private_subnet
  launch_configuration = aws_launch_configuration.cluster.name
  min_size             = var.ecs_cluster_settings.ecs_minsize
  max_size             = var.ecs_cluster_settings.ecs_maxsize
  desired_capacity     = var.ecs_cluster_settings.ecs_desired_capacity

  tag {
    key                 = "Name"
    value               = "${var.ecs_cluster_settings.cluster_name}-ecs"
    propagate_at_launch = true
  }
}


