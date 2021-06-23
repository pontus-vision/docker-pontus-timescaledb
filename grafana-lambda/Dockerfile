#FROM grafana/grafana:6.6.2-ubuntu
#FROM grafana/grafana:7.1.0-ubuntu
#FROM grafana/grafana:7.3.7-ubuntu
#FROM grafana/grafana:7.4.3-ubuntu

FROM node:14-buster as build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR="/function"

# Install aws-lambda-cpp build dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

# Copy function code
RUN mkdir -p /function
COPY lambda-grafana-wrapper/* /function

WORKDIR /function

# If the dependency is not in package.json uncomment the following line
# RUN npm install aws-lambda-ric

RUN npm install && \
    npm run build

# Grab a fresh slim copy of the image to reduce the final size
FROM pontusvisiongdpr/grafana:1.13.2 as final


# Include global arg in this stage of the build
ARG FUNCTION_DIR="/function"
ENV FUNCTION_DIR="/function"

# Set working directory to function root directory

# Copy in the built dependencies

USER root
WORKDIR /tmp
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh && \
    chmod 755 nodesource_setup.sh &&\
    ./nodesource_setup.sh &&\
    apt install nodejs

USER grafana
COPY --chown=grafana:grafana --from=build-image /function /function

WORKDIR /function
ENTRYPOINT ["/usr/local/bin/npx", "aws-lambda-ric"]
CMD ["dist.lib.index.handler"]




