# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

<details>
  <summary>Инструкция к заданию</summary>

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

</details>

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

**Ответ:**<br>

Демонстрация работы

<p align="center">
  <img src="./screenshots/01_kubectl_task1.png">
</p>

<details>
  <summary>Листинг</summary>

```yaml
apiVersion : apps/v1
kind: Deployment
metadata:
 name: deployment
 labels:
   app: task_1
spec:
 replicas: 1
 selector:
   matchLabels:
     app: task_1
 template:
   metadata:
     labels:
       app: task_1
   spec:
     containers:
       - name: busybox
         image: busybox
         command: ['sh', '-c', 'while true; do echo "test your homework string" >> /share/write.txt; sleep 5; done']
         volumeMounts:
         - mountPath: /share
           name: share
       - name: network-multitool
         image: praqma/network-multitool:latest
         volumeMounts:
         - mountPath: /share
           name: share
         env:
         - name: HTTP_PORT
           value: "80"
         - name: HTTPS_PORT
           value: "443"
         ports:
         - containerPort: 80
           name: http-port
         - containerPort: 443
           name: https-port
     volumes:
     - name: share
       emptyDir: {}


```
</details>

Манифест файл:<br>

[Deployment.yml](./task1/deployment.yml)<br>



### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

------

**Ответ:**<br>

Демонстрация работы

<p align="center">
  <img src="./screenshots/02_kubectl_task1.png">
</p>

<details>
  <summary>Листинг</summary>

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemonset
  labels:
    app: task_2
spec:
  selector:
    matchLabels:
      app: task_2
  template:
    metadata:
      labels:
        app: task_2
    spec:
      containers:
      - name: network-multitool
        image: praqma/network-multitool:latest
        volumeMounts:
        - name: node-volume
          mountPath: /log/syslog
        env:
        - name: HTTP_PORT
          value: "80"
        - name: HTTPS_PORT
          value: "443"
        ports:
        - containerPort: 80
          name: http-port
        - containerPort: 443
          name: https-port
      volumes:
      - name: node-volume
        hostPath:
          path: /var/log/syslog

```

</details>

Манифест файл:<br>

[DaemonSet.yml](./task2/daemonset.yml)<br>