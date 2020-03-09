FROM grafana/grafana:6.6.2-ubuntu
USER root
RUN ln -s /usr/share/grafana/public /usr/share/grafana/grafana && \
    apt-get update -y && apt install -y netcat

   
USER grafana
RUN grafana-cli plugins install agenty-flowcharting-panel
RUN grafana-cli plugins install simpod-json-datasource
COPY --chown=grafana:grafana grafana.db /var/lib/grafana/
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana-pontus.ini

EXPOSE 3000
COPY --chown=grafana:grafana --from=pontusvisiongdpr/pontus-grafana-react-panel:latest /var/lib/grafana/plugins/grafana/pontus-panel/ /var/lib/grafana/plugins/grafana/pontus-panel/
#COPY --chown=grafana:grafana --from=pontusvisiongdpr/pontus-grafana-orientdb-datasource:latest /grafana-orientdb-plugin/dist /var/lib/grafana/plugins/grafana/pontus-grafana-orientdb-datasource/
#COPY --chown=grafana:grafana ./algenty-grafana-flowcharting-0.6.0-6-gfee0569.zip /var/lib/grafana/plugins/grafana/
#USER root
#RUN cd  /var/lib/grafana/plugins/grafana/ && unzip /var/lib/grafana/plugins/grafana/algenty-grafana-flowcharting-0.6.0-6-gfee0569.zip
USER grafana
