data "template_file" "static_app" {
    template = "${file("./modules/ServiceStatic/templates/app.json.tpl")}"
}
resource "aws_ecs_task_definition" "myapp_task" {
    family = var.ecs_service_settings.familyName
    container_definitions = "${data.template_file.static_app.rendered}"
}

resource "aws_ecs_service" "myapp_service" {
    name = var.ecs_service_settings.serviceName
    cluster = var.clusterid
    task_definition = aws_ecs_task_definition.myapp_task.arn
    desired_count = var.ecs_service_settings.d_count
    iam_role = var.servicearn
    
    load_balancer {
        elb_name = var.elb_id_ref
        container_name = var.ecs_service_settings.familyName
        container_port = var.ecs_service_settings.containerPort
        
    }
} 