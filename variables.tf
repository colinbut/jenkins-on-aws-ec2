
variable "instance_type" {
    type = string
    description = "The type of EC2 instance"
}

variable "key_pair" {
    type = string
    description = "The key pair name to ssh into those EC2 instances"
}