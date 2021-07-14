#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e
DIR="$( cd "$(dirname "$0")" ; pwd -P )"

export DOCKER_SHA=$(docker images --no-trunc --quiet pontusvisiongdpr/pontus-grafana-react-panel:${TAG})

export DOLLAR='$'
export  FORCE_REACT_PANEL=${DOCKER_SHA}
cd $DIR/grafana-lambda

cat Dockerfile.template | envsubst > Dockerfile

docker build \
    --build-arg FUNCTION_DIR='/function' \
    --build-arg FORCE_REACT_PANEL=${FORCE_REACT_PANEL}  \
    --rm . -t pontusvisiongdpr/pontus-comply-grafana-lambda:${TAG}


if [[ -z $FORMITI_DEV_ACCOUNT ]]; then

  export LAST_DOCKER_SHA=$(cat ./last_docker_sha)
  if [[ ${DOCKER_SHA} != ${LAST_DOCKER_SHA} ]]; then
    echo ${DOCKER_SHA} > ./last_docker_sha;
    docker scan pontusvisiongdpr/pontus-comply-grafana-lambda:${TAG} --severity high
  fi

  docker push pontusvisiongdpr/pontus-comply-grafana-lambda:${TAG}
else
  if [[ $(aws --version 2>&1 ) == "aws-cli/1"* ]] ; then
    $(aws ecr get-login --no-include-email --region eu-west-2)
  else
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com
  fi

  TIMESTAMP=$(date +%y%m%d_%H%M%S)
  docker tag pontusvisiongdpr/pontus-comply-grafana-lambda:${TAG} ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-grafana-lambda:${TAG}
  docker push ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-grafana-lambda:${TAG}
  IMAGE_SHA=$(aws ecr describe-images --repository-name pontus-comply-grafana-lambda --image-ids imageTag=${TAG} | jq -r '.imageDetails[0].imageDigest')
  aws lambda update-function-code --function-name grafana  --image-uri 558029316991.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-grafana-lambda@${IMAGE_SHA}

fi



