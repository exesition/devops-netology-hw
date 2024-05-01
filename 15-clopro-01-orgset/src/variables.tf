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

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
}
variable "vms_zone" {
  type        = string
  default     = "standard-v1"
}

variable "subnet_cidr_1" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "VPC subnet network one"
}
variable "subnet_cidr_2" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "VPC subnet network two"
}

variable "subnet_name_1" {
  type        = string
  default     = "public"
  description = "VPC network&subnet name one"
}
variable "subnet_name_2" {
  type        = string
  default     = "private"
  description = "VPC network&subnet name two"
}

variable "family_vm" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image_family_vm"
}
variable "family_vm_nat" {
  type        = string
  default     = "nat-instance-ubuntu"
  description = "yandex_compute_image_family_nat"
}

variable "network_name" {
  type = string
  default = "network"
}

variable "ip_a_vm_nat" {
  type = string
  default = "192.168.10.254"
}

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
    name = "vmpublic"
    platform_id = "standard-v1"
    cpu = 2
    ram = 2
    disk = 10
    cf = 5
    },
    {
    name = "vmprivate"
    platform_id = "standard-v1"
    cpu = 2
    ram = 2
    disk = 10
    cf = 5
    },
    {
    name = "vmnat"
    platform_id = "standard-v1"
    cpu = 2
    ram = 4
    disk = 10
    cf = 5
    }
  ]
  description = "vms resources"
}