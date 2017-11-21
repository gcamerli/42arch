#!/bin/sh
# ./remove.sh

docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
