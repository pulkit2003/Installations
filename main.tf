# Get default VPC + subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Ubuntu 22.04 LTS via SSM Public Parameter (region-aware)
data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Security Group: Jenkins Master
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins (8080)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Jenkins UI / GitHub webhook"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open for demo; restrict later or use a reverse proxy
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "jenkins-sg"
    Project = var.project_tag
  }
}

# Security Group: Application Node (Tomcat)
resource "aws_security_group" "app_sg" {
  name        = "app-node-sg"
  description = "Allow SSH and Tomcat (8080)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr] # simple; later restrict to Jenkins SG via SG rule
  }

  ingress {
    description = "Tomcat HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # so you can see the app in a browser
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app-node-sg"
    Project = var.project_tag
  }
}

# Jenkins Master EC2
resource "aws_instance" "jenkins_master" {
  ami                         = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "jenkins-master"
    Role    = "jenkins"
    Project = var.project_tag
  }
}

# Application Node EC2
resource "aws_instance" "app_node" {
  ami                         = data.aws_ssm_parameter.ubuntu_2204.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "app-node"
    Role    = "tomcat-node"
    Project = var.project_tag
  }
}
