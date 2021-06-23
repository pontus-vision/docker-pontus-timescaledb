#!/bin/bash

if [[ ! -d ~/.aws-lambda-rie ]]; then
  mkdir -p ~/.aws-lambda-rie && \
  curl -Lo ~/.aws-lambda-rie/aws-lambda-rie \
    https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie && \
  chmod +x ~/.aws-lambda-rie/aws-lambda-rie               

fi

docker run -d -v ~/.aws-lambda-rie:/aws-lambda -p 9000:8080 \
  --entrypoint /aws-lambda/aws-lambda-rie pontusvisiongdpr/grafana-lambda:1.13.2  /usr/bin/npx aws-lambda-ric dist.index.handler

