output "iamrole" {
    value = {
        service_role_arn = aws_iam_role.cluster-service-role.arn
        ec2_servicerole_arn = aws_iam_role.cluster-ec2-role.arn
        ec2_servicerole_id = aws_iam_role.cluster-ec2-role.id
    } 
}