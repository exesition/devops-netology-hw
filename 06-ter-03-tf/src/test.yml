resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",

    {
        webservers   = yandex_compute_instance.web
        databases    = yandex_compute_instance.work2
        storage      = [yandex_compute_instance.storage] 
    } )

  filename = "${abspath(path.module)}/hosts.cfg"
}

resource "null_resource" "web_hosts_provision" {
  depends_on = [yandex_compute_instance.storage]

  provisioner "local-exec" {
    command = "cat ~/.ssh/id_ed25519 | ssh-add -"
  }
  provisioner "local-exec" {
    command = "sleep 30"
  }
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
  triggers = {
    always_run        = "${timestamp()}"
    playbook_src_hash = file("${abspath(path.module)}/test.yml")
    ssh_public_key    = local.ssh_public_key # 
  }

}