# Academy Students

[![Build Status](https://secure.travis-ci.org/KyivKrishnaAcademy/ved_akadem_students.png?branch=master)](https://travis-ci.org/KyivKrishnaAcademy/ved_akadem_students)
[![Code Climate](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/gpa.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)
[![Test Coverage](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/coverage.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)

Developed specially for [Kyiv Spiritual Academy of Krishna Consciousness in Ukraine](http://veda-kiev.org.ua/) and [ISKCON](http://iskcon.com/).

## System dependencies
* imagemagick >= 6.7.7-10
* node >= 5.5.0
* postgresql >= 9.4
* redis >= 2.8.0
* ruby >= 2.1.5

### Develpment dependencies
* phantomjs >= 2.0.0

### Nice to have
* rvm
* nvm

## Project setup

* Install system dependencies
* Start PostgreSQL
* Init DB:
```bash
cp config/database.yml.template config/database.yml
bundle install
bundle exec rake db:create
bundle exec rake db:structure:load
bundle exec rake db:seed
```
* Install node packages
```bash
npm install
```

## Run the app locally

Start PostgreSQL and Redis

```node run rails-server``` to start webserver

Type ```http://localhost:3000``` in your browser

Default credentials ```admin@example.com/password```

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
9. Run tests ```node run test```
10. ```git add .```
11. ```git commit -m '[issue_number_here] My commit detailed message'```
12. ```git push origin my-important-feature```
13. Send Pull Request at GitHub
14. Goto 4

## Links

1. Deployed project http://students.veda-kiev.org.ua
2. Issue tracker for contributors http://redmine.mpugach.net/projects/akadem_students
3. Wiki https://github.com/KyivKrishnaAcademy/ved_akadem_students/wiki
