#FROM grafana/grafana:6.6.2-ubuntu
#FROM grafana/grafana:7.1.0-ubuntu
#FROM grafana/grafana:7.3.7-ubuntu
#FROM grafana/grafana:7.4.3-ubuntu
FROM grafana/grafana:7.5.3-ubuntu
USER root
RUN ln -s /usr/share/grafana/public /usr/share/grafana/grafana && \
    apt update && \
    apt upgrade -y && \
    apt install -y netcat-traditional

   
USER grafana
RUN grafana-cli plugins install agenty-flowcharting-panel
RUN grafana-cli plugins install simpod-json-datasource
COPY --chown=grafana:grafana grafana.db /var/lib/grafana/
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana-pontus.ini

EXPOSE 3000

ARG FORCE_REACT_PANEL=1 
ENV FORCE_REACT_PANEL=sha256:13656bf5962b04539ae5d0a458b7a8a76a94e1eed0c7a138e1f2be7f686fd0d1
RUN echo sha256:13656bf5962b04539ae5d0a458b7a8a76a94e1eed0c7a138e1f2be7f686fd0d1
COPY  --chown=grafana:grafana  --from=pontusvisiongdpr/pontus-grafana-react-panel:1.13.2  /var/lib/grafana/plugins/grafana/pontus-panel/ /var/lib/grafana/plugins/grafana/pontus-panel/
#COPY --chown=grafana:grafana --from=pontusvisiongdpr/pontus-grafana-orientdb-datasource:latest /grafana-orientdb-plugin/dist /var/lib/grafana/plugins/grafana/pontus-grafana-orientdb-datasource/
#COPY --chown=grafana:grafana ./algenty-grafana-flowcharting-0.6.0-6-gfee0569.zip /var/lib/grafana/plugins/grafana/
#USER root
#RUN cd  /var/lib/grafana/plugins/grafana/ && unzip /var/lib/grafana/plugins/grafana/algenty-grafana-flowcharting-0.6.0-6-gfee0569.zip
USER grafana
