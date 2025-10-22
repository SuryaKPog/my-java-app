variable "jenkins_key_name" {
  description = "EC2 key pair for Jenkins instance"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs in different AZs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  default     = "t3.micro"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-java-app-eks"
}
