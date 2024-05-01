
# Instance VM

resource "yandex_compute_instance" "vms" {
  for_each    = { for key, value in var.vms : key => value }
  name        = each.value.name
  platform_id = each.value.platform_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.cf
  }

  boot_disk {
    initialize_params {
      image_id = each.value.name == "vmnat" ? "${data.yandex_compute_image.nat-instance.image_id}" : "${data.yandex_compute_image.ubuntu.image_id}"
      size     = each.value.disk
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id  = each.value.name == "vmprivate" ? "${yandex_vpc_subnet.private.id}" : "${yandex_vpc_subnet.public.id}"
    nat        = each.value.name == "vmprivate" ? false : true
    ip_address = each.value.name == "vmnat" ? "${var.ip_a_vm_nat}" : null
  }

  metadata = local.metadata
}

data "yandex_compute_image" "ubuntu" {
  family = var.family_vm
}
data "yandex_compute_image" "nat-instance" {
  family = var.family_vm_nat
}
data "template_file" "cloudinit" {
  template = file("./security.yml")
  vars = {
    ssh_public_key = file("~/.ssh/id_ed25519.pub")
  }
}
