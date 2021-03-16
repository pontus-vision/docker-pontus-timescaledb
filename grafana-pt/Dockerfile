#FROM grafana/grafana:7.3.7-ubuntu
FROM grafana/grafana:7.4.3-ubuntu
#FROM grafana/grafana:6.2.5
COPY --chown=grafana:grafana grafana.db /var/lib/grafana/
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana-pontus.ini
COPY --chown=grafana:grafana app.9d62d98149547e1107ad.js /usr/share/grafana/grafana/build/app.9d62d98149547e1107ad.js
COPY --chown=grafana:grafana app.9d62d98149547e1107ad.js /usr/share/grafana/public/build/app.9d62d98149547e1107ad.js
USER root
RUN ln -s /usr/share/grafana/public /usr/share/grafana/grafana && \
    apt-get update -y && apt install -y netcat
   
USER grafana
RUN grafana-cli plugins install agenty-flowcharting-panel

EXPOSE 3000
COPY --chown=grafana:grafana --from=pontusvisiongdpr/pontus-grafana-react-panel:latest /var/lib/grafana/plugins/grafana/pontus-panel/ /var/lib/grafana/plugins/grafana/pontus-panel/
