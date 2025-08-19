# # ECS Cluster
# resource "aws_ecs_cluster" "main-cluster" {
#   name = "${var.Name_prefix}-ecs"
#   tags = {
#     Name = "${var.Name_prefix}-ecs"
#   }
# }

# # ECS Task definition
# resource "aws_ecs_task_definition" "app" {
#   family                   = "${var.Name_prefix}-taskdef"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "254"
#   memory                   = "512"
#   execution_role_arn       = aws_iam_role.task_execution_role.arn

#   container_definitions = jsonencode([{
#     name      = "app"
#     image     = "${var.image_uri}:${var.image_tag}"
#     essential = true
#     portMappings = [{
#       containerPort = var.container_port
#       hostPort      = var.container_port
#       protocol      = "tcp"
#       appProtocol   = "http"
#     }]
#     environment = []
#     }
#   ])
# }

# # ECS Service
# resource "aws_ecs_service" "app" {
#   name             = "${var.Name_prefix}-svc"
#   cluster          = aws_ecs_cluster.main-cluster.id
#   task_definition  = aws_ecs_task_definition.app.arn
#   desired_count    = 1
#   launch_type      = "FARGATE"
#   platform_version = "1.4.0"

#   network_configuration {
#     subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
#     security_groups  = [aws_security_group.ecs-sg.id]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.lb-tg.arn
#     container_name   = "app"
#     container_port   = var.container_port
#   }

#   depends_on = [aws_lb_listener.http]

#   deployment_controller {
#     type = "ECS"
#   }

#   force_new_deployment = true
#   propagate_tags       = "SERVICE"

#   tags = { Name = "${var.Name_prefix}-svc" }
# }