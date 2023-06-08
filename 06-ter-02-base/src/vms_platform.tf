
variable "vm_db_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "yandex_compute_instance_name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "yandex_compute_instance_platform_id"
}

variable "vm_db_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "scheduling_policy"
}

variable "vm_db_network_interface_nat" {
  type        = bool
  default     = true
  description = "network_interface_nat"
}

variable "vm_db_metadata_serial-port-enable" {
  type        = number
  default     = 1
  description = "compute_instance_metadata_serial-port-enable"
}
