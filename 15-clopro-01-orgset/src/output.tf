output "vms_external_ip" {
value = tomap({
    vmnat      = "${yandex_compute_instance.vms["2"].network_interface.0.nat_ip_address}"
    vmpublic  = "${yandex_compute_instance.vms["0"].network_interface.0.nat_ip_address}"
    vmprivate  = "${yandex_compute_instance.vms["1"].network_interface.0.ip_address}"
})
}