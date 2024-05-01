
# Instance group

resource "yandex_compute_instance_group" "ig-1" {
    depends_on = [ yandex_resourcemanager_folder_iam_member.ig-editor ]
    for_each = {for key, value in var.vms: key => value}
    name = each.value.name
    folder_id          = var.folder_id
    service_account_id = yandex_iam_service_account.sa4ig.id

    instance_template {
        platform_id = each.value.platform_id
        resources {
            cores  = each.value.cpu
            memory = each.value.ram
            core_fraction = each.value.cf

        }
        boot_disk {
            initialize_params {
                image_id = data.yandex_compute_image.lemp.image_id
                size = each.value.disk
            }
        }
        network_interface {
            network_id  = yandex_vpc_network.network.id
            subnet_ids  = [ yandex_vpc_subnet.public.id ]
            nat         = true
        }
        scheduling_policy {
            preemptible = true
        }
        metadata = local.metadata
   }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }

    allocation_policy {
        zones = [ var.default_zone ]
    }

    deploy_policy {
        max_unavailable  = 1
        max_creating     = 3
        max_expansion    = 1
        max_deleting     = 1
        startup_duration = 3
    }

     health_check {
        http_options {
            port    = 80
            path    = "/"
        }
    }

    load_balancer {
        target_group_name = "target-group"
    }
}