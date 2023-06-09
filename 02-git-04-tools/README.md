# Домашнее задание к занятию «Инструменты Git»

### Цель задания

В результате выполнения задания вы:

* научитесь работать с утилитами Git;
* потренируетесь решать типовые задачи, возникающие при работе в команде. 

### Инструкция к заданию

1. Склонируйте [репозиторий](https://github.com/hashicorp/terraform) с исходным кодом Terraform.
2. Создайте файл для ответов на задания в своём репозитории, после выполнения прикрепите ссылку на .md-файл с ответами в личном кабинете.
3. Любые вопросы по решению задач задавайте в чате учебной группы.

------

## Задание

В клонированном репозитории:

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`.
2. Ответьте на вопросы.

* Какому тегу соответствует коммит `85024d3`?
* Сколько родителей у коммита `b8d720`? Напишите их хеши.
* Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами  v0.12.23 и v0.12.24.
* Найдите коммит, в котором была создана функция `func providerSource`, её определение в коде выглядит так: `func providerSource(...)` (вместо троеточия перечислены аргументы).
* Найдите все коммиты, в которых была изменена функция `globalPluginDirs`.
* Кто автор функции `synchronizedWriters`?

*В качестве решения ответьте на вопросы и опишите, как были получены эти ответы.*

------

## ## Ответы на домашнее задание к занятию «2.4. Инструменты Git»


#### **1.** Найдите полный хеш и комментарий коммита, хеш которого начинается на `aefea`

- **Команда:** 
```
git show aefea
```
- **Ответ:** 
aefead2207ef7e2aa5dc81a34aedf0cad4c32545

#### **2.** Какому тегу соответствует коммит `85024d3`?

- **Команда:** 
```
git show 85024d3
```
- **Ответ:** 
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)


#### **3.** Сколько родителей у коммита `b8d720`? Напишите их хеши

- **Команда:** 
```
git show b8d720^
git show b8d720^2
```
- **Ответ:**
Два родителя:
1. 56cd7859e05c36c06b56d013b55a252d0bb7e158
1. 9ea88f22fc6269854151c571162c5bcf958bee2b


#### **4** Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами `v0.12.23` и `v0.12.24`

- **Команда:** 
```
git log ^v0.12.23 v0.12.24 --oneline
```

- **Ответ:**
> 1. 33ff1c03bb **(tag: v0.12.24) v0.12.24**
> 2. b14b74c493 [Website] vmc provider links
> 1. 3f235065b9 Update CHANGELOG.md
> 2. 6ae64e247b registry: Fix panic when server is unreachable
> 1. 5c619ca1ba website: Remove links to the getting started guide's old location
> 1. 06275647e2 Update CHANGELOG.md
> 1. d5f9411f51 command: Fix bug when using terraform login on Windows
> 1. 4b6d06cc5d Update CHANGELOG.md
> 1. dd01a35078 Update CHANGELOG.md
> 1. 225466bc3e Cleanup after **v0.12.23 release**



#### **5.** Найдите коммит в котором была создана функция `func providerSource`, ее определение в коде выглядит так `func providerSource(...`) (вместо троеточия перечислены аргументы)

- **Команда:** 
```
git log -S'func providerSource' --oneline
```
- **Ответ:** 
8c928e83589d90a031f811fae52a81be7153e82f


#### **6.** Найдите все коммиты в которых была изменена функция `globalPluginDirs`

- **Команда:** 
```
git grep -c 'globalPluginDirs'
git log -s -L :globalPluginDirs:plugins.go --oneline
```
- **Ответ:**
> **78b1220558** Remove config.go and update things using its aliases  
> **52dbf94834** keep .terraform.d/plugins for discovery  
> **41ab0aef7a** Add missing OS_ARCH dir to global plugin paths  
> **66ebff90cd** move some more plugin search path logic to command  
> **8364383c35** Push plugin discovery down into command package  


#### **7.** Кто автор функции `synchronizedWriters`?

- **Команда:** 
```
git log -S 'synchronizedWriters' --oneline
git show 5ac311e2a9 -s --pretty=%an
```

- **Ответ:**<br> 
git log -S 'synchronizedWriters' --oneline - выведет коммиты, в которых есть совпадения с указанно функцией. Забираем самый нижний

> **bdfea50cc8** remove unused
> **fd4f7eb0b9** remove prefixed io
> **5ac311e2a9** main: synchronize writes to VT100-faker on Windows

git show 5ac311e2a9 -s --pretty=%an -  Выведет автора commit
> **Martin Atkins**

---

*В качестве решения ответьте на вопросы и опишите, как были получены эти ответы.*

---

### Правила приёма домашнего задания

В личном кабинете отправлена ссылка на .md-файл в вашем репозитории.

### Критерии оценки

Зачёт:

* выполнены все задания;
* ответы даны в развёрнутой форме;
* приложены соответствующие скриншоты и файлы проекта;
* в выполненных заданиях нет противоречий и нарушения логики.

На доработку:

* задание выполнено частично или не выполнено вообще;
* в логике выполнения заданий есть противоречия и существенные недостатки.
