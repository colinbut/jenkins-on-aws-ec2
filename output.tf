output "master_public_ip_address" {
    value = aws_instance.jenkins_master[0].public_ip
}

output "slave1_public_ip_address" {
    value = aws_instance.jenkins_slave[0].public_ip
}

output "slave2_public_ip_address" {
    value = aws_instance.jenkins_slave[1].public_ip
}

output "master_public_url" {
    value = aws_instance.jenkins_master[0].public_dns
}

output "slave1_public_url" {
    value = aws_instance.jenkins_slave[0].public_dns
}

output "slave2_public_url" {
    value = aws_instance.jenkins_slave[1].public_dns
}