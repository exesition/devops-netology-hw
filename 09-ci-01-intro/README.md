# Домашнее задание к занятию 7 «Жизненный цикл ПО»

## Подготовка к выполнению

1. Получить бесплатную версию [Jira](https://www.atlassian.com/ru/software/jira/free).
2. Настроить её для своей команды разработки.
3. Создать доски Kanban и Scrum.
4. [Дополнительные инструкции от разработчика Jira](https://support.atlassian.com/jira-cloud-administration/docs/import-and-export-issue-workflows/).

## Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.

Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.


---

**Ответ:**<br>

Bugfix
<p align="center">
  <img src="./screenshots/bugfix_shc.png">
</p>
<p align="center">
  <img src="./screenshots/bugfix_shc_er.png">
</p>


Other tasks
<p align="center">
  <img src="./screenshots/tasks_shc.png">
</p>
<p align="center">
  <img src="./screenshots/tasks_shc_er.png">
</p>

---

**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done. 
<p align="center">
  <img src="./screenshots/bug-task.png">
</p>
<p align="center">
  <img src="./screenshots/bug-tas_logk.png">
</p>
2. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 
<p align="center">
  <img src="./screenshots/epic.png">
</p>
3. При проведении обеих задач по статусам используйте kanban. 
4. Верните задачи в статус Open.
<p align="center">
  <img src="./screenshots/epic_kanban.png">
</p>
5. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
<p align="center">
  <img src="./screenshots/sprint.png">
</p>
<p align="center">
  <img src="./screenshots/sprintend.png">
</p>
6. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.
---

**Ответ**

Ссылка на файлы:<br>
 [Bugfix](./workflow/bugfix.xml) <br>
 [Tasks](./workflow/tasks.xml) <br>

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---