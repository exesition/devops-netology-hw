
# Домашнее задание к занятию «Микросервисы: принципы»

Вы работаете в крупной компании, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps-специалисту необходимо выдвинуть предложение по организации инфраструктуры для разработки и эксплуатации.

## Задача 1: API Gateway 

Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.


Обоснуйте свой выбор.

| API Gateway      | маршрутизация запросов к нужному сервису на основе конфигурации | возможность проверки аутентификационной информации в запросах     | обеспечение терминации HTTPS     |
|:---|:---:|:---:|:---:|
|Microsoft Azure API Management|Да|Да|Да|
|Amazon API Gateway            |Да|Да|Да|
|Yandex API Gateway            |Да|Да|Да|
|Tyk API Gateway               |Да|Да|Да|
|Gravitee.io                   |Да|Да|Да|
|Apache APISIX                 |Да|Да|Да|
|Kong                          |Да|Да|Да|

Cуществует большое количество решений, которые обеспечивают все необходимые потребности для реализации API Gateway, выбор решения зависит от конкретных задач и финансового обеспечения.

При выборе решения необходимо учитывать:
- возможность интеграции с существующей инфраструктурой
- возможность масштабирования
- обеспечение безопасности
- наличие инструментов для пользователи и разработчика

<br>

## Задача 2: Брокер сообщений

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

|Брокер сообщений|поддержка кластеризации для обеспечения надёжности|хранение сообщений на диске в процессе доставки|высокая скорость работы|поддержка различных форматов сообщений|разделение прав доступа к различным потокам сообщений|простота эксплуатации|
|:---|:---:|:---:|:---:|:---:|:---:|:---:|
|RabbitMQ                    |Да|Да|Да|STOMP/AMQP/MQTT|Да|Да|
|Apache Kafka                |Да|Да|Да|BINARY on TCP|Да|Нет|
|Amazon Simple Queue Service |Да|Да|Да|STOMP/AMQP/MQTT и пр.|Да|Да|
|Redis                       |Да|Да|Да|RESP|Да|Да|
|Apache ActiveMQ             |Да|Да|Нет|AMQP/MQTT/RESP и пр.|Да|Да|

Брокеры используются при построении крупных информационных систем, выбор решения зависит от поставленной задачи и контекста в котором его будут использовать. 
Например:
- Apache Kafka - когда нужно обработать большой объем данных, которые очень быстро генерируются; при реализации транзакционных или конвейерных систем; при построении событийно-ориентированной архитектуры; при использовании буфера для логов и метрик.
- RabbitMQ - нет большого потока данных; важна гибкость маршрутизации сообщений внутри системы; важен факт доставки сообщений.
- Redis - необходима обработка больших объемов данных; не требуется персистентность; необходима высокая скорость доставки сообщений.

<br>


### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---