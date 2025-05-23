terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  owner = var.github_org_name
  token = var.github_token
}
# Create GitHub connection for App Runner
resource "aws_apprunner_connection" "github_connection" {
  connection_name = "new-connection"
  provider_type   = "GITHUB"
  
  tags = {
    Project     = var.customer_name
    Environment = "production"
  }
}


resource "github_repository_webhook" "apprunner_webhook" {

  repository = var.github_repo_name
  configuration {
    url          = "https://api.apprunner.${var.aws_region}.amazonaws.com"
    content_type = "json"
    insecure_ssl = false
  }
  active = true
  events = ["push"]
}

resource "aws_apprunner_service" "backend_service" {
  service_name = "${var.customer_name}-backend-service"

  source_configuration {
    authentication_configuration {
      connection_arn = aws_apprunner_connection.github_connection.arn
    }

    auto_deployments_enabled = true

    code_repository {
      repository_url = "https://github.com/${var.github_org_name}/${var.github_repo_name}.git"
      source_code_version {
        type  = "BRANCH"
        value = var.github_branch
      }

      code_configuration {
        configuration_source = "API"
        code_configuration_values {
          runtime      = "NODEJS_18"
          build_command = "npm install --production"
          start_command = "node server.js"
          port         = 8080
        }
      }
    }
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  tags = {
    Environment = "production"
    App         = "backend"
    Customer    = var.customer_name
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }

  depends_on = [github_repository_webhook.apprunner_webhook]
}

output "apprunner_service_url" {
  value = aws_apprunner_service.backend_service.service_url
}

output "github_connection_arn" {
  value = aws_apprunner_connection.github_connection.arn
}
