# terraform/modules/eks-cluster/variables.tf

variable "cluster_name" {
  description = "arkoifa"
  type        = string
}

variable "vpc_id" {
  description = "El ID de la VPC donde se desplegará el clúster."
  type        = string
}

variable "subnet_ids" {
  description = "Una lista de IDs de subredes para los nodos del clúster."
  type        = list(string)
}

variable "instance_types" {
  description = "Una lista de tipos de instancias para los nodos worker."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "El número deseado de nodos worker."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "El número máximo de nodos worker."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "El número mínimo de nodos worker."
  type        = number
  default     = 1
}