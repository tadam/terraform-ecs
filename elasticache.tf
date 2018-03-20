variable "ec_number_cache_clusters" {}
variable "ec_node_type" {}
variable "ec_engine_version" {}
variable "ec_parameter_group_name" {}
variable "ec_port" {}


resource "aws_elasticache_subnet_group" "ec_subnet" {
  name = "${var.environment}-ec-subnet"
  description = "Private subnet for ElastiCache instances used in ${var.environment}"
  subnet_ids = ["${module.ecs.private_subnet_ids}"]
}

resource "aws_security_group" "ec" {
  name        = "${var.environment}-ec-sg"
  description = "Used in ${var.environment}"
  vpc_id      = "${module.ecs.vpc_id}"
}

resource "aws_security_group_rule" "ecs_to_ec" {
  type = "ingress"
  from_port = "${var.ec_port}"
  to_port = "${var.ec_port}"
  protocol = "TCP"
  source_security_group_id = "${module.ecs.ecs_instance_security_group_id}"
  security_group_id = "${aws_security_group.ec.id}"
}

resource "aws_elasticache_replication_group" "ec_redis" {
  replication_group_id = "${var.environment}-ec-redis"
  replication_group_description = "Used in ${var.environment}"
  number_cache_clusters = "${var.ec_number_cache_clusters}"
  node_type = "${var.ec_node_type}"

  # Automatic failover is not supported for T1 and T2 cache node types
  automatic_failover_enabled = false

  auto_minor_version_upgrade = false
  availability_zones = "${var.availability_zones}"
  engine = "redis"
  engine_version = "${var.ec_engine_version}"
  parameter_group_name = "${var.ec_parameter_group_name}"
  port = "${var.ec_port}"
  subnet_group_name = "${aws_elasticache_subnet_group.ec_subnet.name}"
  security_group_ids = ["${aws_security_group.ec.id}"]
  apply_immediately = true
}

output "ec_redis_id" {
  value = "${aws_elasticache_replication_group.ec_redis.id}"
}

# output "ec_redis_configuration_endpoint_address" {
#   value = "${aws_elasticache_replication_group.ec_redis.configuration_endpoint_address}"
# }

output "ec_redis_primary_endpoint_address" {
  value = "${aws_elasticache_replication_group.ec_redis.primary_endpoint_address}"
}
