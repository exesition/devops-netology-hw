# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.
<p align="center">
    <img width="1200 height="600" src="./screenshots/01_vhost.png">
</p>
2. Установить Jenkins при помощи playbook.
<p align="center">
    <img width="1200 height="600" src="./screenshots/01_ansible.png">
</p>
3. Запустить и проверить работоспособность.
<p align="center">
    <img width="1200 height="600" src="./screenshots/01_webjenkins.png">
</p>
4. Сделать первоначальную настройку.
<p align="center">
    <img width="1200 height="600" src="./screenshots/01_sshcon.png">
</p>
<p align="center">
    <img width="1200 height="600" src="./screenshots/01_agetnconn.png">
</p>



## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
<p align="center">
    <img width="1200 height="600" src="./screenshots/02_01_freestyle_items.png">
</p>


2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
<p align="center">
    <img width="1200 height="600" src="./screenshots/02_02pipeline.png">
</p>


3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

[Jenkinsfile](https://github.com/exesition/vector-role/blob/main/Jenkinsfile)


4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
<p align="center">
    <img width="1200 height="600" src="./screenshots/02_04multibranch.png">
</p>

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
[ScriptedJenkinsfile](https://github.com/exesition/vector-role/blob/main/ScriptedJenkinsfile)

6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
<p align="center">
    <img width="1200 height="600" src="./screenshots/02_06.png">
</p>


7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл
**[ScriptedJenkinsfile](./ScriptedJenkinsfile)**.
<p align="center">
    <img width="1200 height="600" src="./screenshots/02_07scryipted.png">
</p>

8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

[Role](https://github.com/exesition/vector-role/) <br>
[DeclarativePipeline](https://github.com/exesition/09-ci-04-jenkins/infrastructure/files/DeclarativePipeline) <br>
[ScriptedJenkinsfile](https://github.com/exesition/09-ci-04-jenkins/infrastructure/files/ScriptedJenkinsfile) <br>


## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, завершившиеся хотя бы раз неуспешно. Добавить скрипт в репозиторий с решением и названием `AllJobFailure.groovy`.
2. Создать Scripted Pipeline так, чтобы он мог сначала запустить через Yandex Cloud CLI необходимое количество инстансов, прописать их в инвентори плейбука и после этого запускать плейбук. Мы должны при нажатии кнопки получить готовую к использованию систему.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
