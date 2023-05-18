# Домашнее задание к занятию 4. «Оркестрация группой Docker-контейнеров на примере Docker Compose»

## Как сдавать задания

Обязательны к выполнению задачи без звёздочки. Их нужно выполнить, чтобы получить зачёт и диплом о профессиональной переподготовке.

Задачи со звёздочкой (*) — это дополнительные задачи и/или задачи повышенной сложности. Их выполнять не обязательно, но они помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в GitHub-репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---


## Важно

Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.

Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md).

---

## Задача 1

Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer ([инструкция](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-quickstart)).

Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.

---

**Ответ:**<br>


<p align="center">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/1_packer.png">
</p>

<details>
<summary>Детали</summary>

<br>
Устанавливаем yc <br>

>curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
>yc init

```bash
Welcome! This command will take you through the configuration process.
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=<token_hide> in order to obtain OAuth token.

Please enter OAuth token: <token hide>
You have one cloud available: 'cloud-exesition' (id = <hide_id). It is going to be used by default.
Please choose folder to use:
 [1] default (id = ,hide_id>)
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'default' (id = <hide_id>).
Do you want to configure a default Compute zone? [Y/n] Y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.

root@exe-ubuntu:~/yandex-cloud# yc vpc network create --name net --labels my-label=netology --description "my network"
id: <token hide>
folder_id: <folder_id>
created_at: "2023-05-17T11:44:55Z"
name: net
description: my network
labels:
  my-label: netology

root@exe-ubuntu:~/yandex-cloud# yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "My subnet"
id: <id>
folder_id: <folder_id>
created_at: "2023-05-17T11:48:56Z"
name: my-subnet-a
description: My subnet
network_id: <network_id>
zone_id: ru-central1-a
v4_cidr_blocks:
  - 10.1.2.0/24
```

Packer config:
```yaml
    "builders": [
      {
        "type": "yandex",
        "token": "<Oauthtoken here>",
        "folder_id": "<folder_id>",
        "zone": "ru-central1-a",
        "image_name": "centos-7-base",
        "image_family": "centos-base",
        "image_description": "create by Packer",
        "source_image_family": "centos-7",
        "subnet_id": "<id>",
        "use_ipv4_nat": true,
        "disk_type": "network-ssd",
        "ssh_username": "<username>"
      }
    ]
}
```
Проверяем конфиг для Packer и натыкаемся на ошибку:
```bash
root@exe-ubuntu:/prom# packer validate /prom/centos8.json 
Failed to initialize build 'yandex': builder type not found: yandex
```

Оказалось, что стояла старая версия Packer. ОБновил с зеркала я.облака
```bash
root@exe-ubuntu:/prom# packer version
Packer v1.8.7

root@exe-ubuntu:/prom# packer validate /prom/centos8.json 
The configuration is valid.

root@exe-ubuntu:/prom# packer build /prom/centos8.json
yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Error getting source image for instance creation: client-request-id = 0185f18b-e277-4a48-8894-e64aeda162b5 client-trace-id = 735dc011-ccdb-4f15-87ee-eb73f101037b rpc error: code = Unauthenticated desc = iam token create failed: failed to get compute instance service account token from instance metadata service: GET http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token: Get "http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token": dial tcp 169.254.169.254:80: i/o timeout.
```

Ошибка из за отсутствия токена сервисной учетки. 
Через веб консоль была создана сервисная учетка и выгружен ключ в json формате: 

```bash
root@exe-ubuntu:/prom# yc iam service-account list 
+----------------------+----------------+
|          ID          |      NAME      |
+----------------------+----------------+
| <id_here>            | myrobotservice |
+----------------------+----------------+
root@exe-ubuntu:/prom# yc iam key list 
+----------------------+-------------------------------------+-----------+---------------------+
|          ID          |               SUBJECT               | ALGORITHM |     CREATED AT      |
+----------------------+-------------------------------------+-----------+---------------------+
| <id>                 | serviceAccount:<id>                 | RSA_2048  | 2023-05-17 13:00:40 |
+----------------------+-------------------------------------+-----------+---------------------+
```
и на всякий ssh ключ:

>ssh-keygen -t ed25519

