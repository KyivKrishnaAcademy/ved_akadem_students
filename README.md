# Academy Students

[![Build Status](https://secure.travis-ci.org/KyivKrishnaAcademy/ved_akadem_students.png?branch=master)](https://travis-ci.org/KyivKrishnaAcademy/ved_akadem_students)
[![Code Climate](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/gpa.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)
[![Test Coverage](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students/badges/coverage.svg)](https://codeclimate.com/github/KyivKrishnaAcademy/ved_akadem_students)

Developed specially for [Kyiv Spiritual Academy of Krishna Consciousness in Ukraine](http://veda-kiev.org.ua/) and [ISKCON](http://iskcon.com/).

## System dependencies
* postgresql libpq-dev
* imagemagick
* redis
* bower

nice to have:
* rvm

## Project setup

```bash
cp config/database.yml.template config/database.yml
bundle install
```

## Git workflow

You should have 2 repositories: **origin** (your fork) and **upstream** (main repository)

0. fork repository
1. git clone git@github.com:you/project.git
2. git remote add upstream git@github.com:our/project.git
3. git checkout master
4. git pull upstream master
5. git checkout -b my-important-feature
6. Work on your feature
7. git add .
8. git commit -m '[issue_number_here] My commit detailed message'
9. git push origin my-important-feature
10. send Pull Request at github
11. Checkout back to master, pull upstream, create new branch
