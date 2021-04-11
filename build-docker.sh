#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR/timescaledb
docker build --rm . -t pontusvisiongdpr/timescaledb:${TAG}

cd $DIR/postgrest
docker build --build-arg POSTGREST_VERSION=v6.0.0  --rm . -t pontusvisiongdpr/postgrest:${TAG}

cd $DIR/grafana
cat Dockerfile.template | envsubst > Dockerfile
docker build   --rm . -t pontusvisiongdpr/grafana:${TAG}

cd $DIR/grafana-pt
cat Dockerfile.template | envsubst > Dockerfile
docker build   --rm . -t pontusvisiongdpr/grafana-pt:${TAG}

cd $DIR

#docker scan pontusvisiongdpr/grafana  --severity high
#docker scan pontusvisiongdpr/grafana-pt  --severity high
docker scan pontusvisiongdpr/timescaledb  --severity high
docker scan pontusvisiongdpr/postgrest --severity high
docker push pontusvisiongdpr/timescaledb
docker push pontusvisiongdpr/postgrest
docker push pontusvisiongdpr/grafana
docker push pontusvisiongdpr/grafana-pt


