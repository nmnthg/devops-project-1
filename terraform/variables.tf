variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "Name_prefix" {
  type    = string
  default = "mydevopsproj1"
}

# Network
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/24"
}
variable "public_subnet_cidr1" {
  type    = string
  default = "10.0.0.0/28"
}
variable "public_subnet_cidr2" {
  type    = string
  default = "10.0.0.16/28"
}
variable "private_subnet_cidr1" {
  type    = string
  default = "10.0.0.32/28"
}
variable "private_subnet_cidr2" {
  type    = string
  default = "10.0.0.48/28"
}

#ECS
variable "image_uri" {
  description = "Docker image URI for the ECS task"
  type        = string
  default     = "571600847121.dkr.ecr.us-east-1.amazonaws.com/devops-project-1"
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

variable "container_port" {
  type    = number
  default = 3000
}