provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "linkta_cluster" {
  name = "linkta-cluster"
}

resource "aws_ecs_task_definition" "linkta_task" {
  family                     = "linkta"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    memory                   = "512"
    cpu                      = "256"

  # TODO: replace image with one held by Linkta Docker Hub
  container_definitions = jsonencode([
    {
      name      = "landing-page"
      image     = "errjordan/linkta-lp-infra-fork:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "linkta_service" {
  name            = "linkta-service"
  cluster         = aws_ecs_cluster.linkta_cluster.id
  task_definition = aws_ecs_task_definition.linkta_task.arn
  desired_count   = 1
  launch_type     = "EC2"
}
