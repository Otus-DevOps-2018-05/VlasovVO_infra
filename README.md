VlasovVO build status:

[![Build Status](https://travis-ci.com/Otus-DevOps-2018-05/VlasovVO_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2018-05/VlasovVO_infra)

bastion_IP = 35.204.11.162

someinternalhost_IP = 10.164.0.3
```
gcloud compute instances create reddit-app-2 \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script= /mnt/c/users/user/documents/otus/task\ 4/vlasovvo_infra/startup-script.sh
```
```
gcloud compute firewall-rules create default-puma-server\
 --rules=tcp:9393 \
 --source-ranges=0.0.0.0/0 \
 --target-tags=puma-server
```
testapp_IP= 35.204.231.87

testapp_port = 9292

## HW#5

Выполнены основные задания и со *

## HW#6

### Задание со * :

 - Может быть только 1 **google_compute_project_metadata_item** c ключем **ssh-keys**. В противном случае значения будут перезаписывать друг друга.
 - Написание :\
 ```
   resource "google_compute_project_metadata_item" "add_many_user" {\
   count = 4\
   key = "ssh-keys"\
   value = "appuser-${count.index + 1}:${file("\~/.ssh/appuser.pub")}\
 ```
  Не эквивалентно:\
  ```
   resource "google_compute_project_metadata_item" "add_many_user" {\
   key = "ssh-keys"\
   value = "appuser1:${file("\~/.ssh/appuser.pub")}appuser2:${file(\~/.ssh/appuser.pub")}appuser3:${file("\~/.ssh/appuser.pub")}appuser4:${file("\~/.ssh/appuser.pub")}"\
  ```
  В первом случае создается 4 **google_compute_project_metadata_item**, которые перезаписывают друг друга.
 - При добавлении ssh ключа через web интерфейс и выполнении команды **terraform** **apply** ssh ключ будет удален, т.к. его описание не описано в файле **main.tf**
### Заданиие ** :
 В обоих инстансах своя БД

## HW#7

### Задание со *:

 - При одновременном вызове команд terraform второе выполнение блокируется и возвращается данная ошибка:

 >Error: Error locking state: Error acquiring the state lock: writing "gs://storage-bucket-vvo1/terraform/stage/default.tflock" failed: googleapi: Error 412: Precondition Failed, conditionNotMet
 - Не теста ради, по случайности потерялось интернет соединение при выполнении команды **terraform** **apply**. В итоге не выполнившись до конца команда в GCS остался lock файл, который не позволял что либо сделать. Лечилось ручным удалением инстансов и ресурсов в GCP, повторным выполнением **terraform** **apply** c флагом **lock=false** и удалнием lock файла из GCS. 

## HW#8

### Основное задание:

  Обьяснение ситуации с выполнение playbook-а до удаление каталога и после:

  - Первый вариант возвращал что команда выполнена но изменений не было
  
  - Второй вариант так как каталог был удален, репозиторий был склонирован и результат playbook-а отразил что были внесены изменения на целевой сервер.

### Задание со *:

- ansible all -m ping *использует файл динамической инвентаризации прописанный в конфигурационном файле ansible.

## HW#9

В качестве dinamic inventory использовал gce.py. Для настройки его используется файл gce.ini в котором указывается service account (Создается в разделе **IAM & admin > service account**) и Json файл с Service account key(Создается и скачивается в разделе **APIs & Services > Credentials**)

## HW#10

Основное задание:

- Перенесли созданные плейбуки в роли
- Создали отдельные окружения
- Подключили компьюнити роль nginx 

Задание * (Использование динамического inventory для prod и Stage окружений):

- В каждом окружении добавили файлы **gce.ini** и **gce.py**. Внесли свои параметры в файл ini
- Json ключ можно хранить вне репозитория и ссылаться на него, что бы не закоммитить

Задание ** (Настройка travis.yml):

- Добавлены travis тесты:

> packer validate - all\
> terraform validate, tflint - prod,stage\
> ansible-lint - all playbooks

- Добавлен статус билда в README.md

## HW#11

###Основное задание (настройка Vagrant):

- Установили Vagrant, использовали Virtual Box в качестве провайдера.

Для корректного запуска VM на WSL отключается серийный порт: 
> v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
Без данного параметра VM не запустится

- Доработали Ansible роли для подключения их в Vagrant

###Доп. задание Nginx:

Для корректной работы nginx необходимо скорректировать файл roles\app\vars\main.yml добавив строки:
```
nginx_sites:
  default:
    - listen 80
    - server_name reddit
    - |
      location / {
        proxy_pass http://127.0.0.1:9292;
      }
```
### Основное задание (Molecule and Testinfra)

- Устанавливаем molecule, testinfra, python-vagrant
- Добавляем тесты, используя Testinfra
- В файле конфигурации VM для запуска в WSL добавляем строки:
  ```
  platforms:
    - name: instance
      box: ubuntu/xenial64
      provider_raw_config_args: 
      - "customize [ 'modifyvm', :id, '--uartmode1', 'disconnected' ]"
  ```
- Вносим изменения в playbook.yml, прогоняем тест
- Добавляем тест на проверку порта 27017:
  ```
  def test_mongo_listen_port(host):
    assert host.socket("tcp://0.0.0.0:27017").is_listening
  ```
- Исправляем **packer_app.yml** и **packer_db.yml** для запуска с помощью ролей app и db соотвественно.
  Так же вносим изменения в шаблоны packer указывая теги и ссылку на роли:
  ```
  "extra_arguments": ["--tags", "ruby"],
  "ansible_env_vars": ["ANSIBLE_ROLES_PATH={{ pwd }}/ansible/roles"]
  ```
### Задание со * (Вынесение роли DB)

- Выносим роль в отдельный репозиторий:
  https://github.com/VlasovVO/DevOps_role_db
  Подключаем репу в оба окружения в файле requirements.txt:
  ```
  - src: git+https://github.com/VlasovVO/DevOps_role_db
  version: master
  name: db
  scm: git
  ```
- Подключаем Travis, вносим изменения в molecule.yml для запуска в GCE
- Добавил оповещения Travis в Slack по новой репе
