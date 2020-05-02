data "aws_iam_policy" "amazon_ecr_readonly" {
    arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_instance_profile" "ec2_ecr_instance_profile" {
    name = "jenkins-ec2_ecr_instance_profile"
    role = aws_iam_role.ec2_ecr_role.name
}

resource "aws_iam_role" "ec2_ecr_role" {
    name                = "jenkins_ec2_ecr_role"
    description         = "The role to allow EC2 communicate to ECR"
    assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_policy_attachment" {
    role        = aws_iam_role.ec2_ecr_role.name
    policy_arn  = data.aws_iam_policy.amazon_ecr_readonly.arn
}