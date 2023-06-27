resource "local_file" "hosts" {
  depends_on = [resource.yandex_compute_instance.count, resource.yandex_compute_instance.loop, resource.yandex_compute_instance.storage]
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.count
      databases  = yandex_compute_instance.loop
      storage    = [yandex_compute_instance.storage]
    }
  )
  filename = "${abspath(path.module)}/hosts.ini"
}
