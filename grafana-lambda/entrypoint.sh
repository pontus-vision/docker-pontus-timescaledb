#!/bin/bash 
echo "GRAFANA ENTRYPOINT - 10jul2021"
id || true
#ls -altr /mnt || true
#ls -altr /var/lib/grafana || true
if [[ ! -d /mnt/grafana/pvconfig_2021-07-13T2155 ]]; then
  rm -rf /mnt/grafana/pvconfig_*
  cp  /var/lib/grafana/grafana.db /mnt/grafana/ || true
  mkdir /mnt/grafana/pvconfig_2021-07-13T2155
fi 
#ls -altr /run.sh || true
echo "GRAFANA ENTRYPOINT - about to start /run.sh"

/run.sh
