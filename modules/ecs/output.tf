output "ecs_cluster_settings" {
    value = {
        cluster_arn = aws_ecs_cluster.cluster.id
    }
}