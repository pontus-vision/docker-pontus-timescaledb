#!/bin/bash

export TAG=${TAG:-1.13.2}
set -e
DIR="$( cd "$(dirname "$0")" ; pwd -P )"


export DOLLAR='$'
cd $DIR/influxdb-lambda

cat Dockerfile.template | envsubst > Dockerfile

docker build \
    --build-arg FUNCTION_DIR='/function' \
    --rm . -t pontusvisiongdpr/pontus-comply-influxdb-lambda:${TAG}


if [[ -z $FORMITI_DEV_ACCOUNT ]]; then

  export LAST_DOCKER_SHA=$(cat ./last_docker_sha)

  docker push pontusvisiongdpr/pontus-comply-influxdb-lambda:${TAG}
else
  if [[ $(aws --version 2>&1 ) == "aws-cli/1"* ]] ; then
    $(aws ecr get-login --no-include-email --region eu-west-2)
  else
    aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com
  fi

  TIMESTAMP=$(date +%y%m%d_%H%M%S)
  docker tag pontusvisiongdpr/pontus-comply-influxdb-lambda:${TAG} ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-influxdb-lambda:${TAG}
  docker push ${FORMITI_DEV_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-influxdb-lambda:${TAG}
  IMAGE_SHA=$(aws ecr describe-images --repository-name pontus-comply-influxdb-lambda --image-ids imageTag=${TAG} | jq -r '.imageDetails[0].imageDigest')
  aws lambda update-function-code --function-name influxdb  --image-uri 558029316991.dkr.ecr.eu-west-2.amazonaws.com/pontus-comply-influxdb-lambda@${IMAGE_SHA}

fi



