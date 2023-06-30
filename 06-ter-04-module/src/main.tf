module "vpc" {
  source          = "./vpc"
  vpc_name        = "develop"
  vpc_name_subnet = var.vpc_name
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = module.vpc.vpc_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [module.vpc.subnet_id]
  instance_name  = "web"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  metadata = {
    user-data          = data.template_file.userdata.rendered
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }

}

data "template_file" "userdata" {
  template = file("${path.module}/cloud-init.yml")

  vars = {
    username       = var.username
    ssh_public_key = "${local.ssh_public_key}"
  }
}
