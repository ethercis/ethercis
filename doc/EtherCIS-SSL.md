# Certitificate Authentication

As of v1.3.0, it is now possible to use JDBC parameters supported by postgresql [JDBC driver 42.2.4](https://jdbc.postgresql.org/).

The parameters are supplied as usual in `services.properties` and prefixed by `pgjdbc`, for example:

	pgjdbc.ssl=true

The list of supported parameters are given in the [HEAD documentation](https://jdbc.postgresql.org/documentation/head/index.html) of the driver.

## Configuring EtherCIS to Authenticate with a Certificate

### Server Configuration (self signed certificate)

	#make sure you specify the server IP address as CN!

	openssl req -new -text -nodes -keyout server.key -out server.csr 
	openssl req -x509 -text -in server.csr -key server.key -out server.crt
	cp server.crt root.crt
	rm server.csr
	chmod og-rwx server.key

postgresql.conf

	ssl = on
	ssl_cert_file = 'server.crt'
	ssl_key_file = 'server.key'
	ssl_ca_file = 'root.crt'

pg_hba.conf

	# "local" is for Unix domain socket connections only
	local           all             all                 trust
	hostnossl       all             all   0.0.0.0/0     reject
	#NB. the IP address is the one specified as CN in the server certificate!
	hostssl         all             postgres   192.168.100.10/32     cert clientcert=1

Restart the server.

### Ethercis Configuration

	#specify 'postgres' as CN for this client

	openssl req -new -nodes -keyout client.key -out client.csr 
	openssl x509 -req -CAcreateserial -in client.csr -CA root.crt -CAkey server.key -out client.crt
	rm client.csr
	# this is required to be interpreted by JDBC!
	openssl pkcs8 -topk8 -inform PEM -outform DER -in client.key -out client.pk8

### Check the connection with the certificate

	psql "sslmode=verify-ca host=192.168.100.10 user=postgres sslcert=./client.crt sslkey=./client.key sslrootcert=./root.crt"
	psql (10.4)
	SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
	Type "help" for help.
	
	postgres=#

### Ethercis services.properties

The following parameters should be provided (list at [connect using SSL](https://jdbc.postgresql.org/documentation/head/connect.html#ssl)). The parameters are prefixed with `pgjdbc`

	# simple JDBC connection
	# https://www.jooq.org/doc/3.10/manual/getting-started/tutorials/jooq-in-7-steps/jooq-in-7-steps-step4/
	# see https://jdbc.postgresql.org/documentation/head/ssl-client.html for details on configuring the client
	# ssl parameters in https://jdbc.postgresql.org/documentation/head/connect.html#ssl
	# NB. The host specified in the URL is the one specified in pg_hba.conf and as CN
	server.persistence.implementation=jooq
	server.persistence.jooq.dialect=POSTGRES
	server.persistence.jooq.url=jdbc:postgresql://192.168.100.10:5432/ethercis
	pgjdbc.user=postgres
	pgjdbc.ssl=true
	pgjdbc.sslmode=verify-ca
	pgjdbc.sslcert=/home/ethercis/client.crt
	pgjdbc.sslkey=/home/ethercis/client.pk8
	pgjdbc.sslpassword=my_secret_password_used_to_create_the_pk8_key
	pgjdbc.sslrootcert=/home/ethercis/root.crt

