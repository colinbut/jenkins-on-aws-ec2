terraform {
    required_version = ">= 0.12.4"
}

provider "aws" {
    region = "eu-west-2"
}

data "aws_security_group" "WebDMZ" {
    filter {
        name = "group-name"
        values = ["WebDMZ"]
    }
}

resource "aws_instance" "jenkins_master" {
    ami                         = "ami-0089b31e09ac3fffc" # Amaxon Linux 2 AMI from eu-west-2 region
    count                       = 1
    instance_type               = var.instance_type
    key_name                    = var.key_pair
    associate_public_ip_address = true
    iam_instance_profile        = aws_iam_instance_profile.ec2_ecr_instance_profile.name
    vpc_security_group_ids      = [data.aws_security_group.WebDMZ.id] # ensure this Security Group has port 9091 opened
    user_data                   = templatefile("${path.cwd}/master-bootstrap.tmpl", {})

    tags = {
        Name            = "Jenkins-Master"
        ProvisionedBy   = "Terraform"
    }
}


resource "aws_instance" "jenkins_slave" {
    ami                         = "ami-0089b31e09ac3fffc" # Amaxon Linux 2 AMI from eu-west-2 region
    count                       = 2
    instance_type               = var.instance_type
    key_name                    = var.key_pair
    associate_public_ip_address = true
    iam_instance_profile        = aws_iam_instance_profile.ec2_ecr_instance_profile.name
    vpc_security_group_ids      = [data.aws_security_group.WebDMZ.id] # ensure this Security Group has port 9091 opened
    user_data                   = templatefile("${path.cwd}/slave-bootstrap.tmpl", {})

    tags = {
        Name            = "Jenkins-Slave"
        ProvisionedBy   = "Terraform"
    }
}