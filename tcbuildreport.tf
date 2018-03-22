# Didn't find any way to get hostnames of particular Redis instances in Terraform.
# There is a way to get only primary endpoint (points to master only),
# or configuration point in case of Redis cluster (which would be enough if we use
# cluster).
#
# So, below is a stupid hack just to make it work in case of 2 instances.
#
# You can simply put into "redis_nodes" values from AWS Console if you have
# troubles here.
#
locals {
  redis_primary_endpoint = "${aws_elasticache_replication_group.ec_redis.primary_endpoint_address}"
  redis_id = "${aws_elasticache_replication_group.ec_redis.id}"

  # not sure if this part has to be stripped in all cases
  redis_tmp = "${replace(local.redis_primary_endpoint, ".ng.", ".")}"

  redis_prefix1 = "${local.redis_id}-001"
  redis_node1 = "${replace(local.redis_tmp, local.redis_id, local.redis_prefix1)}"

  redis_prefix2 = "${local.redis_id}-002"
  redis_node2 = "${replace(local.redis_tmp, local.redis_id, local.redis_prefix2)}"

  redis_nodes = "redis://${local.redis_node1}:${var.ec_port},redis://${local.redis_node2}:${var.ec_port}"
}

resource "aws_ecs_task_definition" "tcbuildreport-backend" {
  family = "tcbuildreport-backend"
  container_definitions = <<EOF
[
    {
        "name": "tcbuildreport-backend",
        "image": "tudum/tcbuildreport-backend:0.0.4-SNAPSHOT",
        "memory": 500,
        "portMappings": [
            {
                "containerPort": 8080,
                "protocol": "tcp"
            }
        ],
        "environment": [
            {
                "name": "TC_CACHE_REDIS_NODES",
                "value": "${local.redis_nodes}"
            }
        ]
    }
]
  EOF
}

resource "aws_ecs_service" "tcbuildreport-backend" {
  name = "tcbuildreport-backend"
  cluster = "${module.ecs.ecs_cluster_arn}"
  task_definition = "${aws_ecs_task_definition.tcbuildreport-backend.arn}"
  desired_count   = 2
  iam_role = "${module.ecs.ecs_lb_role_arn}"

  load_balancer {
    target_group_arn = "${module.ecs.default_alb_target_group}"
    container_name = "tcbuildreport-backend"
    container_port = 8080
  }
}
