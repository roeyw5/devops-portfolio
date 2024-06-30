variable "availability_zones" {
  type = list(string)
}
variable "tags" {
  type = map(string)
}
variable "project_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "cidr_blocks_public_subnet" {
  type = list(string)
}
variable "cidr_blocks_private_subnet" {
  type = list(string)
}
variable "cluster_name" {
  type = string
}
