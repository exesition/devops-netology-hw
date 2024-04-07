# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.


<details>
  <summary>Инструкция к заданию</summary>

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

</details>

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.


------

**Ответ:**<br>

Работа выполнена на kubespray.    

Список используемых манифестов:

|_Deployment<br>
|_[frontend.yml](./manifest/frontend.yml)<br>
|_[backend.yml](./manifest/backend.yml)<br>
|_[cache.yml](./manifest/cache.yml)<br>
|__Policy<br>
&nbsp;&nbsp;&nbsp;|_[default-policy.yml](./manifest/default-policy.yml)<br>
&nbsp;&nbsp;&nbsp;|_[front-back.yml](./manifest/front-back.yml)<br>
&nbsp;&nbsp;&nbsp;|_[back-cache.yml](./manifest/back-cache.yml)<br>

Применяем манифесты для сервисов:    

```
root@exe-ubuntu:~/.kube# kubectl apply -f frontend.yml
deployment.apps/frontend created
service/frontend-svc unchanged

root@exe-ubuntu:~/.kube# kubectl apply -f backend.yml
deployment.apps/backend created
service/backend-svc created

root@exe-ubuntu:~/.kube# kubectl apply -f cache.yml
deployment.apps/cache created
service/cache-svc created

root@exe-ubuntu:~/.kube# kubectl get deploy
No resources found in default namespace.
```

Проверяем что все прокаталось:
```
root@exe-ubuntu:~/.kube# kubectl get deploy -n app
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
backend    1/1     1            1           31s
cache      1/1     1            1           24s
frontend   1/1     1            1           37s

root@exe-ubuntu:~/.kube# kubectl get svc -n app
backend-svc    ClusterIP   10.231.54.15    <none>        80/TCP    52s
cache-svc      ClusterIP   10.231.25.242   <none>        80/TCP    20s
frontend-svc   ClusterIP   10.231.24.201   <none>        80/TCP    1m30s

root@exe-ubuntu:~/.kube# kubectl config set-context --current --namespace=app
Context "kubernetes-admin@cluster.local" modified.
```


Проверяем доступность:    

```
root@exe-ubuntu:~/.kube# kubectl exec frontend-9db547fnh-n2spb -- curl backend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   140  100   140    0     0   8188      0 --:--:-- --:--:-- --:--:--  8750
WBITT Network MultiTool (with NGINX) - backend-94b2n4b1v3-n5vjk - 10.233.70.2 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

```
root@exe-ubuntu:~/.kube# kubectl exec backend-94b2n4b1v3-n5vjk -- curl cache-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - cache-6ddb58d8bc-x79n6 - 10.233.70.3 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
100   138  100   138    0     0  37438      0 --:--:-- --:--:-- --:--:-- 46000
```

Применяем default политику, запрещающую доступ:    

```
root@exe-ubuntu:~/.kube# kubectl apply -f default-policy.yml
networkpolicy.networking.k8s.io/default-deny-ingress created

root@exe-ubuntu:~/.kube# kubectl exec frontend-9db547fnh-n2spb -- curl backend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0^C

root@exe-ubuntu:~/.kube# kubectl exec backend-94b2n4b1v3-n5vjk -- curl cache-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0^C
root@exe-ubuntu:~/.kube# kubectl get networkpolicies
NAME                   POD-SELECTOR   AGE
default-deny-ingress   <none>         3m12s
```

Применяем политики, указанные в условии задания:    

```
root@exe-ubuntu:~/.kube# kubectl apply -f front-back.yml
networkpolicy.networking.k8s.io/front-back created

root@exe-ubuntu:~/.kube# kubectl apply -f back-cache.yml
networkpolicy.networking.k8s.io/back-cache created

root@exe-ubuntu:~/.kube# kubectl get networkpolicies
NAME                   POD-SELECTOR   AGE
back-cache             app=cache      8s
default-deny-ingress   <none>         7m42s
front-back             app=backend    17s

root@exe-ubuntu:~/.kube# kubectl exec frontend-9db547fnh-n2spb -- curl backend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - backend-94b2n4b1v3-n5vjk - 10.233.70.2 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
100   140  100   140    0     0   8492      0 --:--:-- --:--:-- --:--:--  8750
root@exe-ubuntu:~/.kube# kubectl exec backend-58b6c7f7f7-n9cxf -- curl cache-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0WBITT Network MultiTool (with NGINX) - cache-6ddb58d8bc-x79n6 - 10.233.70.3 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
100   138  100   138    0     0  11241      0 --:--:-- --:--:-- --:--:-- 11500

root@exe-ubuntu:~/.kube# kubectl exec cache-6ddb58d8bc-x79n6 -- curl frontend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:02 --:--:--     0^C

root@exe-ubuntu:~/.kube# kubectl exec backend-58b6c7f7f7-n9cxf -- curl frontend-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0^C

```