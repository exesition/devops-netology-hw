devops-netology
===============

# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Задача 1
---

Опишите своими словами основные преимущества применения на практике IaaC паттернов.

**Ответ:**<br>
>Автоматизация процесса развертывания инфраструктуры и ее управления. Позволяет сэкономить время на подготовку окружения и увеличить эффективность команды разработчиков или кто ведет проект
>Единый подход управления инфрастуктурой облегчает ее масштабирование и целостность
>Повышение надежности и безопасности за счет автоматизации
>Управление инфраструктурой как кодом позволяет упростить совместную работу и в случае сбоев сделать немедленный откат, тем самым сокращая время простоя
>Сокращение затрат на ее управление.


Какой из принципов IaaC является основополагающим?

**Ответ:**<br>
>Основополагающим принципом IaaC является автоматизация процесса развертывания (можно сказать безошибочная) и управления инфраструктурой

## Задача 2
---

Чем Ansible выгодно отличается от других систем управление конфигурациями?

**Ответ:**<br>
> Не требует установки агента на конечные узлы, что упрощает развертывание. Работает по ssh
> Низкий порог вхождения и широкая библиотек модулей для управления различными типами устройств и сервисов
> Поддерживает автоматическое обнаружение изменений в конфигурации и автоматическую коррекцию ошибок
> Обладает высокой скоростью работы благодаря использованию параллельного выполнения задач на нескольких узлах одновременно.

Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

**Ответ:**<br>
> На первый взгляд кажется, что push за счет централизованного подхода сервер -> клиент, но на практике у разработчиков чаще наблюдал метод pull. Аргументировать этот момент не смогу сейчас
> В любом случае так или иначе нужно подстраивать свое решение под конкретные кейсы

## Задача 3
---

 Установить на личный компьютер:
 
> - VirtualBox
> - Vagrant
> - Ansible
 
> *Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

**Ответ:**<br>

Первоначально попробовал на Win10, но не понравилось городить связку WSL+ansible+vagrant. Решение показалось громоздким. Залил на внешний HDD Ubuntu Desktop

* Ubuntu
```shell
vagrant@server1:~$ hostnamectl
   Static hostname: server1
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 088064e872c64b2bbe555ea5f615e9d0
           Boot ID: c063ad9611f1452087c9566e0519bf51
    Virtualization: oracle
  Operating System: Ubuntu 20.04.6 LTS
            Kernel: Linux 5.4.0-144-generic
      Architecture: x86-64
```

* Virtualbox
```shell
root@exe-ubuntu:~/vagrant# vboxmanage --version
6.1.38_Ubuntur153438
```

* Vagrant
```shell
root@exe-ubuntu:~/vagrant# vagrant -v
Vagrant 2.2.6
```

* Ansible
```shell
root@exe-ubuntu:~/vagrant# ansible --version
ansible 2.9.6
  config file = /root/vagrant/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Nov 14 2022, 12:59:47) [GCC 9.4.0]
```

## Задача 4 (*). Воспроизвести практическую часть лекции самостоятельно.
---
Создать виртуальную машину.
 
Пришлось изменить пути файлов из примера.

#### **Vagrantfile**

- Изменил переменную `INVENTORY_PATH`
- Изменил переменную `setup.playbook`

* Vagrantfile
```ruby
# -*- mode: ruby -*-

ISO = "bento/ubuntu-20.04"
NET = "192.168.56."
DOMAIN = ".netology"
HOST_PREFIX = "server"
INVENTORY_PATH = "../vagrant/inventory"

servers = [
  {
    :hostname => HOST_PREFIX + "1" + DOMAIN,
    :ip => NET + "11",
    :ssh_host => "20011",
    :ssh_vm => "22",
    :ram => 1024,
    :core => 1
  }
]

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: false
  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = ISO
      node.vm.hostname = machine[:hostname]
      node.vm.network "private_network", ip: machine[:ip]
      node.vm.network :forwarded_port, guest: machine[:ssh_vm], host: machine[:ssh_host]
      node.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
        vb.customize ["modifyvm", :id, "--cpus", machine[:core]]
        vb.name = machine[:hostname]
      end
      node.vm.provision "ansible" do |setup|
        setup.inventory_path = INVENTORY_PATH
        setup.playbook = "./playbook.yml"
        setup.become = true
        setup.extra_vars = { ansible_user: 'vagrant' }
      end
    end
  end
end
```


#### **inventory**

```
[nodes:children]
manager

[manager]
server1.netology ansible_host=127.0.0.1 ansible_port=20011 ansible_user=vagrant
```

#### **playbook.yml**

- Убрал опции настройки ssh, т.к. сыпались некритичные ошибки

```yaml

---

  - hosts: nodes
    become: yes
    become_user: root
    remote_user: vagrant

    tasks:

      - name: Checking DNS
        command: host -t A google.com

      - name: Installing tools
        apt: >
          package={{ item }}
          state=present
          update_cache=yes
        with_items:
          - git
          - curl

      - name: Installing docker
        shell: curl -fsSL get.docker.com -o get-docker.sh && chmod +x get-docker.sh && ./get-docker.sh

      - name: Add the current user to docker group
        user: name=vagrant append=yes groups=docker
```

Вывод shell
```shell
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

 Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды `docker ps`
```shell
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker -v
Docker version 23.0.6, build ef23cbc
```







