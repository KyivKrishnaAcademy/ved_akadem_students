#!/usr/bin/env bash

WORKDIR=$(basename `pwd`)

docker-machine ssh "$DOCKER_MACHINE_NAME" "mkdir $WORKDIR"

VOL_DIR=$(docker-machine ssh "$DOCKER_MACHINE_NAME" "cd \"$WORKDIR\" && pwd")

vboxmanage sharedfolder add "$DOCKER_MACHINE_NAME" --name "$WORKDIR" --hostpath "`pwd`" --transient
vboxmanage setextradata "$DOCKER_MACHINE_NAME" VBoxIntdefaultSharedFoldersEnableSymlinksCreate/$WORKDIR 1

docker-machine ssh "$DOCKER_MACHINE_NAME" "sudo mount -t vboxsf -o uid=1008,gid=1008 \"$WORKDIR\" \"$VOL_DIR\""

echo "http://$(docker-machine ip "$DOCKER_MACHINE_NAME"):3000"
