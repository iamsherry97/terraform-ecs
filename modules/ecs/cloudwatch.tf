#
# Cloudwatch logs
#
resource "aws_cloudwatch_log_group" "cluster" {
  name = var.ecs_cluster_settings.log_group
}

