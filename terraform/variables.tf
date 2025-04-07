variable "customer_name" {
  type        = string
  description = "Name of the customer/project"
}

variable "github_org_name" {
  type        = string
  description = "GitHub organization name"
}

variable "github_repo_name" {
  type        = string
  description = "GitHub repository name"
}

variable "github_branch" {
  type        = string
  description = "GitHub branch to deploy from"
  default     = "main"
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-1"
}

variable "apprunner_cpu" {
  type        = string
  description = "App Runner CPU allocation"
  default     = "1024"
}

variable "apprunner_memory" {
  type        = string
  description = "App Runner memory allocation"
  default     = "2048"
}
