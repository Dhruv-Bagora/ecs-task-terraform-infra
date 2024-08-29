# ecs_service.tf
resource "aws_ecs_task_definition" "sample" {
  family                   = "sample-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  execution_role_arn = "arn:aws:iam::194722397683:role/execute-ecs-task"

  container_definitions = jsonencode([
    {
      name      = "sample-container"
      image     = "${image_scanned}"
      cpu       = 1
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
        }
      ]
      repositoryCredentials = {
            credentialsParameter = "arn:aws:secretsmanager:ap-south-1:194722397683:secret:docker-hub-credentials-XK6dpC" 
    }
    }
  ])
}

resource "aws_ecs_service" "sample" {
  name            = "sample-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sample.arn
  desired_count   = 1
  launch_type     = "EC2"

  network_configuration {
    subnets          = [aws_subnet.public1.id,aws_subnet.public2.id]
    security_groups   = [aws_security_group.ecs_service.id]
  }
}
