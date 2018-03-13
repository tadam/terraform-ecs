resource "aws_ecs_task_definition" "tcbuildreport-backend" {
  family = "tcbuildreport-backend"
  container_definitions = "${file("td-tcbuildreport-backend.json")}"
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
