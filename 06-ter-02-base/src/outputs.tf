output "instance_ips" {
  value = map({
    "${yandex_compute_instance.platform.name}" = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    "${yandex_compute_instance.vm_db.name}"    = yandex_compute_instance.vm_db.network_interface.0.nat_ip_address
    }
  )
}
