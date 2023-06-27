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
  description = "VPC network&subnet name"
}

variable "vm_web_resources" {
  type = map(any)
  default = {
    core          = 2
    ram           = 1
    core_fraction = 5
  }

}
variable "vm_web_name" {
  type        = string
  default     = "web"
  description = "platform name"
}
variable "vm_web_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "image os"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform id"
}

variable "properties" {
  type = list(object(
    {
      name          = string
      cpu           = number
      ram           = number
      size          = number
      core_fraction = number
  }))
  default = [
    {
      name          = "main"
      cpu           = 2
      ram           = 2
      size          = 5
      core_fraction = 20
    },
    {
      name          = "replica"
      cpu           = 4
      ram           = 4
      size          = 10
      core_fraction = 5
    }
  ]
}
