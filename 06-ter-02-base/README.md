# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

### Цель задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чеклист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex Cli.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
2. Запросите preview доступ к данному функционалу в ЛК Yandex Cloud. Обычно его выдают в течении 24-х часов.
https://console.cloud.yandex.ru/folders/<ваш cloud_id>/vpc/security-groups.   
Этот функционал понадобится к следующей лекции. 
---

**Ответ:**<br>
Доступ выдан 


### Задание 1

1. Изучите проект. В файле variables.tf объявлены переменные для yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?
5. Ответьте, как в процессе обучения могут пригодиться параметры```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ? Ответ в документации Yandex cloud.

В качестве решения приложите:
- скриншот ЛК Yandex Cloud с созданной ВМ,
- скриншот успешного подключения к консоли ВМ через ssh,
- ответы на вопросы.

---

**Ответ:**<br>
4. Инициализируйте проект, выполните код. Исправьте возникшую ошибку. Ответьте в чем заключается ее суть?

```bash
│ Error: Error while requesting API to create instance: server-request-id = bcbbaf13-7103-4adb-a0f6-2657bc7657db server-trace-id = d10a13a4689ce899:503014500c1aba3b:d10a13a4689ce899:1 client-request-id = 14d034fa-25e0-4fdf-b240-8b376f871c36 client-trace-id = 47dfe7c4-1e22-4753-967b-45c74496be78 rpc error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4
│ 
│   with yandex_compute_instance.platform,
│   on main.tf line 15, in resource "yandex_compute_instance" "platform":
│   15: resource "yandex_compute_instance" "platform" {
```
Исходя из текста ошибки в параметрах `cores` должно быть указано четное колиество ядер `2 или 4`, а у нас стоит `1` 
[**Оф. документация**](https://cloud.yandex.ru/docs/compute/concepts/performance-levels)

5. Ответьте, как в процессе обучения могут пригодиться параметры```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ? Ответ в документации Yandex cloud.

>Параметр `"preemptible = true"` означает, что создаваемая ВМ будет временной и может быть прервана в любой момент без предупреждения, если у провайдера >облачных услуг возникнут проблемы с ресурсами. Такие ВМ обычно стоят дешевле, но не гарантируют стабильности работы.
>
>Параметр `"core_fraction=5"` указывает на то, что ВМ будет использовать только 5% от доступных ей вычислительных ресурсов. Это может быть полезно для >экономии денег, если приложение не требует большой мощности. Однако, если приложение потребует больше ресурсов, то такая ВМ может стать узким местом и >замедлить работу системы.
>
>Оба параметра могут быть полезны для экономии денег, но необходимо тщательно оценить потребности приложения и выбрать соответствующие параметры для ВМ.

<details> <summary>Скриншот подключения в ВМ</summary>

<p align="center"> 
<img src="./screenshot/01_04_vm.png">
</p>
</details>

### Задание 2

1. Изучите файлы проекта.
2. Замените все "хардкод" **значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan (изменений быть не должно). 

---

**Ответ:**<br>

<p align="center"> 
<img src="./screenshot/02_variable_web.png">
</p>

<details> <summary>Детали</summary>

variables.tf
```yaml
#=========================================

###image&platform
variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

#=========================================

###instance resources vars
variable "vm_web_name" {
  type = string
  default = "netology-develop-platform-web"
  description = "yandex_compute_instance_name"
}

variable "vm_web_platform_id" {
  type = string
  default = "standard-v1"
  description = "yandex_compute_instance_platform_id"
}

variable "vm_web_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_web_preemptible" {
  type = bool
  default = true
  description = "scheduling_policy"
}

#network_interface 
variable "vm_web_network_interface_nat" {
  type        = bool
  default     = true
  description = "network_interface_nat"
}
```


main.tf

```yaml
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = "var.vm_image_family"
}

resource "yandex_compute_instance" "platform" {
  name        = "var.vm_web_name"
  platform_id = "var.vm_web_platform_id"
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_network_interface_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
```
</details>



### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ(в файле main.tf): **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом **vm_db_** в том же файле('vms_platform.tf').
3. Примените изменения.

---

**Ответ:**<br>
При первом чтение не совсем была понятная формулировка. В результате чего помимо переменных в файл попал и блок `resources`. Потом понял что это как раз пример bad practice и исправился раскидав данные с описанием ВМ в `main.tf`

<details> <summary>Детали</summary>

vms_platform.tf
```yaml
##=========================================

###image&platform
variable "vm_db_image" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex_compute_image"
}

#=========================================

###instance resources vars
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "yandex_compute_instance_name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "yandex_compute_instance_platform_id"
}

variable "vm_db_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "scheduling_policy"
}

#network_interface 
variable "vm_db_network_interface_nat" {
  type        = bool
  default     = true
  description = "network_interface_nat"
}

```


main.tf

```yaml
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = "var.vm_image_family"
}

resource "yandex_compute_instance" "platform" {
  name        = "var.vm_web_name"
  platform_id = "var.vm_web_platform_id"
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_network_interface_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}

resource "yandex_compute_instance" "vm_db" {
  name        = local.db_vm_name
  platform_id = var.vm_db_platform_id

  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_db_network_interface_nat
  }
   metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
```
</details>


### Задание 4

1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
2. Примените изменения.

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```

---

**Ответ:**<br>

<p align="center"> 
<img src="./screenshot/04_outputtf.png">
</p>

<details> <summary>Детали</summary>

Добавил следующий код в `outputs.tf`

```yaml
output "instance_ips" {
  value = map{
    "${yandex_compute_instance.platform.name}" = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    "${yandex_compute_instance.vm_db.name}"    = yandex_compute_instance.vm_db.network_interface.0.nat_ip_address
    }
}
```
При первом запуске отработало. Дальше заметил, что появилась ошибка в VScode. Начал дебужить предложило добавить скобки и привести к виду:
```yaml
output "instance_ips" {
  value = map({
    "${yandex_compute_instance.platform.name}" = yandex_compute_instance.platform.network_interface.0.nat_ip_address
    "${yandex_compute_instance.vm_db.name}"    = yandex_compute_instance.vm_db.network_interface.0.nat_ip_address
    }
  )
}
```
После чего. Позже когда добрался до 7-го задания и запустил `terraform.console` выскочила ошибка:

```bash
Error: Error in function call
│ 
│   on outputs.tf line 2, in output "instance_ips":
│    2:   value = map({
│    3:     "${yandex_compute_instance.platform.name}" = yandex_compute_instance.platform.network_interface.0.nat_ip_address
│    4:     "${yandex_compute_instance.vm_db.name}"    = yandex_compute_instance.vm_db.network_interface.0.nat_ip_address
│    5:     }
│    6:   )
│     ├────────────────
│     │ while calling map(vals...)
│     │ yandex_compute_instance.platform.name is "netology-develop-platform-web"
│     │ yandex_compute_instance.platform.network_interface[0].nat_ip_address is "158.160.108.81"
│     │ yandex_compute_instance.vm_db.name is "netology-develop-platform-db"
│     │ yandex_compute_instance.vm_db.network_interface[0].nat_ip_address is "51.250.65.209"
│ 
│ Call to function "map" failed: the "map" function was deprecated in Terraform v0.12 and is no longer available; use tomap({ ... }) syntax to write a literal map.
╵
```
По всей видимости измененный вариант был бы в таком случае таким:
```yaml
output "vm_external_ip_address" {
 value = tomap({
   "yandex_compute_instance.platform" = yandex_compute_instance.platform.network_interface.0.nat_ip_address,
    "yandex_compute_instance.vm_db" = yandex_compute_instance.vm_db.network_interface.0.nat_ip_address
     }
   )
 }
 ```


</details>

### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.

---

**Ответ:**<br>

<p align="center"> 
<img src="./screenshot/05_local_var.png">
</p>

<details> <summary>Детали</summary>

Для того чтобы поиграться с интерполяцией пришлось разбивать первоначальное имя на 2 переменных. Читал что подобные штуки можно делать через `split()`
Добавил следующий код в `variables.tf`

```yaml
#name for interpolation in local.tf

variable "domen" {
  type        = string
  default     = "netology-develop"
  description = "for local var"
}

variable "place" {
  type        = string
  default     = "platform"
  description = "for local var"
}
```

Добавил следующий код в `locals.tf`
```yaml
locals {
  web_vm_name = "${var.domen}-${var.place}-web"
  db_vm_name  = "${var.domen}-${var.place}-db"
}
```

</details>

### Задание 6

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".
2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).

---

**Ответ:**<br>

<p align="center"> 
<img src="./screenshot/06_plan.png">
</p>

[**Файлы проекта src/**](https://github.com/exesition/devops-netology-hw/tree/main/06-ter-02-base/src)

<details> <summary>Детали</summary>

1. Вместо использования 3-х переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедените их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources".

```yaml
#name for interpolation in variable.tf

variable "vm_web_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}
```
```yaml
variable "vm_db_resources" {
  type = map(any)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}
```

2. Так же поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.

Очень долго не понимал, как это сделать из за ошибки на переменную. Не знаю на сколько это правильно, но кроме прямой вставки ssh ключа других варинтов я не придумал.

Добавил следующий код в `variables.tf`
```yaml
#metadata
variable "vm_metadata" {
  type = map(object({
    serial-port-enable = number
    ssh-keys           = any
  }))
  default = {
    "metadata" = {
      serial-port-enable = 1
      ssh-keys           = "ubuntu:<ssh-key from machine>"
    }
  }
}
```
...далее в `main.tf` для каждого блока `resources` прописываем

```yaml
...
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_db_network_interface_nat
  }

  metadata = var.vm_metadata.metadata

}

```
</details>

------

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   
Их выполнение поможет глубже разобраться в материале. Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 7*

Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания: 

1. Напишите, какой командой можно отобразить **второй** элемент списка test_list?
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map ?
4. Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

В качестве решения предоставьте необходимые команды и их вывод.

**Ответ:**<br>
Можно было бы отдельно задать переменные, но через `local.` проще и быстрее выйдет и тоже самое
<p align="center"> 
<img src="./screenshot/07_external_work.png">
</p>


------
### Правила приема работы

В git-репозитории, в котором было выполнено задание к занятию "Введение в Terraform", создайте новую ветку terraform-02, закомитьте в эту ветку свой финальный код проекта. Ответы на задания и необходимые скриншоты оформите в md-файле в ветке terraform-02.

В качестве результата прикрепите ссылку на ветку terraform-02 в вашем репозитории.

**ВАЖНО! Удалите все созданные ресурсы**.


### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки. 
