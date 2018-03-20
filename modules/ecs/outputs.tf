output "default_alb_target_group" {
  value = "${module.alb.default_alb_target_group}"
}

output "ecs_cluster_arn" {
  value = "${aws_ecs_cluster.cluster.arn}"
}

output "ecs_lb_role_arn" {
  value = "${aws_iam_role.ecs_lb_role.arn}"
}

output "private_subnet_ids" {
  value = "${module.network.private_subnet_ids}"
}

output "ecs_instance_security_group_id" {
  value = "${module.ecs_instances.ecs_instance_security_group_id}"
}

output "vpc_id" {
  value = "${module.network.vpc_id}"
}
