vpc = {
    AWS_REGION          = "us-west-2"
    vpc_cidr            = "10.0.0.0/16"
    public_subnet_cidr  = [ "10.0.1.0/24", "10.0.2.0/24" ]
    private_subnet_cidr = [ "10.0.4.0/24", "10.0.3.0/24"]
}
ecs_cluster = {
    cluster_name = "prod-MyCluster"
    instance_type = "t2.micro"
    ssh_key_name = ""
    aws_account_id = ""
    log_group = "MyCluster-LG"
    ecs_maxsize = 1
    ecs_desired_capacity = 1
    ecs_minsize = 1
    ami_id = ""
    public_subnets_val = "public-subnet1 , public-subnet2"
}
ecs_service = {
    familyName = "myapp"
    serviceName = "myapp"
    d_count = 1
    containerName = "myapp"
    containerPort = 80
}
sg = {}
lb = {}
iamroles = {}




