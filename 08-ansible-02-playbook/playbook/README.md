## Описание playbook

```
Данный playbook предназначен для установки и настройки двух сервисов - Clickhouse и Vector. 

Clickhouse - это колоночная СУБД с открытым исходным кодом, которая специализируется на аналитических запросах. В playbook происходит установка Clickhouse и создание базы данных "logs".

Vector - это высокопроизводительный инструмент для сбора, обработки и передачи логов. В playbook происходит установка Vector, настройка конфигурационного файла и создание systemd unit файла.
```

## Описание tasks:

```
Этот playbook устанавливает Clickhouse:

TASK [Get clickhouse distrib] - Загрузка rpm-пакетов Clickhouse с помощью модуля get_url. В блоке try выполняется загрузка пакетов из списка clickhouse_packages с указанием версии clickhouse_version, а в блоке except - загрузка пакета clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm. Если выполнение задачи происходит в check_mode, то загрузка не выполняется.
TASK [Install clickhouse packages] - Установка пакетов Clickhouse с помощью модуля yum и указанием путей к загруженным rpm-пакетам. После установки пакетов вызывается обработчик Start clickhouse service для перезапуска сервиса.
TASK [Flush handlers] - Сброс обработчиков с помощью модуля meta: flush_handlers.
TASK [Create database] - Создание базы данных logs с помощью команды clickhouse-client -q 'create database logs;'. Регистрируется результат выполнения команды в переменной create_db. Если код возврата не равен 0 или 82, то задача считается не выполненной, иначе - выполненной.
```

```
Этот playbook содержит три задачи для установки и настройки Vector:

TASK [Install Vector] - Установка rpm-пакета Vector с помощью модуля yum.
TASK [Vector | Template Config] - Создание файла конфигурации Vector из шаблона с помощью модуля template. В этой задаче используется jinja2-шаблон vector.j2, который заполняется переменными из inventory и переменными Ansible.
TASK [Vector | Create systemd unit] - Создание systemd unit файла для автоматического запуска Vector при старте системы. Файл создается из шаблона vector.service.j2 и копируется в /etc/systemd/system/.
TASK [Vector | Start Service] - Используется модуль systemd для запуска сервиса и перезагрузки демона systemd.
```

## Параметры

```
Для Clickhouse в playbook используются следующие параметры:

- clickhouse_version - версия Clickhouse, которую необходимо установить
- clickhouse_packages - список пакетов Clickhouse, которые необходимо установить

Для Vector в playbook используется следующий параметр:

- vector_url - URL для загрузки rpm-пакета Vector
```

## Теги

```
Для удобства запуска определенных задач в playbook используются теги:

- click - тег для задач, связанных с установкой Clickhouse
- vector - тег для задач, связанных с установкой Vector
```