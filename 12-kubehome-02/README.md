# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------
<details>
  <summary>Инструкция к заданию</summary>

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

</details>


### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

------

**Ответ:**<br>

Создаем Pod по следующему манифесту:<br>
```yaml

apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  containers:
  - name: hello-world
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080

```

Применяем его и смотрим появился ли pod:<br>
```bash
kubectl apply -f pod.yaml
```


<p align="center">
  <img src="./screenshots/01_kubectl_pod_console.png">
</p>

<p align="center">
  <img src="./screenshots/02_kubectl_pod.png">
</p>


Останавливаем Pod для экономии ресурсов:<br>
```bash
kubectl delete pod hello-world
```

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

**Ответ:**<br>

Создаем единый манифест-файл описывающий все требования выше:<br>
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: netology-web
  labels:
    app.kubernetes.io/name: netology
spec:
  containers:
  - name: netology-web
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080
      name: netology-port
---
apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector:
    app.kubernetes.io/name: netology
  ports:
    - name: svc-port
      protocol: TCP
      port: 8080
      targetPort: netology-port

```
<p align="center">
  <img src="./screenshots/03_kubectl_podservice.png">
</p>

<p align="center">
  <img src="./screenshots/04_kubectl_web.png>
</p>


P.S. Так и не понял чем был занят 80 порт. По netstat показывало, что какой то из контейнеров. 
В самом kubectl пробовал смотреть через
```bash
 kubectl get <podname> --all-namespaces -o wide 
 kubectl describe pod <podname> -n <namespace>
```
Думаю позже разберусь.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------

### Критерии оценки
Зачёт — выполнены все задания, ответы даны в развернутой форме, приложены соответствующие скриншоты и файлы проекта, в выполненных заданиях нет противоречий и нарушения логики.

На доработку — задание выполнено частично или не выполнено, в логике выполнения заданий есть противоречия, существенные недостатки.

































=========
==========
==========


### Задание 1. Установка MicroK8S

1. Установить MicroK8S на локальную машину или на удалённую виртуальную машину.

Установил на локальную машину

<p align="center">
  <img src="./screenshots/01_kubectl_status.png">
</p>

2. Установить dashboard.

```bash
microk8s.enable dashboard
microk8s status
```
<p align="center">
  <img src="./screenshots/03_kubectl_dashboard.png">
</p>

3. Сгенерировать сертификат для подключения к внешнему ip-адресу.

Так как используется локальная машина, то сгенерил для нее 
```bash
microk8s refresh-certs --cert front-proxy-client.crt
```
<p align="center">
  <img src="./screenshots/04_kubectl_certs.png">
</p>


------

### Задание 2. Установка и настройка локального kubectl
1. Установить на локальную машину kubectl.

<p align="center">
  <img src="./screenshots/02_kubectl_version.png">
</p>

2. Настроить локально подключение к кластеру.

<p align="center">
  <img src="./screenshots/08_kubectl_connect.png">
</p>


3. Подключиться к дашборду с помощью port-forward.

Перед подключением к WEB-у генерируем токен по которому будем авторизовываться 

```bash
microk8s kubectl describe secret -n kube-system microk8s-dashboard-token
microk8s kubectl port-forward -n kube-system service/kubernetes-dashboard 10443:443
```

<p align="center">
  <img src="./screenshots/05_kubectl_token.png">
</p>

<p align="center">
  <img src="./screenshots/06_kubectl_forwarder.png">
</p>

<p align="center">
  <img src="./screenshots/07_kubectl_web_login.png">
</p>

<p align="center">
  <img src="./screenshots/07_kubectl_web.png">
</p>

------
