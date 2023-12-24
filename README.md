# Academy Students

[![Build Status](https://secure.travis-ci.org/KyivKrishnaAcademy/ved_akadem_students.png?branch=master)](https://travis-ci.org/KyivKrishnaAcademy/ved_akadem_students)
[![Code Climate](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/gpa.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)
[![Test Coverage](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/coverage.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)

Developed specially for [Kyiv Spiritual Academy of Krishna Consciousness in Ukraine](http://veda-kiev.org.ua/) and [ISKCON](http://iskcon.com/).

## Run development environment

* Run `docker compose up`
* Wait for images are downloaded, containers are created and launched, all software is installed inside the containers and all services are started
* Type `http://localhost:3000` in your browser (default credentials are ```admin@example.com/password```)
* Ude VSCode to [develop inside the container](https://code.visualstudio.com/docs/remote/containers)
    * attach to `students_crm_v1-app-1` container
    * open `/home/app/students_crm` folder

## Restore production backup locally

* Run `docker volume rm students_crm_v1_postgres-data`
* Run `docker compose up postgres -d`
* Run `docker compose cp [PATH TO BACKUP] postgres:/backup`
* Run `docker compose exec postgres pg_restore -d va_db -O -j 20 -c /backup/db -U postgres`
* Run `docker compose down`
* Run `rm -rf uploads`
* Run `tar -xzf [PATH TO BACKUP]/uploads.tar.gz -C .`

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
9. Setup PhantomJS ```source bin/setup_phantomjs.sh```
10. Run tests ```npm run test```
11. ```git add .```
12. ```git commit -m '[issue_number_here] My commit detailed message'```
13. ```git push origin my-important-feature```
14. Send Pull Request at GitHub
15. Goto 4

## Deploy

0. `bin/build_image_prod.sh`
1. `docker compose exec app bash`
2. `eval "$(ssh-agent -s)"`
3. `ssh-keygen -t rsa -b 4096 -C "deployer@docker.local"`
4. `ssh-add ~/.ssh/id_rsa`
5. `ssh-copy-id deployer@students.veda-kiev.org.ua`
6. `bundle exec cap deploy`

## Links

1. Deployed project http://students.veda-kiev.org.ua
2. Issue tracker for contributors https://github.com/KyivKrishnaAcademy/ved_akadem_students/issues
3. Wiki https://github.com/KyivKrishnaAcademy/ved_akadem_students/wiki
