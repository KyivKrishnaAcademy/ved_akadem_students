# Academy Students

[![Build Status](https://secure.travis-ci.org/KyivKrishnaAcademy/ved_akadem_students.png?branch=master)](https://travis-ci.org/KyivKrishnaAcademy/ved_akadem_students)
[![Code Climate](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/gpa.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)
[![Test Coverage](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/coverage.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)

Developed specially for [Kyiv Spiritual Academy of Krishna Consciousness in Ukraine](http://veda-kiev.org.ua/) and [ISKCON](http://iskcon.com/).

## System dependencies

There are two ways to setup the application, you can choose whatever suits you.

If you have enough technical skill, then we advice you to install all the software to your host OS for development.

If you not so pro or your hos OS is MS Windows, then please choose the Docker way.

### Host OS way
#### General dependencies

* imagemagick >= 6.7.7-10
* node >= 5.5.0
* postgresql >= 9.4
* redis >= 2.8.0
* ruby >= 2.1.5

#### Develpment dependencies

* phantomjs >= 2.0.0

#### Nice to have

* rvm
* nvm

#### Project setup

* Install system packages
* Install gems
* Install node packages
* Start PostgreSQL
* Edit `database.yml`
* Init DB

```bash
bundle install
npm install

cp config/database.yml.template config/database.yml
vi config/database.yml
bundle exec rake db:create
bundle exec rake db:structure:load
bundle exec rake db:seed
```

#### Run the app locally

* Start PostgreSQL
* Start Redis
* Start webserver `npm run rails-server`
* Type `http://localhost:3000` in your browser (default credentials are ```admin@example.com/password```)

### Docker way
#### General dependencies

* docker
* docker-compose

OR

* Docker Toolbox
* VirtualBox

It depends whether your OS and hardware are capable to run native Docker

#### Project setup & run the app locally
##### Native Docker
* Run `docker-compose up`
* Wait for images are downloaded, containers are created and launched, all software is installed inside the containers and all services are started
* Type `http://localhost:3000` in your browser (default credentials are ```admin@example.com/password```)

##### Docker Toolbox
* Run `bin/docker_toolbox_prepare.sh` in case of MS Windows you have to investigate the script and run similar commands in CLI
* Run `docker-compose up`
* Wait for images are downloaded, containers are created and launched, all software is installed inside the containers and all services are started
* Type `http://your-docker-machine-ip:3000` in your browser (default credentials are ```admin@example.com/password```)

## Contribution guide

You should have 2 remote repositories: **origin** (your fork) and **upstream** (main repository)

1. Fork repository using GitHub
2. ```git clone git@github.com:you/project.git```
3. ```git remote add upstream git@github.com:KyivKrishnaAcademy/ved_akadem_students.git```
4. ```git checkout master```
5. ```git pull upstream master```
6. Check issue tracker for assigned tickets
7. ```git checkout -b my_important_feature_or_bugfix```
8. Work on your feature
9. Run tests ```npm run test```
10. ```git add .```
11. ```git commit -m '[issue_number_here] My commit detailed message'```
12. ```git push origin my-important-feature```
13. Send Pull Request at GitHub
14. Goto 4

## Deploy

0. `bin/build_image_prod.sh`
1. `docker-compose exec application bash`
2. `eval "$(ssh-agent -s)"`
3. `ssh-keygen -t rsa -b 4096 -C "deployer@docker.local"`
4. `ssh-add ~/.ssh/id_rsa`
5. `ssh-copy-id deployer@students.veda-kiev.org.ua`
6. `bundle exec cap deploy`

## Links

1. Deployed project http://students.veda-kiev.org.ua
2. Issue tracker for contributors https://github.com/KyivKrishnaAcademy/ved_akadem_students/issues
3. Wiki https://github.com/KyivKrishnaAcademy/ved_akadem_students/wiki
