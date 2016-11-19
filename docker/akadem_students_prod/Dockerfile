FROM mpugach/akadem_students_prod_base:latest
MAINTAINER Maksym Pugach <pugach.m@gmail.com>

WORKDIR /app

RUN apk add git && \
    git clone -b 174_move_dev_to_docker https://github.com/KyivKrishnaAcademy/ved_akadem_students.git . && \
    apk del git
