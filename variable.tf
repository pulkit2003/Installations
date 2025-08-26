variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1" # Mumbai
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH (use your IP/32 ideally)"
  type        = string
  default     = "0.0.0.0/0" # demo-friendly; lock down later
}

variable "project_tag" {
  description = "Common project tag"
  type        = string
  default     = "addressbook-cicd"
}
