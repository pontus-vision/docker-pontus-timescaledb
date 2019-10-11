#!/bin/bash
set -e
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR/timescaledb
docker build --rm . -t pontusvisiongdpr/timescaledb

cd $DIR/postgrest
docker build --build-arg POSTGREST_VERSION=v6.0.0  --rm . -t pontusvisiongdpr/postgrest

cd $DIR/grafana
docker build   --rm . -t pontusvisiongdpr/grafana

cd $DIR/grafana-pt
docker build   --rm . -t pontusvisiongdpr/grafana-pt

docker push pontusvisiongdpr/timescaledb
docker push pontusvisiongdpr/postgrest
docker push pontusvisiongdpr/grafana
docker push pontusvisiongdpr/grafana-pt


