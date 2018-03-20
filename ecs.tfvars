vpc_cidr = "10.0.0.0/16"

environment = "dev"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

region = "eu-west-1"

availability_zones = ["eu-west-1a", "eu-west-1b"]

max_size = 2

min_size = 1

desired_capacity = 2

instance_type = "t2.micro"

ecs_aws_ami = "ami-64c4871d"

public_key_file = "~/.ssh/tcbuildreport-dev.key.pub"

alb_health_check_path = "/api/ping"


ec_number_cache_clusters = 2

ec_node_type = "cache.t2.micro"

ec_engine_version = "3.2.10"

ec_parameter_group_name = "default.redis3.2"

ec_port = 6379

