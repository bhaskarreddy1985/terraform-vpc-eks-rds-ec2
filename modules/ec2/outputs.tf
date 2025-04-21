output "instance_id" {
  value = aws_instance.ec2_instance.id
}

output "instance_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "ec2_key_pair_name" {
  value = aws_key_pair.ec2_key_pair.key_name
}

output "ec2_private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}