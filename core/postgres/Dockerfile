FROM postgres:16

RUN apt-get update && apt-get install -y curl \
    curl gnupg ca-certificates lsb-release wget

RUN echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/timescale_timescaledb.list \
    && curl -L http://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add -

RUN apt-get -y install postgresql-16-cron
RUN apt-get update && apt-get install -y timescaledb-2-postgresql-16

COPY ./initdb/ /docker-entrypoint-intidb.d/

COPY ./postgresql.conf /etc/postgresql.conf
COPY ./pg_hba.conf /etc/postgresql/pg_hba.conf

CMD ["postgres", "-c", "config_file=/etc/postgresql.conf"]