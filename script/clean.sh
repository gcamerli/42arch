#!/bin/sh
# ./clean.sh

docker rm $(docker ps -aq)
