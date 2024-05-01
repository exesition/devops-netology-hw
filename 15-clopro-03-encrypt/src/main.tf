
# VM attach

data "yandex_compute_image" "lemp" {
  family = var.family_vm_ig
}
data "template_file" "cloudinit" {
  template = file("./cc.yml")
  vars = {
    ssh_public_key = file("~/.ssh/id_ed25519.pub")
    /*     add_picture        = <<EOF
                          #!/bin/bash
                          echo '<html><img src="http://${yandex_storage_bucket.pictures-bucket.bucket_domain_name}/bitoc.png"/></html>' > /var/www/index.nginx-debian.html
                          systemct restart nginx
                          EOF */
  }
}
