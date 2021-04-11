#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR/timescaledb
docker build --rm . -t pontusvisiongdpr/timescaledb:${TAG}

cd $DIR/postgrest
docker build --build-arg POSTGREST_VERSION=v6.0.0  --rm . -t pontusvisiongdpr/postgrest:${TAG}

export GIT_SHA=$(git rev-parse --verify HEAD)

export  FORCE_REACT_PANEL=$(git rev-parse --verify HEAD)
cd $DIR/grafana
cat Dockerfile.template | envsubst > Dockerfile
docker build --build-arg FORCE_REACT_PANEL=${FORCE_REACT_PANEL}  --rm . -t pontusvisiongdpr/grafana:${TAG}

cd $DIR/grafana-pt
cat Dockerfile.template | envsubst > Dockerfile
docker build   --rm . -t pontusvisiongdpr/grafana-pt:${TAG}

cd $DIR

export LAST_GIT_SHA=$(cat ./last_git_sha)
if [[ ${GIT_SHA} != ${LAST_GIT_SHA} ]]; then
  echo ${GIT_SHA} > ./last_git_sha;
  docker scan pontusvisiongdpr/grafana:${TAG}  --severity high
  docker scan pontusvisiongdpr/grafana-pt:${TAG}  --severity high
  docker scan pontusvisiongdpr/timescaledb:${TAG}  --severity high
  docker scan pontusvisiongdpr/postgrest:${TAG} --severity high
fi

docker push pontusvisiongdpr/timescaledb:${TAG}
docker push pontusvisiongdpr/postgrest:${TAG}
docker push pontusvisiongdpr/grafana:${TAG}
docker push pontusvisiongdpr/grafana-pt:${TAG}


