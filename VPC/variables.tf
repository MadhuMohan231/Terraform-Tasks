variable "vpc_cidr" {
    type = string
    description = "VPC CIDR value"
}

variable "sub_value" {
  type = bool
  description = "Determines whether the resources should be created"
}

variable "pub_sub_cidr" {
    type = list(string)
    description = "Public-Subnet CIDR value"
}

variable "pri_sub_cidr" {
    type = list(string)
    description = "Private-Subnet CIDR values"
}