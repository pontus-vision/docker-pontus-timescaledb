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

ENV PV_LOCAL_COMMAND=/run.sh
ENV PV_LOCAL_ARGS=[]
USER grafana
COPY --chown=grafana:grafana --from=pontusvisiongdpr/pontus-lambda-wrapper:1.13.2 /function /function

COPY --chown=grafana:grafana grafana.ini.noauth /etc/grafana/grafana.ini

WORKDIR /function
ENTRYPOINT ["/usr/local/bin/npx", "aws-lambda-ric"]
CMD ["dist/index.handler"]



