terraform {
    required_version = ">= 0.12.4"
}

provider "aws" {
    region = "eu-west-2"
}

data "aws_vpc" "default_vpc" {
    default = true
}

resource "aws_instance" "jenkins_master" {
    ami                         = var.ami
    count                       = 1
    instance_type               = var.instance_type
    key_name                    = var.key_pair
    associate_public_ip_address = true
    iam_instance_profile        = aws_iam_instance_profile.ec2_ecr_instance_profile.name
    vpc_security_group_ids      = [aws_security_group.security_group.id]
    user_data                   = templatefile("${path.cwd}/master-bootstrap.tmpl", {})

    tags = {
        Name            = "Jenkins-Master"
        ProvisionedBy   = "Terraform"
    }
}


resource "aws_instance" "jenkins_slave" {
    ami                         = var.ami
    count                       = 2
    instance_type               = var.instance_type
    key_name                    = var.key_pair
    associate_public_ip_address = true
    iam_instance_profile        = aws_iam_instance_profile.ec2_ecr_instance_profile.name
    vpc_security_group_ids      = [aws_security_group.security_group.id]
    user_data                   = templatefile("${path.cwd}/slave-bootstrap.tmpl", {})

    tags = {
        Name            = "Jenkins-Slave"
        ProvisionedBy   = "Terraform"
    }
}

resource "aws_security_group" "security_group" {
    name        = "Jenkins Security Group"
    description = "The SG to assign to the Jenkins instances"
    vpc_id      = data.aws_vpc.default_vpc.id
}

resource "aws_security_group_rule" "allow_ssh" {
    type                = "ingress"
    description         = "allow ssh"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "inbound_traffic" {
    type                = "ingress"
    description         = "allowing inbound access to the app"
    from_port           = 9091
    to_port             = 9091
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.security_group.id
}

resource "aws_security_group_rule" "default_outbound" {
    type                = "egress"
    description         = "default_outbound"
    from_port           = 0
    to_port             = 0
    protocol            = -1
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.security_group.id
}