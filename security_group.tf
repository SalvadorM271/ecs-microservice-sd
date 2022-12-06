// security group for application load balancer

resource "aws_security_group" "alb-sg" {
  name   = "${var.name}-alb-sg-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Environment = var.environment
  }
}

// security group for ECS, allows all traffic within vpc

resource "aws_security_group" "ecs_tasks_sg" {
  name   = "${var.name}-task-sg-${var.environment}"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol         = "-1" // means all traffic
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["10.0.0.0/16"]
    
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  tags = {
    Environment = var.environment
  }
}