P.S
Дальше была ошибка с подключением из за того что в json Packer-a не было установлено поле:

>"token": "<Oauthtoken here>",

</details>


## Задача 2

**2.1.** Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.        

**2.2.*** **(Необязательное задание)**      
Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform (вместо использования веб-интерфейса YandexCloud).
Используйте Terraform-код в директории ([src/terraform](https://github.com/netology-group/virt-homeworks/tree/virt-11/05-virt-04-docker-compose/src/terraform)).

Чтобы получить зачёт, вам нужно предоставить вывод команды terraform apply и страницы свойств, созданной ВМ из личного кабинета YandexCloud.

---

**Ответ:**<br>
ВМ созданная из Web интерфейса YC
<p align="center">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/2_create_image_web.PNG">
</p>

ВМ созданная средствами Terraform
<p align="center">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/2_vm_terraform_created.png">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/2_VMimage_propertis.png">
</p>

<details>
<summary>Детали</summary>

Terraform был установлен ранее. Инициализируем:

```bash
root@exe-ubuntu:/prom# terraform init
╷
 Warning: Incomplete lock file information for providers
 
 Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the following
 providers:
   - yandex-cloud/yandex
 
 The current .terraform.lock.hcl file only includes checksums for linux_amd64, so Terraform running on another platform will fail to
 install these providers.
 
 To calculate additional checksums for another platform, run:
 terraform providers lock -platform=linux_amd64
 (where linux_amd64 is the platform to generate)


Terraform has been successfully initialized!
...

```

При попытке запустить terraform plan выпадала ошибка. помогло
>terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=linux_amd64 -platform=darwin_arm64 yandex-cloud/yandex

Ключ сервисной учетки был сделан в предыдещем шаге поэтому переходим к командам:
> terraform plan
> terraform apply

```bash
root@exe-ubuntu:/prom# terraform apply
yandex_vpc_network.default: Refreshing state... [id=<>]
yandex_vpc_subnet.default: Refreshing state... [id=<>]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create
  ~ update in-place

Terraform will perform the following actions:

  # yandex_compute_instance.node01 will be created
 
  ... 
  ...

yandex_vpc_subnet.default: Modifying... [id=<hide>]
yandex_vpc_subnet.default: Modifications complete after 1s [id=<hide>]
yandex_compute_instance.node01: Creating...
yandex_compute_instance.node01: Still creating... [10s elapsed]
yandex_compute_instance.node01: Still creating... [20s elapsed]
yandex_compute_instance.node01: Still creating... [30s elapsed]
yandex_compute_instance.node01: Still creating... [40s elapsed]
yandex_compute_instance.node01: Still creating... [50s elapsed]
yandex_compute_instance.node01: Creation complete after 51s [id=<hide>]

Apply complete! Resources: 1 added, 1 changed, 0 destroyed.

Outputs:

external_ip_address_node01_yandex_cloud = "52.250.91.47"
internal_ip_address_node01_yandex_cloud = "192.168.101.20"
```
</details>

## Задача 3

С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana.
Используйте Ansible-код в директории ([src/ansible](https://github.com/netology-group/virt-homeworks/tree/virt-11/05-virt-04-docker-compose/src/ansible)).

Чтобы получить зачёт, вам нужно предоставить вывод команды "docker ps" , все контейнеры, описанные в [docker-compose](https://github.com/netology-group/virt-homeworks/blob/virt-11/05-virt-04-docker-compose/src/ansible/stack/docker-compose.yaml),  должны быть в статусе "Up".

---

**Ответ:**<br> 
<p align="center">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/3_docker_compose_stat.png">
</p>

<details>
<summary>Детали</summary>

Качаем содержимое ([src/ansible](https://github.com/netology-group/virt-homeworks/tree/virt-11/05-virt-04-docker-compose/src/ansible)) на локальную машину
Заходим в ./inventory и меняем ip на внешний от нашей виртуализованной машины

```bash
root@exe-ubuntu:/docker#:~/git/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/ansible(main)$ cat inventory
[nodes:children]
manager

[manager]
node01.netology.cloud ansible_host=51.250.91.47
```
Дальше запускаем docker-compose:
```bash
root@exe-ubuntu:/docker#:~/git/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/ansible(main)$ ansible-playbook provision.yml

PLAY [nodes] *****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [node01.netology.cloud]

TASK [Create directory for ssh-keys] *****************************************************************************************************
ok: [node01.netology.cloud]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] **************************************************************************************
ok: [node01.netology.cloud]

TASK [Checking DNS] **********************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Installing tools] ******************************************************************************************************************
changed: [node01.netology.cloud] => (item=git)
ok: [node01.netology.cloud] => (item=curl)

TASK [Add docker repository] *************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Installing docker package] *********************************************************************************************************
changed: [node01.netology.cloud] => (item=docker-ce)
ok: [node01.netology.cloud] => (item=docker-ce-cli)
ok: [node01.netology.cloud] => (item=containerd.io)

TASK [Enable docker daemon] **************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Install docker-compose] ************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Synchronization] *******************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Pull all images in compose] ********************************************************************************************************
changed: [node01.netology.cloud]

TASK [Up all services in compose] ********************************************************************************************************
changed: [node01.netology.cloud]

PLAY RECAP *******************************************************************************************************************************
node01.netology.cloud      : ok=12   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
</details>



## Задача 4

1. Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.
2. Используйте для авторизации логин и пароль из [.env-file](https://github.com/netology-group/virt-homeworks/blob/virt-11/05-virt-04-docker-compose/src/ansible/stack/.env).
3. Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками([dashboards](https://grafana.com/docs/grafana/latest/dashboards/use-dashboards/)).
4. Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.

Чтобы получить зачёт, предоставьте: 

- скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже.
<p align="center">
  <img width="1200" height="600" src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/yc_02.png">
</p>

---

**Ответ:**<br>

<p align="center">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/4_grafana_web.png">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/4_grafana_web2.png">
</p>

## Задача 5 (*)

Создайте вторую ВМ и подключите её к мониторингу, развёрнутому на первом сервере.

Чтобы получить зачёт, предоставьте:

- скриншот из Grafana, на котором будут отображаться метрики добавленного вами сервера.

---

**Ответ:**<br>
Работу делал с другими ВМ на следующий день. IP поменялись.
<p align="center">
  <img src="https://github.com/exesition/devops-netology-hw/blob/main/05-virt-04-docker-compose/screenshot/5_grafana_web3.png">
</p>

<details>
<summary>Детали</summary>


Поднимаем вторую ВМ в облаке
Далее через `ansible-playbook provision.yml` проливаем машину по следующему алгоритму:


Правим `docker-compose.yaml` на `node02`и делаем проброс порта `9100` в следующей секции конфига:

  ```yaml
  ...
    caddy:
      image: stefanprodan/caddy
      container_name: caddy
      ports:
        ...
        - "0.0.0.0:9100:9100"
  ...
  ```

Правим `Caddyfile` на `node02`, добавляем прокси порта `nodeexporter`
  ```
  ...
  :9100 {
      basicauth / {$ADMIN_USER} {$ADMIN_PASSWORD}
      proxy / nodeexporter:9100 {
              transparent
          }
  
      errors stderr
      tls off
  }
  ...
  ```

В `inventory` коментием первую ноду и прописываем адрес второй ноды для того, чтобы пролить конфиг с изменениями выше:

```yaml
[nodes:children]
manager

[manager]
#node01.netology.cloud ansible_host=<ip1>
node02.netology.cloud ansible_host=<ip2>
```

Далее возвращаем все как было на место чтобы сделать изменения на первой ноде:

```yaml
[nodes:children]
manager

[manager]
node01.netology.cloud ansible_host=<ip1>
#node02.netology.cloud ansible_host=<ip2>
```


Правим `prometheus.yml` на `node01`, добавляем `basic_auth` и добавляем новый `target`

  ```yaml
  scrape_configs:
    - job_name: 'nodeexporter'
      scrape_interval: 5s
      basic_auth:
        username: admin
        password: admin
      static_configs:
        - targets: ['node01:9100']
        - targets: ['node02:9100']
  ```

- Далее в `Grafana` необходми добавить второй `Datasource`и настроить графики по вкусу

</details>
