FROM postgres:17.2-alpine

COPY initdb/*.sql /docker-entrypoint-initdb.d/