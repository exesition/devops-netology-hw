
# YC

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}
variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

# YC zones

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "default_region" {
  type        = string
  default     = "ru-central1"
}
variable "vms_zone" {
  type        = string
  default     = "standard-v1"
}

# VPC

variable "network_name" {
  type = string
  default = "network"
}
variable "subnet_cidr_1" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "subnet cidr one"
}
variable "subnet_name_1" {
  type        = string
  default     = "public"
  description = "subnet one"
}

# VM Images

variable "family_vm_ig" {
  type        = string
  default     = "lemp"
  description = "yandex_compute_image_family_ig"
}

# VM

variable "vms" {
  type = list(object({ 
    name = string,
    platform_id = string, 
    cpu        = number, 
    ram        = number, 
    disk       = number,
    cf         = number
    }))
  default = [ 
    {
    name = "ig-1"
    platform_id = "standard-v1"
    cpu = 2
    ram = 2
    disk = 10
    cf = 5
    }
  ]
  description = "vms resources"
}