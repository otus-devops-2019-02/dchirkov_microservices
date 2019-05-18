[![Build Status](https://travis-ci.com/otus-devops-2019-02/dchirkov_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/dchirkov_microservices)

# dchirkov_microservices

## ДЗ к занятию 17

### Сделано:

* Проведены эксперименты с разными типами сетей в Docker
* Сделан микросервис с двумя сетями
* Собраны образы и запущены контейнеры с помощью docker-compose
* Параметризированы порт сервиса, версии и путь к БД

### Изменение базового имени проекта

Изменить проект можно двумя путями:
1. Задать переменную окружения COMPOSE_PROJECT_NAME

   Например:
   ```bash
   $ export COMPOSE_PROJECT_NAME=reddit
   ```
2. С запуском docker-compose с опцией -p

   Например:
   ```bash
   $ docker-compose -p reddit up -d
   ```

### Задание со *:

Изменять код приложения без пересборки образа можно монтированием хостовой директории к контейнеру.
Для этого скопируем git-репозиторий на хостовую машину:
```bash
docker-host$ git clone -b docker-4 https://github.com/otus-devops-2019-02/dchirkov_microservices.git
```
В файле docker-compose.override.yml для каждого сервиса укажем:
```
ui:
  volumes:
    - /home/docker-user/dchirkov_microservices/src/ui:/app
post:
  volumes:
    - /home/docker-user/dchirkov_microservices/src/post-py:/app
comment:
  volumes:
    - /home/docker-user/dchirkov_microservices/src/comment:/app
```

Для переопределения запускаемой команды в контейнере ui нужно в docker-compose.override.yml указать:
```
ui:
  command: puma --debug -w 2
```

## ДЗ к занятию 16

### Сделано:

* Описаны 3 Dockerfile для трёх микросервисов: post, ui и comment
* Создана сеть reddit типа bridge
* Образ ui оптимизирован
* К микросервису mongo подключен том reddit_db
```bash
$ docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest
```

### Задание со *:

* Запущены контейнеры с другими сетевыми алиасами. Окружение в контейнере переопределено опцией "-e":
```bash
$ docker run -d --network=reddit --network-alias=new_post_db --network-alias=new_comment_db mongo:latest
$ docker run -d --network=reddit --network-alias=new_post -e POST_DATABASE_HOST=new_post_db daryan/post:1.0
$ docker run -d --network=reddit --network-alias=new_comment -e COMMENT_DATABASE_HOST=new_comment_db daryan/comment:1.0
$ docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=new_post -e COMMENT_SERVICE_HOST=new_comment daryan/ui:1.0
```
* Все микросервисы пересобраны на основе адаптированных дистрибутивов alpine

## ДЗ к занятию 15

Сделано:

* Создан новый проект docker
* Создан docker-host в gcloud
* Создан Dockerfile для построения образа нашего приложения 
* Полученный образ залит на Docker Hub 

Команды 
```bash
docker run --rm -ti tehbilly/htop
docker run --rm --pid host -ti tehbilly/htop
```
показывают разную видимость PID 

### Задание со *

* с помощью Terraform создаётся нужное количество инстансов, указанное в terraform.tfvars
```bash
$ cd docker-monolith/infra
$ terraform apply -var-file=terraform/terraform.tfvars terraform/
```

* с помощью плейбуков Ansible и использованием динамического инвентори устанавливается докер и наше приложение
```bash
$ ansible-playbook playbooks/reddit.yml
```

* описан шаблон пакера, который делает образ с уже установленным Docker и нашим приложением
```bash
$ packer build -var-file=packer/variables.json packer/reddit.json
```


## ДЗ к занятию 14

Сделано:

* Установлен Docker 
* Описано отличие образа от контейнера
