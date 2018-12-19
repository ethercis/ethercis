# Setting up EtherCIS to run as a service

## Prerequisite
In the following we use a reduced launch script (ecis-serverd). The script is given below.

## Editing the service control configuration

Create a file f.e. `ecis-srv.service` with the following content:


	[Unit]
	Description=EtherCIS server instance [GENERIC]
	
	[Service]
	Type=simple
	SuccessExitStatus=143
	Restart=on-failure
	RestartSec=3
	ExecStart=/home/ethercis/ecis-serverd start
	ExecStop=/home/ethercis/ecis-serverd stop
	WorkingDirectory=/home/ethercis
	User=ethercis


	[Install]
	WantedBy=multi-user.target

Copy the file into systemd config `/usr/lib/systemd/system/`

Then reload systemd and enable ethercis service to restart automatically at startup

	sudo systemctl daemon-reload 
	sudo systemctl start ecis-srv.service
	sudo systemctl enable ecis-srv.service
		Created symlink from /etc/systemd/system/multi-user.target.wants/ecis-srv.service to /usr/lib/systemd/system/ecis-srv.service.

Ethercis can be now managed by systemctl.

# Launch script

Script file `ecis-serverd`
	
	#!/usr/bin/env bash
	# EtherCIS server script
	# script created on Sun Sep 16 23:48:23 EDT 2018 by user christian
	
	source /home/ethercis/env.rc
	
	export LIB_DEPLOY=/opt/ecis/lib/deploy
	export SYSLIB=/opt/ecis/lib/system
	
	export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"
	
	# runtime parameters
	export JVM=${JAVA_HOME}/bin/java
	export RUNTIME_HOME=/opt/ecis
	export RUNTIME_ETC=/etc/opt/ecis
	export RUNTIME_LOG=/var/opt/ecis
	export RUNTIME_DIALECT=EHRSCAPE  #specifies the query dialect used in HTTP requests (REST)
	export SERVER_PORT=${ECIS_REST_PORT} # the port address to bind to
	export SERVER_HOST=${ECIS_REST_HOST} # the network address to bind to
	
	export JOOQ_DIALECT=POSTGRES
	JOOQ_DB_PORT=${ECIS_PG_PORT}
	JOOQ_DB_HOST=${ECIS_PG_HOST}
	JOOQ_DB_SCHEMA=${ECIS_PG_SCHEMA}
	export JOOQ_URL=jdbc:postgresql://${JOOQ_DB_HOST}:${JOOQ_DB_PORT}/${JOOQ_DB_SCHEMA}
	export JOOQ_DB_LOGIN=${ECIS_PG_ID}
	export JOOQ_DB_PASSWORD=${ECIS_PG_PWD}
	
	export CLASSPATH=$LIB_DEPLOY/*:$SYSLIB/ecis-dependencies/*:$SYSLIB/openehr-java-lib/*
	
	# launch server
	# ecis server is run as user ethercis
	case "$1" in
	  start)
	    echo "ethercis startup"
	    echo "Environment"
	    echo "==================================="
	    echo "CLASSPATH: ${CLASSPATH}"
	    echo "RUNTIME ETC: ${RUNTIME_ETC}"
	    echo "NODE NAME: ${ECIS_NODE_NAME}"
	    echo "PROCESS NAME: ${INSTANCE_NAME}"
	    echo "SERVER HOST: ${ECIS_REST_HOSTNAME}"
	    echo "SERVER PORT: ${ECIS_REST_PORT}"
	    echo "DB HOST: ${JOOQ_URL}"
	    echo "DEBUG LOG: ${RUNTIME_LOG}"
	    echo "==================================="
	
	    echo "launching vEhr...."
	    exec -a ${INSTANCE_NAME} \
	          ${JVM}\
	          -server -XX:-EliminateLocks 	-XX:-UseVMInterruptibleIO \
	 	  -cp ${CLASSPATH} \
		   -Djava.util.logging.config.file=${RUNTIME_ETC}/logging.properties \
		   -Dlog4j.configurationFile=file:${RUNTIME_ETC}/log4j.xml \
		   -Djava.net.preferIPv4Stack=true \
		   -Djava.awt.headless=true \
		   -Djdbc.drivers=org.postgresql.Driver \
		   -Dserver.node.name=${ECIS_NODE_NAME} \
	           -Dfile.encoding=UTF-8 \
	           -Djava.rmi.server.hostname=${SERVER_HOST} \
		   -Djooq.dialect=${JOOQ_DIALECT} \
		   -Djooq.url=${JOOQ_URL} -Djooq.login=${JOOQ_DB_LOGIN} -Djooq.password=${JOOQ_DB_PASSWORD} \
		   -Druntime.etc=${RUNTIME_ETC} \
	           -Dserver.http.port=${ECIS_REST_PORT} -Dserver.http.host=${ECIS_REST_HOSTNAME}\
	           com.ethercis.vehr.Launcher \
		   -propertyFile /etc/opt/ecis/services.properties
	    exit 0 
	    ;;
	  stop)
	    
	    echo "ethercis shutdown"
	# pkill java
	    kill $(ps aux | grep ${INSTANCE_NAME} | grep -v grep | awk '{print $2}')
	    exit 0
	    ;;
	  restart)
	      
	    echo "ethercis restarting"
	    $0 stop
	    $0 start
	    ;;
	  clean)
	    (${ECIS_MAILER} ${MAILER_CONF} "Ethercis CLEAR" "Manual invocation of server Clear logs" > dev/null )&
	    echo "ethercis clear"
	    $0 stop
		rm -rf ${RUNTIME_LOG}/ethercis_test.log
	    ;;
	  *)
	    echo "Usage: ecis-server {start|stop|restart|clean}"
	    exit 1
	esac
	exit 0

Where `env.rc` is as follows

	export ECIS_HOME=/opt/ecis
	export ECIS_PG_HOST=localhost
	export ECIS_PG_PORT=5432
	export ECIS_PG_SCHEMA=ethercis
	export ECIS_PG_ID=postgres
	export ECIS_PG_PWD=postgres
	export ECIS_REST_HOSTNAME=192.168.100.9
	export ECIS_REST_PORT=8080
	export ECIS_NODE_NAME=ethercis.ripple.org
	export JAVA_HOME=/usr/lib/jvm/java-openjdk
	export INSTANCE_NAME=ecis-srv-01

Please make sure the above parameters are in sync with your configuration.