# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

<details>
  <summary>Инструкция к заданию</summary>

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

</details>

------


### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

------

**Ответ:**<br>

Создаем `Deployment` по следующему манифест-файлу:<br>

```yaml

apiVersion : apps/v1
kind: Deployment
metadata:
  name: task-1
  labels:
    app: task-1
spec:
  selector:
    matchLabels:
      app: task-1
  template:
    metadata:
      labels:
        app: task-1
    spec:
      containers:
        - name: nginx
          image: nginx:1.20
          ports:
            - containerPort: 80
        - name: multitool
          image: wbitt/network-multitool
          env:
            - name: HTTP_PORT
              value: '8080'
            - name: HTTPS_PORT
              value: '8081'

```

Не заметил каких либо проблем при поднятие контейнеров. Вероятно, она могла заключаться в использование по дефолту одинаковых портов. Других причин не представляю.
Далее нам нужно увеличить количество реплик для этого в наш файл с `Deployment` добавляем в `spec` параметр `replicas: 2` и перекатываем все

До установки параметра `replica`
<p align="center">
  <img src="./screenshots/01_kubectl_deploy.png">
</p>

После перекатки с параметром `replica: 2`
<p align="center">
  <img src="./screenshots/01_kubectl_replica.png">
</p>


Далее нам необходимо написать Service, который обеспечит доступ до реплик

```yaml

apiVersion: v1
kind: Service
metadata:
  name: service-deployment
  namespace: default
spec:
  ports:
    - name: tcp
      port: 80
      targetPort: 9000
  selector:
    app: task-1

```

Используем следующие команды:

```bash
kubectl apply -f service.yaml
kubectl get services
kubectl describe service service-deployment
```

<p align="center">
  <img src="./screenshots/01_kubectl_service.png">
</p>

Поднимем Pod с приложением multitool и убедимся с помощью `curl`, что из пода есть доступ до приложений:

<p align="center">
  <img src="./screenshots/01_kubectl_pod.png">
</p>

<p align="center">
  <img src="./screenshots/01_kubectl_pod2.png">
</p>


### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

------

**Ответ:**<br>

Создаем 2 новых файла. Один для `Deployment` по следующему манифест-файлу:<br>

```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: task-2
  labels:
    app: task-2
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: task-2
  template:
    metadata:
      labels:
        app: task-2
      namespace: default
    spec:
      containers:
      - name: nginx
        image: nginx:1.20
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
      initContainers:
      - name: init-service-deploy
        image: busybox:1.28
        command: ['sh', '-c', "until nslookup wait-nginx-start.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for wait-nginx-start; sleep 2; done"]


```
Второй файл будет отвечать за `Service`:

```yaml

apiVersion: v1
kind: Service
metadata:
  name: wait-nginx-start
  namespace: default
spec:
  selector:
    app: task-2
  ports:
   - protocol: TCP
     port: 80

```

Результат:
<p align="center">
  <img src="./screenshots/02_kubectl_deploy.png">
</p>
