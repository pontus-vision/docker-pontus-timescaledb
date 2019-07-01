#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd $DIR/timescaledb
docker build --rm . -t pontusvisiongdpr/timescaledb
docker push pontusvisiongdpr/timescaledb




