# Домашнее задание к занятию Troubleshooting

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер K8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

----

**Ответ:**<br>


```
root@exe-ubuntu:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
```
В кластере нет неймспейсов web и data, создаем:

```
root@exe-ubuntu:~$ kubectl create namespace web
namespace/web created
root@exe-ubuntu:~$ kubectl create namespace data
namespace/data created
root@exe-ubuntu:~$ kubectl get ns
NAME              STATUS   AGE
data              Active   6s
default           Active   29d
kube-flannel      Active   29d
kube-node-lease   Active   29d
kube-public       Active   29d
kube-system       Active   29d
web               Active   15s
root@exe-ubuntu:~$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created

```

Ищем ошибку в манифесте:

```
root@exe-ubuntu:~$ kubectl describe deployment web-consumer -n web
Name:                   web-consumer
Namespace:              web
CreationTimestamp:      Thu, 07 Apr 2024 14:30:10 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=web-consumer
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=web-consumer
  Containers:
   busybox:
    Image:      radial/busyboxplus:curl
    Port:       <none>
    Host Port:  <none>
    Command:
      sh
      -c
      while true; do curl auth-db; sleep 5; done
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   web-consumer-5f87765478 (2/2 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  3m42s  deployment-controller  Scaled up replica set web-consumer-5f87765478 to 2
```
```
root@exe-ubuntu:~$ kubectl get po -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-7d41137401-3fs64   1/1     Running   0          4m40s
web-consumer-5f82278578-kv79l   1/1     Running   0          4m40s
root@exe-ubuntu:~$ kubectl logs web-consumer-7d41137401-3fs64 -n web
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
```

В логах подов web-consumer наблюдается ошибка "curl: (6) Couldn't resolve host 'auth-db'",
Каких либо других явных проблем при изучение конфигурации мной обнаружено не было.
В целом, это предсказуемое поведение т.к. сервис "auth-db" для подов web-consumer находится в другом namespace.

Для решения найденной проблемы требуется перезалить деплоймент и добавить в манифесте имя namepace к днс имени пода (auth-db.data) 

```
root@exe-ubuntu:~$ nano task.yaml
root@exe-ubuntu:~$ kubectl apply -f task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created
root@exe-ubuntu:~$ kubectl get po -o wide -n web
NAME                            READY   STATUS    RESTARTS   AGE   IP           NODE            NOMINATED NODE   READINESS GATES
web-consumer-7d41137401-131b4   1/1     Running   0          23s   10.232.4.4   worker-node-1   <none>           <none>
web-consumer-5f82278578-j34z8   1/1     Running   0          23s   10.232.3.5   worker-node-2   <none>           <none>
root@exe-ubuntu:~$ kubectl logs web-consumer-7d41137401-131b4 -n web
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (7) Failed to connect to auth-db.data port 80: Connection refused
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0curl: (7) Failed to connect to auth-db.data port 80: Connection refused
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   104k      0 --:--:-- --:--:-- --:--:--  597k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  54144      0 --:--:-- --:--:-- --:--:--  119k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   100k      0 --:--:-- --:--:-- --:--:--  597k

```

Как мы видим проделанные выше действия решили проблему с доступом