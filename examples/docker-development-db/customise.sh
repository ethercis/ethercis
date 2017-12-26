apt-get update

apt-get install pgxnclient  -y

apt-get install postgresql-contrib -y


apt-get install postgresql-server-dev-9.6  -y

apt-get install ca-certificates -y
apt-get install build-essential -y

pgxn install temporal_tables

apt-get install git -y

apt-get install bison -y
apt-get install flex -y

echo 'now creating user root'
su - postgres -c 'psql -c "CREATE USER root WITH SUPERUSER;"'
echo 'created user root'

git clone https://github.com/postgrespro/jsquery.git
cd jsquery
make USE_PGXS=1
make USE_PGXS=1 install

su - postgres -c "psql < createdb.sql"

su - postgres -c "/usr/lib/postgresql/9.6/bin/pg_ctl  -D $PGDATA -m fast -w stop"

