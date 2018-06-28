DEPRECATED please refer to EtherCIS installation in https://github.com/ethercis/deploy-n-scripts
---


#Installing EtherCIS in a VM  or on a Physical Host 
This section is an attempt to give step by step instruction to install EtherCIS in a VM (but this can also be used for a physical box). 

The following assumes a server deployed on CentOS 6.7. The guest VM is assumed to be pre-configured with this version of Linux, it can be downloaded from CentOS [download area](https://wiki.centos.org/Download). In the following I use CentOS 6.7 x86_64. 

##Setting up Java 8

Install JDK 8 (Java SE Development Kit 8u74) from
 
	http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

Since it uses Linux 64
 
	jdk-8u74-linux-x64.rpm

Within Firefox, Open the file with the package installer (if Firefox is installed in your environment)

Package should be now installed in 

	/usr/java/jdk1.8.0._74

Open a terminal (SSH) and check the current installed Java version

It is important to check that the version on your path matches Java 8 JDK since EtherCIS requires Java 8.

	# java -version
	java version "1.7.0_79" <-- this is the default version coming with CentOS 6.7 and not the one we want!!!
OpenJDK Runtime ...

	# which java
	/usr/bin/java

We need to change the path to the installed java 8 JDK (assuming java jdk is installed at /usr/java/jdk1.8.0_74) and current logged user is root:

create a file named ethecis.sh in /etc/profile.d

	# echo 'pathmunge /usr/java/jdk1.8.0._74/bin' > /etc/profile.d/ethercis.sh
	# chmod +x /etc/profile.d/ethercis.sh

Relog user root, check the path is now correct:

	#java -version
	Java(TM) SE Runtime Environment (build 1.8. ...) --> OK

##Install Postgres 9.4

Access the download area at:

	http://www.postgresql.org/download/linux/redhat/

Or install the packages directly with yum 

	#yum install postgresql94-server postgresql94-contrib

If you get "Another app is currently holding the yum lock; waiting for it to exit...", you might need to disable PackageKit, but waiting for the lock to be released should be sufficient

Initialize the DB service

	#service postgresql-9.4 initdb
	#chkconfig postgresql-9.4 on 

And check the service is properly installed

	#rpm -qa | grep postgres

Starting postgresql

	#service postgresql-9.4 start

####Install temporal_tables PG Extension

This task is required to enable the versioning extension in Postgresql

Download the extension kit from [PGXN temporal_tables](http://pgxn.org/dist/temporal_tables/temporal_tables.html)

install development tools (required for gcc) if not yet installed

	# yum groupinstall 'Development Tools'

Do the same for postgresql devel headers and libraries

	#yum install postgresql94-devel

Now you should be ready to compile and install the extension. In the directory you have downloaded the archive:

	#make
	#make installcheck PGUSER=postgres

If it fails with FATAL: Peer authentication failed for user "postgres"

	#vim /var/lib/pgsql/9.4/data/pg_hba.conf

And change the authentication method to 'trust' for user postgres.

I had to do:

	#make install  <- before the check!!!
	#make installcheck PGUSER=postgres  (comes clean)

##Setting Up The Filesystem Structure

Create a local user and group 'ethercis'

	#groupadd ethercis
	#useradd ethercis -g ethercis

create the filesystem structure as user ethercis

	# su - ethercis

You can simply use the following script:

	#!/bin/bash
	# setup EtherCIS file system for a new install
	# ---------------------------------------
	
	echo "---------------- creating directory structure"
	
	mkdir -p /etc/opt/ecis
	mkdir -p /etc/opt/ecis/knowledge
	mkdir -p /etc/opt/ecis/knowledge/operational_templates
	mkdir -p /etc/opt/ecis/knowledge/templates
	mkdir -p /etc/opt/ecis/knowledge/archetypes
	mkdir -p /etc/opt/ecis/security
	mkdir -p /opt/ecis
	mkdir -p /opt/ecis/bin
	mkdir -p /opt/ecis/lib
	mkdir -p /opt/ecis/lib/application
	mkdir -p /opt/ecis/lib/system
	mkdir -p /opt/ecis/lib/common
	mkdir -p /var/opt/ecis
	
	chown -R ethercis:ethercis /etc/opt/ecis
	chown -R ethercis:ethercis /opt/ecis
	chown -R ethercis:ethercis /var/opt/ecis
	
	chmod -R 755 /etc/opt/ecis
	chmod -R 755 /opt/ecis
	chmod -R 755 /var/opt/ecis


##Prepare The Database

set a password to user 'postgres' and create DB ethercis

	#su - postgres
	- bash-4.1$ psql
	psql(9.4.6)
	Type "help" for help.

Assign a password to user postgres

	postgres=# alter user "postgres" with password 'posgres';
	ALTER ROLE
	postgres=# create database "ethercis";
	CREATE DATABASE
	postgres=# \l
	---> follows a list of DB

###Configure EtherCIS Tables

Ensure UUID extension *uuid_generate_v4* and *versioning* are installed

	#psql -U postgres
	postgres=# CREATE EXTENSION "uuid-ossp";
	CREATE EXTENSION
	postgres=# CREATE EXTENSION "temporal_tables";
	CREATE EXTENSION
	postgres=#\q

Create the tables

	#psql -U postgres -a -f /opt/ecis/bin/

Check tables creation

	#psql -U postgres
	postgres=# \connect ethercis
	You are now connected to database "ethercis" as user "postgres"
	postgres=# \dt ehr*.

	---> gives the list of tables in schema ehr:
	Schema |         Name          | Type  |  Owner  
	--------+-----------------------+-------+----------
	 ehr    | access                | table | postgres
	 ehr    | attestation           | table | postgres
	 ehr    | attested_view         | table | postgres
	 ehr    | composition           | table | postgres
	 ehr    | composition_history   | table | postgres
	 ehr    | concept               | table | postgres
	 ehr    | contribution          | table | postgres
	 ehr    | contribution_history  | table | postgres
	 ehr    | ehr                   | table | postgres
	 ehr    | entry                 | table | postgres
	 ehr    | entry_history         | table | postgres
	 ehr    | event_context         | table | postgres
	 ehr    | event_context_history | table | postgres
	 ehr    | identifier            | table | postgres
	 ehr    | language              | table | postgres
	 ehr    | participation         | table | postgres
	 ehr    | participation_history | table | postgres
	 ehr    | party_identified      | table | postgres
	 ehr    | status                | table | postgres
	 ehr    | status_history        | table | postgres
	 ehr    | system                | table | postgres
	 ehr    | terminology_provider  | table | postgres
	 ehr    | territory             | table | postgres
	(23 rows)
	postgres=# \q

####Populate Concept Tables

This step is required to ensure referential integrity with 'concepts', 'languages' and 'territory'

	#/opt/ecis/bin/populate-concept

###Setup Runtime Environment

Copy libraries, templates, bin, scripts, configuration examples and authentication into their respective locations:

	/etc/opt/ecis
	/etc/opt/ecis/terminology.xml
	/etc/opt/ecis/logging.properties
	/etc/opt/ecis/log4j.xml
	/etc/opt/ecis/services.properties
	/etc/opt/ecis/security
	/etc/opt/ecis/security/authenticate.ini
	
	/opt/ecis
	/opt/ecis/bin
	/opt/ecis/bin/purgeDB.sql
	/opt/ecis/bin/populate-concept
	/opt/ecis/bin/delete_subject.sql
	/opt/ecis/bin/create_subject.sql
	/opt/ecis/bin/pgsql_ehr.ddl
	/opt/ecis/bin/ecis-server
	/opt/ecis/bin/ecis-dump-opt
	/opt/ecis/lib
	/opt/ecis/lib/application
	/opt/ecis/lib/application/ecis-compositionservice.jar
	/opt/ecis/lib/application/ecis-authenticateservice.jar
	/opt/ecis/lib/application/ecis-partyidentifiedservice.jar
	/opt/ecis/lib/application/oet-parser.jar
	/opt/ecis/lib/application/adl-parser-1.0.9.jar
	/opt/ecis/lib/application/ServiceManager.jar
	/opt/ecis/lib/application/ecis-cacheknowledgeservice.jar
	/opt/ecis/lib/application/ecis-logonservice.jar
	/opt/ecis/lib/application/ecis-core.jar
	/opt/ecis/lib/application/ecis-knowledge.jar
	/opt/ecis/lib/application/ecis-ehrservice.jar
	/opt/ecis/lib/application/ecis-openehr.jar
	/opt/ecis/lib/application/ecis-vehrservice.jar
	/opt/ecis/lib/application/ecis-common.jar
	/opt/ecis/lib/application/ehrxml.jar
	/opt/ecis/lib/application/ecis-ehrdao.jar
	/opt/ecis/lib/application/types.jar
	/opt/ecis/lib/application/ecis-resourceaccessservice.jar
	/opt/ecis/lib/application/ecis-systemservice.jar
	/opt/ecis/lib/application/ecis-knowledge-cache.jar
	/opt/ecis/lib/application/ecis-servicemanager.jar
	/opt/ecis/lib/system
	/opt/ecis/lib/system/jdom-1.1.3.jar
	/opt/ecis/lib/system/jackson-annotations-2.7.0.jar
	/opt/ecis/lib/system/commons-collections4-4.0.jar
	/opt/ecis/lib/system/jooq-3.5.3.jar
	/opt/ecis/lib/system/postgresql-9.4-1204.jdbc42.jar
	/opt/ecis/lib/system/jersey-json-1.19.jar
	/opt/ecis/lib/system/thinkehr-framework-jsonlib-2.3.0-JL32.jar
	/opt/ecis/lib/system/jackson-core-2.7.2.jar
	/opt/ecis/lib/system/gson-jodatime-serialisers-1.2.0.jar
	/opt/ecis/lib/system/fst-2.40-onejar.jar
	/opt/ecis/lib/system/javolution-5.2.3.jar
	/opt/ecis/lib/system/jackson-datatype-joda-2.7.2.jar
	/opt/ecis/lib/system/dom4j-1.6.1.jar
	/opt/ecis/lib/system/jetty-servlet-9.2.10.v20150310.jar
	/opt/ecis/lib/system/jscience-4.3.1.jar
	/opt/ecis/lib/system/jackson-databind-2.7.2.jar
	/opt/ecis/lib/system/joda-time-2.4.jar
	/opt/ecis/lib/system/gson-2.4.jar

###Adapt Scripts

Check for bash path (ex. 'which bash') and change script header accordingly

Set the local hostname or IP address in the server launch script ethercis-server

	export SERVER_HOST=<your hostname or IP address> # the network address to bind to
or

	export SERVER_HOST=`hostname` #if hostname resolves to a valid IP address (see below)

###Run Ethercis server

	#/opt/ecis/bin/ecis-server start

##Network Configuration and Troubleshooting

The server should not use a DHCP generated IP address, make sure your guest VM uses a fixed address!

Check the local hostname and/or IP address

	ifconfig -a

If not done yet, add or change the local hostname with its corresponding address in /etc/hosts, for example:

	192.168.100.3   ethercis-vm.ethercis.com ethercis-vm

Allows username/password authentication for local network

	vim /var/lib/pgsql/9.4/data/pg_hba.conf

	->> host	all	127.0.0.1/32	trust

###Checking if the server is listening...

perform a remote login with user guest (f.ex. using PostMan)

If the server does not respond. Log on the VM as user root:

	#tcpdump -n -tttt -i eth0 port 8080

Whenever a request is sent to the server, the packets should be seen...

If not, check if the server is listening and accept connection from all network
	
	netstat -ltpn
	
	Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
	tcp        0      0 127.0.0.1:8000          0.0.0.0:*               LISTEN  <-- this means it listen to the localhost

Make sure the server binds an IP port that can be accessed from outside:

On VB, I use network bridging on eth0 on my machine set in Promiscuous Mode 'Allow All'

	[root@ethercis-vm ~]# netstat -ltnp
	Active Internet connections (only servers)
	Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name  
	tcp        0      0 0.0.0.0:8000                0.0.0.0:*                   LISTEN      5879/java          
	tcp        0      0 0.0.0.0:57761               0.0.0.0:*                   LISTEN      5879/java          
	tcp        0      0 0.0.0.0:8999                0.0.0.0:*                   LISTEN      5879/java          
	tcp        0      0 0.0.0.0:111                 0.0.0.0:*                   LISTEN      4469/rpcbind       
	tcp        0      0 192.168.100.4:8080          0.0.0.0:*                   LISTEN      5879/java          
	tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      4772/sshd          
	tcp        0      0 127.0.0.1:631               0.0.0.0:*                   LISTEN      4566/cupsd         
	tcp        0      0 0.0.0.0:60087               0.0.0.0:*                   LISTEN      4531/rpc.statd     
	tcp        0      0 127.0.0.1:5432              0.0.0.0:*                   LISTEN      4820/postmaster    
	tcp        0      0 127.0.0.1:25                0.0.0.0:*                   LISTEN      4916/master        
	tcp        0      0 :::50792                    :::*                        LISTEN      4531/rpc.statd     
	tcp        0      0 :::111                      :::*                        LISTEN      4469/rpcbind       
	tcp        0      0 :::22                       :::*                        LISTEN      4772/sshd          
	tcp        0      0 ::1:631                     :::*                        LISTEN      4566/cupsd         
	tcp        0      0 ::1:5432                    :::*                        LISTEN      4820/postmaster    
	tcp        0      0 ::1:25                      :::*                        LISTEN      4916/master        
	[root@ethercis-vm ~]#

The above ports are listening whenever ethercis server is running:
	
	8080: the RESTful HTTP service
	8000: the remote debugging port (should be disabled in production)
	8999: JMX port

Initially, iptables on both HOST and GUEST should be disabled to help in troubleshooting.

	#service iptables stop
	#chkconfig iptables off <- disable it permanently, make sure you configure iptables in production!

## VirtualBox Notes

Depending on your requirements, for example to transfer files from/to your guest VM, you might need to install VB Guest Additions for CentOS 6.7. This link gives an explanation on how to proceed: http://www.if-not-true-then-false.com/2010/install-virtualbox-guest-additions-on-fedora-centos-red-hat-rhel

	mkdir /media/VirtualBoxGuestAdditions
	mount -r /dev/cdrom /media/VirtualBoxGuestAdditions
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	yum install gcc kernel-devel kernel-headers dkms make bzip2 perl
	yum install kernel-devel-2.6.32-573.el6.x86_64 <-- check kernel src location
	cd /media/VirtualBoxGuestAdditions
	./VBoxLinuxAdditions.run
	-OR-
	/etc/init.d/vboxadd setup

##Preconfigured VM image

User can directly download a VM image for VirtualBox from:

	scp <user>@188.166.246.78:/home/ethercis/virtualbox/ethercis-vb-centos6.7-x86-64-v1.0.vdi /.

Please note a valid user is required to download the image. A userid/password can be provided if you send me a request by email at christian AT adoc DOT co DOT th (an anonymous access will be provided later)






 


