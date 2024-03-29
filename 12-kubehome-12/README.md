# Домашнее задание к занятию «Компоненты Kubernetes»

### Цель задания

Рассчитать требования к кластеру под проект

### Задание. Необходимо определить требуемые ресурсы
Известно, что проекту нужны база данных, система кеширования, а само приложение состоит из бекенда и фронтенда. Опишите, какие ресурсы нужны, если известно:

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. База данных должна быть отказоустойчивой. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
3. Кеш должен быть отказоустойчивый. Потребляет 4 ГБ ОЗУ в работе, 1 ядро. 3 копии. 
4. Фронтенд обрабатывает внешние запросы быстро, отдавая статику. Потребляет не более 50 МБ ОЗУ на каждый экземпляр, 0.2 ядра. 5 копий. 
5. Бекенд потребляет 600 МБ ОЗУ и по 1 ядру на копию. 10 копий.

----

**Ответ:**<br>

**Требуемые ресурсы для приложения**
| Payload     | Mem (Mi) | CPU (m) | Replicas | Total Mem (Mi) | Total CPU (m) |
| ----------- | -------- | ------- | -------- | -------------- | ------------- |
| База данных | 4000     | 1000    | 3        | 16000          | 3000          |
| Кеш         | 4000     | 1000    | 3        | 16000          | 3000          |
| Фронтенд    | 50       | 200     | 5        | 250            | 1000          |
| Бекенд      | 600      | 1000    | 10       | 6000           | 10000         |

Сумма ресурсов для полезной нагрузки  
Memory (Mi) = 38250  
CPU (m) = 17000  

Если мы делим окружения, то минимально (предполагая, что делим неймспейсами prod и dev в 1 кубер кластере)
необходимо добавить ресурсов под идентичный тестовый стенд
Подразумевая дублирование ресурсов в 2х средах выходим на: 76500мб озу и 34 ядра
округлим 78гб и 36 ядер

Распределив нагрузку по 30 процентов в 3х нода мы получим примерно 26гб озу и 12 ядер,
но учитывая возможность выхода из строя 1 ноды и необходимость сохранения работы инфраструктуры:
32гб 15 ядра с отказоустойчивостью на 1 воркер ноду.

Так же в минимальной установке добавим 3 мастер ноды с учетом размещения там же etcd, балансира и тп.,

Требуемое кол-во Worker Node: 4  
Требуемое кол-во Master Node: 3  


---

**Предполагаемое распределение подов на одной ноде:**  
СУБД + Кеш  
Memory (Mi): 8000  
CPU (m): 2000  

Backend  
Memory (Mi): 600 * 4 = 2400  
CPU (m): 1000 * 4 = 4000  

Frontend  
Memory (Mi): 50 * 2 = 100  
CPU (m): 200 * 2 = 400  

---

**Требуемое кол-во ресурсов на одну Worker ноду для полезной нагрузки:**  
Memory (Mi): 8000 + 2400 + 100 = 10500  
CPU (m): 2000 + 4000 + 400 = 6400  

Служебные ресурсы к Worker ноде  
Memory (Mi): 2600 + 100 (Eviction threshold) = 2700  
CPU (m): 90  

Служебные ресурсы к Master ноде  
Memory (Mi): 4000  
CPU (m): 2000  

---

**Требуемые ресурсы для кластера K8S**
| Тип ноды | Кол-во | CPU (m) | Memory (Mi) |
| -------- | ------ | ------- | ----------- |
| Master   | 3      | 2000    | 4000        |
| Worker   | 4      | 8000    | 16000       |