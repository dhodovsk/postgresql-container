#!/bin/bash

SERVICE_CONFIG_PATH=/var/lib/pgsql/data/userdata/postgresql.conf

[ -r "${APP_DATA}/src/postgresql-config/postgresql.conf" ] && cp "${APP_DATA}/src/postgresql-config/postgresql.conf" ${SERVICE_CONFIG_PATH}
