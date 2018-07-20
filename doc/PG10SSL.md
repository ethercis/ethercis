#PostgreSQL SSL Configuration

## Introduction
This document provides a quick explanation for setting up SSL on PostgreSQL 10 [PG10]/CentOS 7 and connecting to it with EtherCIS.

This approach assumes that no username/password will be used to connect to the server.

SSL connectivity is supported for both JDBC and DBCP2 from v1.3.0.

## Setting up SSL on the Server Side

Standard installation (f.e. using the script in [https://github.com/ethercis/deploy-n-scripts](https://github.com/ethercis/deploy-n-scripts) results in the following structure for PG10 :

* ```/usr/pgsql-10/``` binaries etc.
* ```/var/lib/pgsql/10``` data, configuration etc.

SUDO as root for the following (sudo su - root).

First thing is to check whether PG10 supports SSL (this is a compile time option):

```# /usr/pgsql-10/bin/pg_config | grep CONFIGURE | grep 'with-openssl'```

Should return the list of flags with ```with-openssl``` highlighted.

Now, create a signed certificate with [openssl](https://www.openssl.org/docs/man1.0.2/apps/openssl.html):

	[root@ethercis ethercis]# openssl req -new -text -out ethercis_pg10.req

This requests a PKCS#10 X.509 Certificate Signing Request (CSR).

NB. You'll need to specify a Common Name (CN) attribute for the Distinguished Name of the X.509 certificate. There are many more options depending on the scenario and whether or not the certificate is issued from a valid Certificate Authority (CA). Interested reader can refer to IBM's Knowledge Center on [Digital Certificates](https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_7.5.0/com.ibm.mq.sec.doc/q009820_.htm).

See also [valid country codes](https://www.digicert.com/ssl-certificate-country-codes.htm) at DigiCert.

With the above command, the dialog can be as follows:

	[root@ethercis ethercis]# openssl req -new -text -out ethercis_pg10.req
	Generating a 2048 bit RSA private key
	.............+++
	..............+++
	writing new private key to 'privkey.pem'
	Enter PEM pass phrase:
	Verifying - Enter PEM pass phrase:
	-----
	You are about to be asked to enter information that will be incorporated
	into your certificate request.
	What you are about to enter is what is called a Distinguished Name or a DN.
	There are quite a few fields but you can leave some blank
	For some fields there will be a default value,
	If you enter '.', the field will be left blank.
	-----
	Country Name (2 letter code) [XX]:GB
	State or Province Name (full name) []: West Yorkshire
	Locality Name (eg, city) [Default City]:Leeds
	Organization Name (eg, company) [Default Company Ltd]:ethercis
	Organizational Unit Name (eg, section) []:
	Common Name (eg, your name or your server's hostname) []:db_master.ethercis.org
	Email Address []:
	
	Please enter the following 'extra' attributes
	to be sent with your certificate request
	A challenge password []:
	An optional company name []:

This creates a couple of new files:

	-rw-r--r--. 1 root     root      3494 Jul 11 22:04 ethercis_pg10.req
	-rw-r--r--. 1 root     root      1834 Jul 11 22:04 privkey.pem


To ensure the server starts automatically, the pass phrase should be removed from the private key:

	[root@ethercis ethercis]# openssl rsa -in privkey.pem -out ethercis_pg10.key

You'll be prompted to enter the pass phrase you have entered previously to generate the certificate.

You can safely delete the private key (```rm privkey.pem```)

The certificate can be created:

	[root@ethercis ethercis]# openssl req -x509 -in ethercis_pg10.req -text -key ethercis_pg10.key -out ethercis_pg10.crt

check the certificate content:

	[root@ethercis ethercis]# less ethercis_pg10.crt

	Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            c3:82:c7:eb:4f:66:01:f8
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=GB, ST= West Yorkshire, L=Leeds, O=ethercis, CN=db_master.ethercis.org
        Validity
            Not Before: Jul 12 02:12:04 2018 GMT
            Not After : Aug 11 02:12:04 2018 GMT
        Subject: C=GB, ST= West Yorkshire, L=Leeds, O=ethercis, CN=db_master.ethercis.org
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:bf:4c:62:90:3c:5b:d2:0b:a0:b2:4a:70:f4:c7:
                    93:dc:38:21:ab:f9:ed:f2:d2:ed:52:10:a3:b3:e2:
                    f3:7d:74:42:4a:ce:00:19:19:01:c7:12:fb:36:e5:
                    d3:32:8a:9f:82:aa:75:34:e9:a4:b5:65:9d:f5:c9:
                    d5:32:6e:f4:16:b2:96:47:49:40:f3:3c:2b:e0:f4:
                    c6:35:94:a6:e0:1a:5e:04:34:f0:e6:e9:e8:04:7b:
                    38:5b:36:71:18:2f:7b:c8:5c:0b:b1:5b:84:c3:62:
                    e1:37:e5:4d:f9:56:6e:36:15:6e:56:84:56:c4:e8:
                    1e:7d:14:f3:aa:3e:bd:7b:d2:31:e5:32:57:68:8a:
                    2b:3c:f1:2c:3f:a3:20:4f:3a:92:65:11:bd:00:b4:
                    a1:ee:c1:39:53:8d:6c:28:14:fe:b5:64:4b:68:39:
                    05:01:19:ed:b6:fd:b6:14:bd:21:da:0a:44:ee:2e:
                    7b:bd:6c:67:90:ac:6f:3a:35:0f:d9:ad:d4:11:0d:
                    82:71:f8:9d:8f:71:83:ff:d2:aa:eb:31:19:7f:87:
                    e5:32:6e:df:21:b4:e1:4a:ac:9e:cd:85:92:e0:1f:
                    65:de:0c:2c:1a:2c:14:21:e5:29:c1:3a:c8:35:cb:
                    52:06:f0:17:33:0c:6a:34:8a:f6:00:88:3b:80:fb:
                    fc:1d
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                94:3A:42:91:6F:AA:DC:B0:D9:DE:74:C1:56:62:8C:14:53:68:36:D9
            X509v3 Authority Key Identifier:
                keyid:94:3A:42:91:6F:AA:DC:B0:D9:DE:74:C1:56:62:8C:14:53:68:36:D9

            X509v3 Basic Constraints:
                CA:TRUE
    Signature Algorithm: sha256WithRSAEncryption
         06:64:5a:40:ec:1b:d3:8b:c7:ef:44:15:ed:1c:e9:44:3f:eb:
         43:d8:0f:b1:66:e0:1c:9a:92:25:b0:54:6d:37:2c:8f:6c:ca:
         47:84:a7:73:b0:13:e7:54:02:82:f2:5d:7d:9f:4f:7f:30:d6:
         cd:51:e7:09:f0:ec:7c:c3:09:38:6e:41:01:0d:05:bd:cb:7c:
         f6:e5:38:79:aa:3a:fe:4e:73:90:a6:0d:f4:4d:61:8f:f6:02:
         4d:72:bf:c1:e8:48:73:34:0e:fa:96:6c:ab:40:39:60:a2:3b:
         b3:72:55:14:65:64:b0:b1:d1:ba:49:99:c3:2b:11:40:28:65:
         a7:9c:b2:ed:83:80:1e:ea:4a:bc:8b:58:be:c1:a8:4b:55:1a:
         84:bb:a1:24:f0:fa:ab:a1:14:5a:da:84:33:0d:3b:27:04:b1:
         b5:61:ad:df:a8:1d:88:7b:34:fe:14:6a:f4:41:d4:c4:1d:e1:
         7b:19:30:8e:54:e3:b5:a9:d4:42:b0:62:09:03:1b:ed:bb:c3:
         fa:1e:70:58:50:ef:da:e9:12:24:01:51:78:9d:79:6f:35:94:
         30:1c:62:0e:aa:c4:77:96:e6:4d:6a:6c:8b:0a:04:2b:c3:56:
         e1:f3:31:3e:a8:62:9e:8d:4b:36:bd:60:33:a5:9c:9b:17:8c:
         5b:20:3b:d4
	-----BEGIN CERTIFICATE-----
	MIIDqTCCApGgAwIBAgIJAMOCx+tPZgH4MA0GCSqGSIb3DQEBCwUAMGsxCzAJBgNV
	BAYTAkdCMRgwFgYDVQQIDA8gV2VzdCBZb3Jrc2hpcmUxDjAMBgNVBAcMBUxlZWRz
	MREwDwYDVQQKDAhldGhlcmNpczEfMB0GA1UEAwwWZGJfbWFzdGVyLmV0aGVyY2lz
	Lm9yZzAeFw0xODA3MTIwMjEyMDRaFw0xODA4MTEwMjEyMDRaMGsxCzAJBgNVBAYT
	AkdCMRgwFgYDVQQIDA8gV2VzdCBZb3Jrc2hpcmUxDjAMBgNVBAcMBUxlZWRzMREw
	DwYDVQQKDAhldGhlcmNpczEfMB0GA1UEAwwWZGJfbWFzdGVyLmV0aGVyY2lzLm9y
	ZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL9MYpA8W9ILoLJKcPTH
	k9w4Iav57fLS7VIQo7Pi8310QkrOABkZAccS+zbl0zKKn4KqdTTppLVlnfXJ1TJu
	9BaylkdJQPM8K+D0xjWUpuAaXgQ08Obp6AR7OFs2cRgve8hcC7FbhMNi4TflTflW
	bjYVblaEVsToHn0U86o+vXvSMeUyV2iKKzzxLD+jIE86kmURvQC0oe7BOVONbCgU
	/rVkS2g5BQEZ7bb9thS9IdoKRO4ue71sZ5Csbzo1D9mt1BENgnH4nY9xg//Squsx
	GX+H5TJu3yG04Uqsns2FkuAfZd4MLBosFCHlKcE6yDXLUgbwFzMMajSK9gCIO4D7
	/B0CAwEAAaNQME4wHQYDVR0OBBYEFJQ6QpFvqtyw2d50wVZijBRTaDbZMB8GA1Ud
	IwQYMBaAFJQ6QpFvqtyw2d50wVZijBRTaDbZMAwGA1UdEwQFMAMBAf8wDQYJKoZI
	hvcNAQELBQADggEBAAZkWkDsG9OLx+9EFe0c6UQ/60PYD7Fm4ByakiWwVG03LI9s
	ykeEp3OwE+dUAoLyXX2fT38w1s1R5wnw7HzDCThuQQENBb3LfPblOHmqOv5Oc5Cm
	DfRNYY/2Ak1yv8HoSHM0DvqWbKtAOWCiO7NyVRRlZLCx0bpJmcMrEUAoZaecsu2D
	gB7qSryLWL7BqEtVGoS7oSTw+quhFFrahDMNOycEsbVhrd+oHYh7NP4UavRB1MQd
	4XsZMI5U47Wp1EKwYgkDG+27w/oecFhQ79rpEiQBUXideW81lDAcYg6qxHeW5k1q
	bIsKBCvDVuHzMT6oYp6NSza9YDOlnJsXjFsgO9Q=
	-----END CERTIFICATE-----
	(END)

IMPORTANT: revoke read, write, execute to all except owner (root):

	[root@ethercis ethercis]# chmod og-rwx ethercis_pg10.crt
	[root@ethercis ethercis]# chmod og-rwx ethercis_pg10.key

Move the certificate and its key to PG10 data directory:

	[root@ethercis ethercis]# mv ethercis_pg10.crt ethercis_pg10.key /var/lib/pgsql/10/data/

Set the server in SSL mode using psql:

	[root@ethercis ethercis]# psql -h 192.168.100.10 -U postgres
	psql (10.4)
	Type "help" for help.
	
	postgres=# alter system set ssl='on';
	ALTER SYSTEM
	postgres=# \q

Edit postgresql.conf to use the newly created certificate and key, uncomment and edit the the following lines:

ssl_cert_file = 'ethercis_pg10.crt'
ssl_key_file = 'ethercis_pg10.key'


And change the owner:group for these files:

	[root@ethercis ~]# chown postgres:postgres /var/lib/pgsql/10/data/ethercis_pg10.crt /var/lib/pgsql/10/data/ethercis_pg10.key

Restart the server:

	[root@ethercis ~]# service postgresql-10.service restart

Check SSL mode is activated

	[root@ethercis ~]# psql -h 192.168.100.10 -U postgres
	psql (10.4)
	SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
	Type "help" for help.
	
	postgres=# \q



