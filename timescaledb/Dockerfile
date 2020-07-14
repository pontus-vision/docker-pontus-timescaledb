FROM timescale/timescaledb:1.6.1-pg11

#FROM timescale/timescaledb:latest

#COPY docker-entrypoint.sh  /usr/local/bin/docker-entrypoint.sh
#COPY 999_pontus-vision.sh  /docker-entrypoint-initdb.d/
COPY 100_pontus-vision.sql  /docker-entrypoint-initdb.d/


EXPOSE 5432

