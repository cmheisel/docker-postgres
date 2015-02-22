#!/bin/bash
set -x
su postgres -c "pg_dropcluster --stop 9.4 main"
su postgres -c "pg_createcluster --start --locale en_US.UTF-8 9.4 main"

su postgres -c "psql --command='CREATE EXTENSION adminpack;'"
