# Домашнее задание к занятию «Микросервисы: подходы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.


## Задача 1: Обеспечить разработку

Предложите решение для обеспечения процесса разработки: хранение исходного кода, непрерывная интеграция и непрерывная поставка. 
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- облачная система;
- система контроля версий Git;
- репозиторий на каждый сервис;
- запуск сборки по событию из системы контроля версий;
- запуск сборки по кнопке с указанием параметров;
- возможность привязать настройки к каждой сборке;
- возможность создания шаблонов для различных конфигураций сборок;
- возможность безопасного хранения секретных данных (пароли, ключи доступа);
- несколько конфигураций для сборки из одного репозитория;
- кастомные шаги при сборке;
- собственные докер-образы для сборки проектов;
- возможность развернуть агентов сборки на собственных серверах;
- возможность параллельного запуска нескольких сборок;
- возможность параллельного запуска тестов.

Обоснуйте свой выбор.

---

**Ответ:**<br>

```
Хранение исходного кода: GitHub или GitLab. Оба сервиса предоставляют облачное хранилище для Git-репозиториев, позволяют создавать репозитории для каждого сервиса и обладают интеграцией с другими инструментами.

Непрерывная интеграция и поставка: GitLab CI/CD. GitLab CI/CD позволяет запускать сборки автоматически по событиям из системы контроля версий или вручную с указанием параметров. Он также поддерживает создание шаблонов для конфигураций сборок, хранение секретных данных в защищенном виде, кастомные шаги при сборке, использование собственных докер-образов, развертывание агентов на собственных серверах, параллельный запуск нескольких сборок и тестов.

GitLab CI/CD интегрирован с GitLab, что упрощает настройку и обеспечивает единое окружение для управления кодом и процессом CI/CD. Кроме того, GitLab CI/CD предоставляет широкие возможности для настройки и расширения функциональности, что позволяет адаптировать его под конкретные потребности проекта.

Таким образом, использование GitLab для хранения кода и GitLab CI/CD для непрерывной интеграции и поставки позволит эффективно организовать процесс разработки, удовлетворяя указанные требования.

```


## Задача 2: Логи

Предложите решение для обеспечения сбора и анализа логов сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор логов в центральное хранилище со всех хостов, обслуживающих систему;
- минимальные требования к приложениям, сбор логов из stdout;
- гарантированная доставка логов до центрального хранилища;
- обеспечение поиска и фильтрации по записям логов;
- обеспечение пользовательского интерфейса с возможностью предоставления доступа разработчикам для поиска по записям логов;
- возможность дать ссылку на сохранённый поиск по записям логов.

Обоснуйте свой выбор.

**Ответ:**<br>

```
Сбор логов: Fluentd или Filebeat. Fluentd и Filebeat - это легковесные агенты, способные собирать логи из stdout различных приложений на хостах, обслуживающих систему. Они позволяют настраивать сбор логов с различных источников, преобразовывать их в нужный формат и отправлять в центральное хранилище.

Центральное хранилище: Elasticsearch. Elasticsearch является распределенным поисковым и аналитическим движком, который может использоваться для хранения и индексации логов. Он обеспечивает гарантированную доставку логов до центрального хранилища, а также предоставляет возможности поиска, фильтрации и анализа записей логов.

Визуализация и анализ: Kibana. Kibana - это веб-интерфейс для визуализации данных, хранящихся в Elasticsearch. Он позволяет строить графики, диаграммы, дашборды на основе данных логов, фильтровать записи, проводить аналитику. Кроме того, Kibana предоставляет возможность создания сохраненных поисковых запросов, которые могут быть использованы для быстрого доступа к определенным данным.

Обоснование выбора:
- Fluentd или Filebeat обеспечат сбор логов из различных источников с минимальными требованиями к приложениям.
- Elasticsearch обеспечит надежное хранение и индексацию логов с возможностью поиска и фильтрации.
- Kibana предоставит удобный пользовательский интерфейс для визуализации и анализа данных логов, а также возможность создания сохраненных поисков для быстрого доступа к нужным записям.

Таким образом, данное решение позволит эффективно организовать сбор, хранение, анализ и визуализацию логов в микросервисной архитектуре, удовлетворяя указанным требованиям.
```


## Задача 3: Мониторинг

Предложите решение для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре.
Решение может состоять из одного или нескольких программных продуктов и должно описывать способы и принципы их взаимодействия.

Решение должно соответствовать следующим требованиям:
- сбор метрик со всех хостов, обслуживающих систему;
- сбор метрик состояния ресурсов хостов: CPU, RAM, HDD, Network;
- сбор метрик потребляемых ресурсов для каждого сервиса: CPU, RAM, HDD, Network;
- сбор метрик, специфичных для каждого сервиса;
- пользовательский интерфейс с возможностью делать запросы и агрегировать информацию;
- пользовательский интерфейс с возможностью настраивать различные панели для отслеживания состояния системы.

Обоснуйте свой выбор.

**Ответ:**<br>

```
Для обеспечения сбора и анализа состояния хостов и сервисов в микросервисной архитектуре предлагаю использовать следующее решение:

Сбор метрик: Prometheus. Prometheus - это система мониторинга и оповещения, способная собирать метрики с различных источников, включая хосты и сервисы. Она поддерживает сбор метрик CPU, RAM, HDD, Network для хостов, а также может собирать пользовательские метрики для каждого сервиса. Prometheus также предоставляет возможность настройки специфичных для сервисов метрик.

Хранение данных: Prometheus может использовать свое встроенное хранилище временных рядов или интегрироваться с базой данных, такой как TimescaleDB или InfluxDB, для долгосрочного хранения метрик.

Визуализация данных: Grafana. Grafana - это популярный инструмент визуализации данных, который может интегрироваться с Prometheus для отображения собранных метрик. С помощью Grafana можно создавать пользовательские дашборды, настраивать различные панели для отслеживания состояния системы, делать запросы к данным и агрегировать информацию.

Обоснование выбора:
- Prometheus обеспечит сбор метрик со всех хостов и сервисов, включая стандартные и пользовательские метрики.
- Grafana предоставит удобный пользовательский интерфейс для визуализации данных, создания дашбордов и настройки панелей для отслеживания состояния системы.
- Использование Prometheus и Grafana позволит эффективно организовать мониторинг состояния хостов и сервисов в микросервисной архитектуре, удовлетворяя указанным требованиям.

```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---