FROM mpugach/akadem_students_prod_base:latest
MAINTAINER Maksym Pugach <pugach.m@gmail.com>

WORKDIR /app

RUN apk add git && \
    git clone -b master https://github.com/KyivKrishnaAcademy/ved_akadem_students.git . && \
    apk del git
