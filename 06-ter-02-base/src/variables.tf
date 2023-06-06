###cloud vars
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
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}
#========================================

###image&platform
variable "vm_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

#=========================================

###instance resources vars
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "yandex_compute_instance_name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "yandex_compute_instance_platform_id"
}

variable "vm_web_resources" {
  type = map
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "scheduling_policy"
}

#network_interface 
variable "vm_web_network_interface_nat" {
  type        = bool
  default     = true
  description = "network_interface_nat"
}

#=============================================

#metadata
variable "vm_metadata" {
  type = map(object({
    serial-port-enable = number
    ssh-keys           = any
  }))
  default = {
    "metadata" = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:<ssh-key from machine>"
    }
  }
}

#name for interpolation in local.tf

variable "domen" {
  type        = string
  default     = "netology-develop"
  description = "for local var"
}

variable "place" {
  type        = string
  default     = "platform"
  description = "for local var"
}
