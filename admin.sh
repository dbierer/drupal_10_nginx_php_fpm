#!/bin/bash
. ./Docker/secrets.sh
DIR=`pwd`
export USAGE="Usage: admin.sh up|down|build|init|backup|shell|ls [--show]"
if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
fi
if [[ "$1" = "up" || "$1" = "start" ]]; then
    if [[ -f "$2" && "$2" = "--show" ]]; then
        docker-compose up
    else
        docker-compose up -d
    fi
    docker exec $CONTAINER /bin/bash -c "/etc/init.d/mysql start"
    docker exec $CONTAINER /bin/bash -c "/tmp/restore.sh"
    docker exec $CONTAINER /bin/bash -c "/etc/init.d/nginx reload"
elif [[ "$1" = "down" || "$1" = "stop" ]]; then
    docker exec $CONTAINER /bin/bash -c "/etc/init.d/mysql start"
    docker exec $CONTAINER /bin/bash -c "/tmp/backup.sh"
    docker-compose down
    sudo chown -R $USER:$USER *
elif [[ "$1" = "ls" ]]; then
    docker container ls
elif [[ "$1" = "build" ]]; then
    docker-compose build
elif [[ "$1" = "backup" ]]; then
    docker exec $CONTAINER /bin/bash -c "/tmp/backup.sh"
elif [[ "$1" = "init" ]]; then
    if [[ -z ${CONTAINER} ]]; then
        echo "Unable to locate running container"
    else
        docker exec $CONTAINER /bin/bash -c "/etc/init.d/mysql start"
        docker exec $CONTAINER /bin/bash -c "/tmp/restore.sh"
        docker exec $CONTAINER /bin/bash -c "/etc/init.d/nginx reload"
    fi
elif [[ "$1" = "shell" ]]; then
    if [[ -z ${CONTAINER} ]]; then
        echo "Unable to locate running container: $CONTAINER"
    else
        docker exec -it $CONTAINER /bin/bash
    fi
else
    echo $USAGE
    exit 1
fi
