output "loadbalancer_settings" {
    value = {
        elb_id = aws_elb.myapp_elb.id
    }
  
}