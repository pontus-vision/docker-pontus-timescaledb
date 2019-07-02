#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR/timescaledb
docker build --rm . -t pontusvisiongdpr/timescaledb

cd $DIR/postgrest
docker build --rm . -t pontusvisiongdpr/postgrest

docker push pontusvisiongdpr/timescaledb
docker push pontusvisiongdpr/postgrest


