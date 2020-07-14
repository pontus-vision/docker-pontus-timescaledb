#!/usr/bin/env bash
set -Eeo pipefail
# METRIC_TYPE  num_dsars, avg_time, 
# DSAR_SOURCE - <organization name>, <emp id>, metrics, 
# DSAR_SOURCE_TYPE - number_organization, per employee, 
# DSAR_TYPE - read, update, delete
# DSAR_STATUS - new, denied, completed, acknowledged
# DSAR_AGE <=5 , <=10, <=15, <=30, >30 -> diff between now() - create_time() (only for not resolved)
# num_dsars -- number of DSAR
# max_resolution_time -- peak time diff between resolution_time() - create_time(), only for the resolution time within the last 30 days
# avg_resolution_time of DSAR
# min_resolution_time of DSAR
# timestamp -- number of DSAR

while [[ `echo 'SELECT 1' | psql -U $POSTGRES_USER` != '1' ]] ; do
  echo waiting for DB to start;
  sleep 10
done
  
psql -U "$POSTGRES_USER" <<EOF
CREATE DATABASE dtm WITH OWNER $POSTGRES_USER;
GRANT ALL PRIVILEGES ON DATABASE dtm TO $POSTGRES_USER;

\c dtm
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

CREATE table simple_metrics (
  PKID serial,
  metrictype varchar(500),
  metricname varchar(500),
  metricvalue integer,
  tstmp timestamp with time zone default current_timestamp,
  PRIMARY KEY(PKID, tstmp, metrictype));
SELECT create_hypertable('simple_metrics','tstmp', 'metrictype', 8, chunk_time_interval => interval '1 day');

CREATE table dsar_metrics (
  PKID serial,
  dsar_source_name varchar(500),
  dsar_source_type varchar(1000),
  dsar_count integer,
  dsar_timestamp timestamp with time zone default current_timestamp,
  PRIMARY KEY(PKID,dsar_timestamp, dsar_source_type));
SELECT create_hypertable('dsar_metrics','dsar_timestamp', 'dsar_source_type', 4, chunk_time_interval => interval '1 day');

EOF

