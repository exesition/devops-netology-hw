# Network

resource "yandex_vpc_network" "network" {
  name = var.network_name
}
resource "yandex_vpc_route_table" "route_instance_nat" {
  name       = "route_instance_nat"
  network_id = yandex_vpc_network.network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.ip_a_vm_nat
  }
}
resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_name_1
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.subnet_cidr_1
}
resource "yandex_vpc_subnet" "private" {
  name           = var.subnet_name_2
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.subnet_cidr_2
  route_table_id = yandex_vpc_route_table.route_instance_nat.id
}