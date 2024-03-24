# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.


<details>
  <summary>Инструкция к заданию</summary>

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

</details>

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

**Ответ:**<br>

Выполняем установка Helm-а на машину и запускаем `helm create task1`

<p align="center">
  <img src="./screenshots/01_helm_01.png">
</p>

Дaлее для проектов подготовил следующие папки и файлы:
Изменял в проекте следующие файлы:

[task1/Chart.yaml](./task1/Chart.yaml)<br>
[task1/values.yaml](./task1/values.yaml)<br>
[task1/templates/nginx.yaml](./task1/templates/nginx.yml)<br>
[task1/templates/service.yaml](./task1/templates/service.yaml)<br>

При желание все это можно упаковать командой `helm package task1/` и распространять.

<details>
  <summary>Листинг при использование версии "latest"</summary>

```bash
root@exe-ubuntu:~/.kube/helm# helm template task1/
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /root/.kube/config
---
# Source: nginx/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: release-name-nginx
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "latest"
    app.kubernetes.io/managed-by: Helm
automountServiceAccountToken: true
---
# Source: nginx/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: release-name-nginx
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "latest"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
---
# Source: nginx/templates/service.yml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc-02
  labels:
    app: homework
spec:
  selector:
    app: homework
  ports:
    - port: 80
      name: http
---
# Source: nginx/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: release-name-nginx
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "latest"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx
      app.kubernetes.io/instance: release-name
  template:
    metadata:
      labels:
        helm.sh/chart: nginx-0.1.2
        app.kubernetes.io/name: nginx
        app.kubernetes.io/instance: release-name
        app.kubernetes.io/version: "latest"
        app.kubernetes.io/managed-by: Helm
    spec:
      serviceAccountName: release-name-nginx
      securityContext:
        {}
      containers:
        - name: nginx
          securityContext:
            {}
          image: "nginx:latest"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            null
          readinessProbe:
            null
          resources:
            {}
---
# Source: nginx/templates/nginx.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  labels:
    app: homework
spec:
  replicas: 1
  selector:
    matchLabels:
      app: homework
  template:
    metadata:
      labels:
        app: homework
    spec:
      containers:
        - name: nginx
          image: "nginx:latest"
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
---
# Source: nginx/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "release-name-nginx-test-connection"
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "latest"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['release-name-nginx:80']
  restartPolicy: Never


```

</details>

<details>
  <summary>Листинг при использование версии "stable-bullseye-perl"</summary>

```bash
root@exe-ubuntu:~/.kube/helm# helm template task1/
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /root/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /root/.kube/config
---
# Source: nginx/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: release-name-nginx
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "stable-bullseye-perl"
    app.kubernetes.io/managed-by: Helm
automountServiceAccountToken: true
---
# Source: nginx/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: release-name-nginx
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "stable-bullseye-perl"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
---
# Source: nginx/templates/service.yml
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc-02
  labels:
    app: homework
spec:
  selector:
    app: homework
  ports:
    - port: 80
      name: http
---
# Source: nginx/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: release-name-nginx
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "stable-bullseye-perl"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx
      app.kubernetes.io/instance: release-name
  template:
    metadata:
      labels:
        helm.sh/chart: nginx-0.1.2
        app.kubernetes.io/name: nginx
        app.kubernetes.io/instance: release-name
        app.kubernetes.io/version: "stable-bullseye-perl"
        app.kubernetes.io/managed-by: Helm
    spec:
      serviceAccountName: release-name-nginx
      securityContext:
        {}
      containers:
        - name: nginx
          securityContext:
            {}
          image: "nginx:stable-bullseye-perl"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            null
          readinessProbe:
            null
          resources:
            {}
---
# Source: nginx/templates/nginx.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  labels:
    app: homework
spec:
  replicas: 1
  selector:
    matchLabels:
      app: homework
  template:
    metadata:
      labels:
        app: homework
    spec:
      containers:
        - name: nginx
          image: "nginx:stable-bullseye-perl"
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
---
# Source: nginx/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "release-name-nginx-test-connection"
  labels:
    helm.sh/chart: nginx-0.1.2
    app.kubernetes.io/name: nginx
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "stable-bullseye-perl"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['release-name-nginx:80']
  restartPolicy: Never


```

</details>


------

### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.


**Ответ:**<br>

Подготовил чарт, необходимо его задеплоить и расплодить:

<p align="center">
  <img src="./screenshots/02_helm_02.png">
</p>

<p align="center">
  <img src="./screenshots/02_helm_03.png">
</p>


Далее деплоим в namespace=`app1`
<p align="center">
  <img src="./screenshots/02_helm_04.png">
</p>

Теперь в namespace=`app2`
<p align="center">
  <img src="./screenshots/02_helm_05.png">
</p>

<p align="center">
  <img src="./screenshots/02_helm_06.png">
</p>
