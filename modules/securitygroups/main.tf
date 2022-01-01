resource "aws_security_group" "cluster" {
  name        = var.ecs_cluster_settings.cluster_name
  vpc_id      = var.vpc_id
  description = var.ecs_cluster_settings.cluster_name
}

resource "aws_security_group_rule" "cluster-allow-http" {
  security_group_id        = aws_security_group.cluster.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "cluster-egress" {
  security_group_id = aws_security_group.cluster.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "ecs_elb" {
    vpc_id = var.vpc_id
    name = "ecs"
    description = "SG for ecs"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags= {
        Name = "ecs-elb"
    }
}