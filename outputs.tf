output "output_data" {
    value = {
        vpc_id = module.VPC.vpc_output.vpc_id
        public_subnet_id = module.VPC.vpc_output.public_subnet.*.id
        private_subnet_id = module.VPC.vpc_output.private_subnet.*.id
        vpc_azs_sum = module.VPC.vpc_output.vpc_azs
    }
}