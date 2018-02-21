# vim:set ft=dockerfile:
FROM postgres:10.1

RUN mkdir -p /var/lib/postgresql/pgdata
ENV PGDATA  /var/lib/postgresql/pgdata

#ETHERCIS: add files
ADD customise.sh /
ADD createdb.sql / 

#RUN su - postgres -c "/etc/init.d/postgresql start" && /customise.sh

RUN  sh  -c " /usr/local/bin/docker-entrypoint.sh postgres & "  && sleep 20 &&  /customise.sh

#RUN su - postgres -c "/usr/lib/postgresql/10/bin/pg_ctl -D $PGDATA  -w start" &&

#pg_ctl -D \\\"$PGDATA\\\" -o \\\"-c listen_addresses=\\\'localhost\\\'\\\" -w start