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
    apt upgrade -y &&\
    apt install nodejs

ENV PV_LOCAL_COMMAND=/etc/grafana/entrypoint.sh
ENV GF_PATHS_DATA=/mnt/grafana
ENV PV_LOCAL_ARGS="[]"
ENV PV_EXT_DOMAIN=test1.formiti-demo.pontusvision.com
ENV PV_CLIENT_SECRET=91fff12e-9b97-4028-8705-ffd8126fba3f

RUN echo 1.13.2
COPY --chown=grafana:grafana  --from=pontusvisiongdpr/pontus-lambda-wrapper:1.13.2 /function /function

COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana entrypoint.sh /etc/grafana/entrypoint.sh
RUN chmod 755 /etc/grafana/entrypoint.sh  /run.sh

USER grafana


WORKDIR /function
ENTRYPOINT ["/usr/bin/npx", "aws-lambda-ric"]
CMD ["dist/index.handler"]




