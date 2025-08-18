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

variable "container_port" {
  type    = number
  default = 3000
}
variable "desired_count" {
  type    = number
  default = 2
}
variable "task_cpu" {
  description = "Fargate CPU (valid: 256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 512
}
variable "task_memory" {
  description = "Fargate Memory in MiB (valid pairs with CPU, e.g. 1024 for 512 CPU)"
  type        = number
  default     = 1024
}