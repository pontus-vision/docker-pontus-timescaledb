#FROM grafana/grafana:7.3.7-ubuntu
#FROM grafana/grafana:7.4.3-ubuntu
FROM pontusvisiongdpr/grafana:1.13.2
COPY --chown=grafana:grafana grafana.db /var/lib/grafana/
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana.ini
COPY --chown=grafana:grafana grafana.ini /etc/grafana/grafana-pontus.ini

