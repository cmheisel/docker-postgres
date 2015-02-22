FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-utils

RUN apt-get install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV TERM=xterm
ENV PGDATA=/var/lib/postgresql

RUN apt-get install -y \
    postgresql-9.4 \
    postgresql-contrib-9.4 \
    libpq-dev \
    syslog-ng \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

ADD ./container/files /
RUN chmod +x /usr/local/bin/*.sh

RUN mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp/
RUN chown -v -R postgres.postgres /var/run/postgresql && \
    chown -v -R postgres.postgres /etc/postgresql/9.4/main/ && \
    /bin/bash /usr/local/bin/pg_init.sh

# Readd the files b/c postgres confs will get overritten during init
ADD ./container/files /
RUN chmod +x /usr/local/bin/*.sh
RUN chown -v -R postgres.postgres /etc/postgresql/9.4/main/

VOLUME /var/lib/postgresql
CMD ["supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
