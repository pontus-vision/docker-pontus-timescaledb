#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR
docker build --rm . -t pontusvisiongdpr/timescaledb

docker push pontusvisiongdpr/timescaledb


