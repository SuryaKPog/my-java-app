output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_security_group_id" {
  value = aws_security_group.eks_sg.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}
