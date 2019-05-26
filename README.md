[![Build Status](https://travis-ci.com/otus-devops-2019-02/dchirkov_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/dchirkov_microservices)

# dchirkov_microservices

## ДЗ к занятию 18

### Сделано:

* Установлен GitLab в Google Cloud (см. ниже)
* Настроен GitLab
* Подключен новый удаленный GitLab-репозиторий
* Создан CI/CD Pipeline (описан .gitlab-ci.yml)
* Установлен и запущен Runner
* Проведены эксперименты с pipeline

### Установка GitLab

Установка инстанса для GitLab:
```bash
$ gcloud compute addresses create gitlab-ci --region europe-west1
$ docker-machine create --driver google --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts --google-machine-type n1-standard-1 --google-address gitlab-ci --google-tags http-server,https-server --google-zone europe-west1-b gitlab-ci
$ eval $(docker-machine env gitlab-ci)
```

Установка GitLab: 
```bash
$ cd gitlab-ci && docker-compose up -d
```

### Задание со *:

#### Сборка и деплой контейнера
* Устанавливаем хост и все зависимости, где будет размещаться приложение reddit: 

```bash
$ cd gitlab-ci
$ terraform init terraform/
$ terraform apply -var-file=terraform/terraform.tfvars terraform/
$ ansible-playbook playbooks/reddit_req.yml
reddit$ gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
reddit$ curl -sSL https://get.rvm.io | bash -s stable --rails
```

* Делаем коммит в https://github.com/otus-devops-2019-02/dchirkov_microservices.git и в созданный GitLab, 
запускается pipeline со сборкой, тестами и выкаткой в целевой хост reddit.

#### Масштабирование Runners
Лучший способ масштабирования Runners - это создание новых по-требованию (Runners autoscale)
Из-за ограничения времени не все шаги автоматизированы:
* Создан новый инстанс gitlab-runner, который для GitLab будет выступать как бастион, т.е. он будет управлять
запуском новых и удалением неактивных Runner:  
```bash
$ cd gitlab-ci
$ terraform init terraform-runner/
$ terraform apply -var-file=terraform-runner/terraform.tfvars terraform-runner/
```

* На него установлены GitLab Runner, Google Cloud SDK и Docker с docker-machine:
```bash
$ ansible-playbook playbooks/deploy_runner.yml
```

* В созданном инстансе авторизован в Google и зарегистировн Runner:
```bash
gitlab-runners$ gcloud init --console-only
gitlab-runners$ gcloud auth application-default login
gitlab-runners$ gitlab-runner register --non-interactive --url "http://${gitlab_ci_ip}/" --registration-token "${gitlab_installation_token}" --executor "docker+machine" --docker-image alpine:latest --description "autoscaling-runners" --tag-list "docker,linux,ubuntu,xenial" --run-untagged="true" --locked="false"
```

* Отредактирован файл конфигурации /etc/gitlab-runner/config.toml (шаблон находится в gitlab-ci/template/config.toml.j2).
Добавлены/изменены опции:
```
concurrent = 10
...
  [runners.machine]
    IdleCount = 1
    IdleTime = 300
    MachineDriver = "google"
    MachineName = "autoscale-%s"
    MachineOptions = [
        "google-project={{ google_project }}",
        "google-machine-image=https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts",
        "google-machine-type=n1-standard-1",
        "google-zone=europe-west1-b",
        "google-use-internal-ip=true"
    ]
```

* Перезапущен сервис gitlab-runner:
```bash
$ systemctl restart gitlab-runner.service
```

В итоге при запуске stage с 2 job получаем 2 инстанса (и 2 в ожидании):
![stage_with_2_jobs](https://user-images.githubusercontent.com/633539/58326683-3ee46500-7e36-11e9-896a-2a234d892ba6.png)

#### Интеграция со Slack
* Настроена интеграция Gitlab со Slack [dmitry_chirkov](https://devops-team-otus.slack.com/messages/CH12BCSSX/)


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
