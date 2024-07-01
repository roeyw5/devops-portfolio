variable "region" {
  type = string
}
variable "account_id" {
  type      = string
  sensitive = true
}
variable "project_name" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "key_pair_name" {
  type      = string
  sensitive = true
}
variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "cluster_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "ami_id" {
  type      = string
  sensitive = true
}
variable "disk_size" {
  type = number
}
variable "capacity_type" {
  type = string
}
variable "scaling_desired" {
  type = number
}
variable "scaling_min" {
  type = number
}
variable "scaling_max" {
  type = number
}
variable "max_unavailable" {
  type = number
}








