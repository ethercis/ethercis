Suggested Deployment
====================
The following gives some guidelines to install and run ethercis on a Linux box for test purpose.

System Requirements
-------------------
Ethercis should be deployed in a multi-tiers architecture, with the actual server instance running on commodity servers. Ethercis is pretty lean in terms of resources, however, some operations are resource hungry:

- XML composition import/export: as usual, XML is somewhat costly in terms of resources...
- Deserialization: one significant consuming operation is the duplication of item tree structure. This is used to add occurrences in ItemList for example (think of a medication or problem list). 
- Initial caching of templates. Templates however are loaded at instance start-up. 

**CPU**

At this stage more benchmarking is required, but a dual cores 64 bits is recommended.

**Required Installed Packages**

- Java 1.8
- Postgresql 9.4

**Disk storage**

- 1.5 GB for binaries, executables and configuration 
- 1 GB for templates
- 1 GB for logs
- Database: the DB can grow significantly in size, a good start would be around 100GB. In production, some capacity planning is recommended (see [EnterpriseDB](http://www.enterprisedb.com/products/postgres-enterprise-manager) for an example with PostgreSQL)

=> about 105GB to start with. Ideally, the storage should be on SSD for the server part as I/O can reduce significantly the performances.

**Network**

At least one NIC (!). Ethercis can run on a multi-homed system. Just specify the hostname you wish to bind to in the start up script. 

Directory Structure
-------------------
The following are suggestions to deploy an ethercis server instance. I am assuming the deployment is based on Linux (currently a test server is up and running on CentOS Linux 7)
	
	/opt/ecis/bin <- scripts and utilities
	/opt/ecis/lib <- all jars required to run the server instance

	/etc/opt/ecis/ <- property files (ethercis, log4j, logging)
	/etc/opt/ecis/knowledge/archetypes
	/etc/opt/ecis/knowledge/templates
	/etc/opt/ecis/knowledge/operational_templates
	/etc/opt/ecis/security <- f.e. authenticate.ini should be located there

	/var/opt/ecis/ <- should contains the log files
	


