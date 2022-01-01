output "securitygroup" {
    value = {
        sg_cluster = aws_security_group.cluster.id
        sg_elb = aws_security_group.ecs_elb.id
    }
}