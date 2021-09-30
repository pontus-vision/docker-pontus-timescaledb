#FROM grafana/grafana:6.6.2-ubuntu
#FROM grafana/grafana:7.1.0-ubuntu
#FROM grafana/grafana:7.3.7-ubuntu
#FROM grafana/grafana:7.4.3-ubuntu
FROM grafana/grafana:7.5.3-ubuntu
USER root
RUN ln -s /usr/share/grafana/public /usr/share/grafana/grafana && \
    apt update && \
    apt upgrade -y && \
    apt install -y netcat-traditional && \
    echo force

   
USER grafana
RUN grafana-cli plugins install agenty-flowcharting-panel
RUN grafana-cli plugins install simpod-json-datasource
RUN grafana-cli plugins install yesoreyeram-boomtheme-panel
RUN grafana-cli plugins install grafana-timestream-datasource
COPY --chown=grafana:grafana grafana.db /var/lib/grafana/
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana-pontus.ini

EXPOSE 3000

ARG FORCE_REACT_PANEL=4 
ENV FORCE_REACT_PANEL=sha256:0f28a3c851b4a53e8581ae4056f37615d1319837adb2196be905a98928951b2e
RUN echo sha256:0f28a3c851b4a53e8581ae4056f37615d1319837adb2196be905a98928951b2e
COPY  --chown=grafana:grafana  --from=pontusvisiongdpr/pontus-grafana-react-panel:1.13.2  /var/lib/grafana/plugins/grafana/pontus-panel/ /var/lib/grafana/plugins/grafana/pontus-panel/
#COPY --chown=grafana:grafana --from=pontusvisiongdpr/pontus-grafana-orientdb-datasource:latest /grafana-orientdb-plugin/dist /var/lib/grafana/plugins/grafana/pontus-grafana-orientdb-datasource/
#COPY --chown=grafana:grafana ./algenty-grafana-flowcharting-0.6.0-6-gfee0569.zip /var/lib/grafana/plugins/grafana/
#USER root
#RUN cd  /var/lib/grafana/plugins/grafana/ && unzip /var/lib/grafana/plugins/grafana/algenty-grafana-flowcharting-0.6.0-6-gfee0569.zip
USER grafana
