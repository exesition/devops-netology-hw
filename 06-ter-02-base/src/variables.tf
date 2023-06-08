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

variable "vm_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

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
  type = map(number)
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

variable "vm_web_network_interface_nat" {
  type        = bool
  default     = true
  description = "network_interface_nat"
}

variable "vm_metadata" {
  type = object({
    serial-port-enable = number
    ssh-keys           = string
  })
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+NIpEX7M1OBxjRk9MKiwuSOc+1P2lfMvojrZ7MZSyh root@exe-ubuntu"
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
