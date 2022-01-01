output "vpc_output" {
  value ={
    vpc_id = aws_vpc.VPC.id
    public_subnet   = aws_subnet.PublicSubnet.*
    private_subnet  = aws_subnet.PrivateSubnet.*
    vpc_azs = local.sum_of_azs
  }
}