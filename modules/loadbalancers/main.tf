resource "aws_elb" "myapp_elb" {
    name = "myappelb"
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    health_check {
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 30
        target = "HTTP:80/"
        interval = 60
    }
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    subnets = var.subnet
    security_groups = [var.sg_loadbalancer]
    tags = {
        Name = "${terraform.workspace}-myapp_elb"
    }
}