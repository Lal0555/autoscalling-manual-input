variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}
