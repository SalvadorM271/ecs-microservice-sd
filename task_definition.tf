// client task definition

resource "aws_ecs_task_definition" "client" {
  family                   = "${var.name}-client-task-${var.environment}" //task name
  network_mode             = "awsvpc" // the only network mode that works with fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn // special rol for using ecs
  container_definitions = jsonencode([{
    name        = "${var.name}-client-task-${var.environment}"
    image       = var.client_container_image
    // this determines wheather on not it would be restore on crash
    essential   = true
    // env variables that can be pass to the container
    environment = [{"name": "ENVIRONMENT", "value": "${var.environment}"}] //this envs will be pass to the container to select deploy enviroment
    // only client would need port mapping on this use case, since only client is connected to alb
    portMappings = [{
      protocol      = "tcp"
      containerPort = tonumber(var.client_container_port) //--------------------- only one uses this
      hostPort      = tonumber(var.client_container_host_port)
    }]
    logConfiguration = {
      logDriver = var.client_log_driver
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main_lgr.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

// hello microservice task definition

resource "aws_ecs_task_definition" "hello" {
  family                   = "${var.name}-hello-task-${var.environment}" //task name
  network_mode             = "awsvpc" // the only network mode that works with fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn // special rol for using ecs
  container_definitions = jsonencode([{
    name        = "${var.name}-hello-task-${var.environment}"
    image       = var.hello_container_image
    // this determines wheather on not it would be restore on crash
    essential   = true
    // env variables that can be pass to the container
    environment = [{"name": "ENVIRONMENT", "value": "${var.environment}"}] //this envs will be pass to the container to select deploy enviroment
    // no port needed since it connects to the client trouhg internal network
    logConfiguration = {
      logDriver = var.hello_log_driver
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main_lgr.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}


// world microservice task definition

resource "aws_ecs_task_definition" "world" {
  family                   = "${var.name}-world-task-${var.environment}" //task name
  network_mode             = "awsvpc" // the only network mode that works with fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn // special rol for using ecs
  container_definitions = jsonencode([{
    name        = "${var.name}-world-task-${var.environment}"
    image       = var.world_container_image
    // this determines wheather on not it would be restore on crash
    essential   = true
    // env variables that can be pass to the container
    environment = [{"name": "ENVIRONMENT", "value": "${var.environment}"}] //this envs will be pass to the container to select deploy enviroment
    // no port needed since it connects to the client trouhg internal network
    logConfiguration = {
      logDriver = var.world_log_driver
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main_lgr.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_iam_role.ecs_task_execution_role]
}

