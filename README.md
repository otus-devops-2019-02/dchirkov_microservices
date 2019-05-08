[![Build Status](https://travis-ci.com/otus-devops-2019-02/dchirkov_microservices.svg?branch=master)](https://travis-ci.com/otus-devops-2019-02/dchirkov_microservices)

# dchirkov_microservices

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
