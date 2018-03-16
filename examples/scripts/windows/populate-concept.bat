REM !/usr/bin/bash
REM  description: Populate the concept table from terminology xml
REM 
REM  SCRIPT created 18-12-2015, CCH
REM -----------------------------------------------------------------------------------
REM UNAME=`uname`
REM HOSTNAME=`hostname`
set RUNTIME_HOME=C:\Users\christian\Documents\EtherCIS\home
set ECIS_DEPLOY_BASE=C:\Users\christian\Documents\EtherCIS\home\lib
set APPLIB=%ECIS_DEPLOY_BASE%\applib
set SYSLIB=%ECIS_DEPLOY_BASE%\syslib
set LIB=%ECIS_DEPLOY_BASE%\deploy

REM Mailer configuration
REM ECIS_MAILER=echo

REM use the right jvm library depending on the OS
REM NB: EtherCIS requires java 8
set JAVA_HOME=C:\Java\jre1.8.0_65

#force to use IPv4 so Jetty can bind to it instead of IPv6...
set _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"

# runtime parameters
set JVM=%JAVA_HOME%\bin\java
set RUNTIME_ETC=%RUNTIME_HOME%\etc
set RUNTIME_LOG=%RUNTIME_HOME%\log
REM #specifies the query dialect used in HTTP requests (REST)
set RUNTIME_DIALECT=EHRSCAPE
REM # the port address to bind to  
set SERVER_PORT=8080 
REM # the network address to bind to
set SERVER_HOST=192.168.2.104

set JOOQ_DIALECT=POSTGRES
set JOOQ_DB_PORT=5434
set JOOQ_DB_HOST=localhost
set JOOQ_DB_SCHEMA=ethercis
set JOOQ_URL=jdbc:postgresql://%JOOQ_DB_HOST%:%JOOQ_DB_PORT%/%JOOQ_DB_SCHEMA%
set JOOQ_DB_LOGIN=postgres
set JOOQ_DB_PASSWORD=postgres

set CLASSPATH=.\;^
%JAVA_HOME%\lib;^
%LIB%\ecis-core-1.1.1-SNAPSHOT.jar;^
%LIB%\ecis-knowledge-cache-1.1.0-SNAPSHOT.jar;^
%LIB%\ecis-ehrdao-1.1.0-SNAPSHOT.jar;^
%LIB%\jooq-pg-1.1.0-SNAPSHOT.jar;^
%LIB%\ecis-servicemanager-1.1.0-SNAPSHOT.jar;^
%APPLIB%\ehrxml.jar;^
%APPLIB%\oet-parser.jar;^
%APPLIB%\ecis-openehr.jar;^
%APPLIB%\types.jar;^
%APPLIB%\adl-parser-1.0.9.jar;^
%SYSLIB%\fst-2.40-onejar.jar;^
%SYSLIB%\jersey-json-1.19.jar;^
%SYSLIB%\gson-2.4.jar;^
%SYSLIB%\commons-collections4-4.0.jar;^
%SYSLIB%\jooq-3.5.3.jar;^
%SYSLIB%\postgresql-9.4-1204.jdbc42.jar;^
%SYSLIB%\dom4j-1.6.1.jar


REM launch populate-concepts
    echo "populating concept table"
    echo %CLASSPATH%
%JVM% ^
-Xmx256M ^
-Xms256M ^
-cp %CLASSPATH% ^
-Djava.util.logging.config.file=%RUNTIME_ETC%\logging.properties ^
-Dlog4j.configurationFile=%RUNTIME_ETC%/log4j.xml  ^
-Djdbc.drivers=org.postgresql.Driver ^
-Dfile.encoding=UTF-8 ^
-Djooq.url=%JOOQ_URL% ^
-Djooq.login=%JOOQ_DB_LOGIN% ^
-Djooq.password=%JOOQ_DB_PASSWORD% ^
-Druntime.etc=%RUNTIME_ETC% ^
 com.ethercis.dao.access.support.TerminologySetter ^
-url %JOOQ_URL% ^
-login %JOOQ_DB_LOGIN% ^
-password %JOOQ_DB_PASSWORD% ^
-terminology %RUNTIME_ETC%\terminology.xml

REM end of file

