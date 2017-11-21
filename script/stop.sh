#!/bin/sh
# ./stop.sh

docker stop -t 1 42arch
docker rm 42arch
