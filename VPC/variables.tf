variable "vpc_cidr" {
    type = string
    description = "VPC CIDR value"
}

variable "pub_sub_cidr" {
    type = string
    description = "Public-Subnet CIDR value"
    default = ""
}

variable "pri_sub_cidr" {
    type = string
    description = "Private-Subnet CIDR values"
    default = ""
}