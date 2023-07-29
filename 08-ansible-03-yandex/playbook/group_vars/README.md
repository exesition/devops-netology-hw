## Описание playbook site.yml
```
Playbook выполняет установку и первоначальную конфигурацию:

Clickhouse
Vector
Lighthouse + nginx

Установка выполняется на разные хосты, перечисленные в .inventory/prod.yml

Требования к хостам: RPM-based Linux distribution

Установка Clickhouse
в файле group_vars/clickhouse/vars.yml задается:

версия
пакеты для установки

Описание tasks:

ClickHouse | Download rpm - Загрузка пакетов ClickHouse
ClickHouse | Install packages - Установка пакетов ClickHouse
ClickHouse | Flush handlers - Убеждаемся что все обработчики выполнены перед переходом к следующей задаче
ClickHouse | Create database - Создание БД
Clickhouse | Create table - Создание таблицы
```

## Установка Vector
group_vars/vector/vars.yml задается:

версия (vector_version)
директория установки (vector_path)
конфигурационный файл (vector_config)


Описание tasks:
```
Vector | Download rpm - Загрузка пакетов Vector
Vector | Install package - Установка Vector
Vector | Create data dir - Создание папки для конфигурации Vector
Vector | Template config - Создание конфига Vector
Vector | Register service - Запуск сервиса

```
## Установка Lighthouse
group_vars/light/lighthose.yml задается:

url гитхаб (lighthouse_url )
директория установки (lighthouse_dir)
nginx пользователь (lighthouse_nginx_user)


Описание tasks:
```
LightHouse | Install dependencies - Устанавливается зависимость git
LightHouse | Copy from git - Клонируется репозиторий LightHouse с помощью модуля git
LightHouse | Create config - Создается файл конфигурации LightHouse из шаблона с помощью модуля ansible.builtin.template
```

## Для Nginx:
```
Nginx | Install dependencies - Устанавливается зависимость epel-release
Nginx | Install nginx - Устанавливается Nginx с помощью модуля ansible.builtin.yum
Nginx | Template config - Создается файл конфигурации Nginx из шаблона с помощью модуля ansible.builtin.template
```

## Tags

### Clickhouse

- `clickhouse` - установка и запуск только `clickhouse`

### Vector

- `vector` - установка только `vector`

### Nginx и Lighthouse

- `nginx` - установка только `nginx`
- `lighthouse` - установка только `lighthouse`


```
запуска происходит из файла playbook.yml
```
