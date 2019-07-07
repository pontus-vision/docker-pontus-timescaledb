FROM grafana/grafana:6.2.5
COPY --chown=grafana:grafana grafana.db /var/lib/grafana/
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana-pontus.ini
USER root
RUN ln -s /usr/share/grafana/public /usr/share/grafana/grafana && \
    apt-get update -y && apt install -y netcat
   
USER grafana
EXPOSE 3000
