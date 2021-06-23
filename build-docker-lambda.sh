#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

export DOCKER_SHA=$(docker images --no-trunc --quiet pontusvisiongdpr/pontus-grafana-react-panel:${TAG})

export  FORCE_REACT_PANEL=${DOCKER_SHA}
cd $DIR/grafana-lambda
cat Dockerfile.template | envsubst > Dockerfile
docker build \
    --build-arg FUNCTION_DIR='/function' \
    --build-arg FORCE_REACT_PANEL=${FORCE_REACT_PANEL}  \
    --rm . -t pontusvisiongdpr/grafana-lambda:${TAG}

cd $DIR

exit 0

export LAST_DOCKER_SHA=$(cat ./last_docker_sha)
if [[ ${DOCKER_SHA} != ${LAST_DOCKER_SHA} ]]; then
  echo ${DOCKER_SHA} > ./last_docker_sha;
  docker scan pontusvisiongdpr/grafana:${TAG}  --severity high
  docker scan pontusvisiongdpr/grafana-pt:${TAG}  --severity high
  docker scan pontusvisiongdpr/timescaledb:${TAG}  --severity high
  docker scan pontusvisiongdpr/postgrest:${TAG} --severity high
fi

docker push pontusvisiongdpr/timescaledb:${TAG}
docker push pontusvisiongdpr/postgrest:${TAG}
docker push pontusvisiongdpr/grafana:${TAG}
docker push pontusvisiongdpr/grafana-pt:${TAG}


