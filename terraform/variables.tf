variable "jenkins_key_name" {
  description = "EC2 key pair for Jenkins instance"
  type        = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Changed from single CIDR to a list of two subnets
variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs in different AZs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
  default = "t3.micro"
}

variable "eks_cluster_name" {
  default = "my-java-app-eks"
}
