Generating jOOQ binding
=======================

Since I tend to forget a few things each time I change the DB structure (including launching a jOOQ binding re-creation!), here are some notes and stuff that need to be done for a successful binding generation. The following is for a Windows 7 based deployment using jOOQ 3.7.3

In module ehrdao, a resources directory contains two important files 

- `jooq-codegen.bat` This is the command file to launch from its installed directory, on my machine: C:\development\eCIS\ehrservice\ehrdao\resources
- `ecis-dbgen.xml` This is the configuration file to use with the above script

The command to execute is:

	jooq-codegen.bat ecis-dbgen.xml

There are several important variables to adjust depending on the installation.

**In jooq-codegen.bat**

Specify where jOOQ is installed on the local machine

	JOOQ_LIB=C:\Development\JOOQ\jOOQ-lib

The version of jOOQ

	JOOQ_VERSION=3.7.3

The JDBC driver to use to communicate with the DB

	PG_JDBC=C:\PostgreSQL\pgJDBC\postgresql-9.4-1200.jdbc41.jar

**In ecis-dbgen.xml**

Set the communication parameters with the DB server instance.

	<jdbc>
	   <driver>org.postgresql.Driver</driver>
	   <url>jdbc:postgresql://localhost:5434/ethercis</url>
	   <user>postgres</user>
	   <password>postgres</password>
	</jdbc>

###TODO
Add a maven jOOQ plugin in jooq-pg `pom.xml`

 