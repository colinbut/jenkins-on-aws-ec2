variable "region" {
    type        = string
    description = "The region"
}

variable "instance_type" {
    type        = string
    description = "The type of EC2 instance"
}

variable "key_pair" {
    type        = string
    description = "The key pair name to ssh into those EC2 instances"
}

variable "ami" {
    type        = string
    description = "The ami id"
}