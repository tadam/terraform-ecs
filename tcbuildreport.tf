resource "aws_ecs_task_definition" "tcbuildreport-backend" {
  family = "tcbuildreport-backend"
  container_definitions = "${file("td-tcbuildreport-backend.json")}"
}
