Ethercis
========

Xmas Edition 12/24/2015 3:54:43 PM 

What is it?
-----------

A brief introduction to Ethercis is given [here](http://ethercis.org/)

Project Structure
---
To allow various deployment and integration, the project is partitioned in two parts:

- core components: this part deals with OpenEhr object handling, serialization, deserialization, knowledge management and persistence
- service wrappers: this part encapsulate core components into a service framework with a REST API and JMX instrumentalization.

**Core Components**

The core modules are the following:

- core: fundamental operations and encoding of OpenEhr entities
- ehrdao: persistence of OpenEhr entities using a mixed model (relational/NoSql)
- knowledge-cache: caching of OpenEhr knowledge models (operational templates in particular)

**Service Wrappers**

The service and framework are the following:

- ServiceManager: service management framework
- VEhrService: Query gateway of a running instance
- ResourceAccessService: a common service to access external resources (DB, knowledge etc.)
- PartyIdentifiedService: wrapper to interact with OpenEhr PartyIdentified entities
- LogonService: controls user login/logout and sessions
- AuthenticationService: wrap a security policy provider
- CacheKnowledgeService: wrapper of knowledge-cache to allow user queries
- EhrService: deals with user queries on OpenEhr Ehr and Ehr Status objects
- CompositionService: deals with user queries on Composition objects

Please refer to the respective component's README for more details on the above

**Database**

The database is based on bi-temporal tables keeping records history. See `pgsql_ehr.ddl` for more details on this.

How To Build and Run It?
----------------
- You need to compile each module as indicated in their respective README.
- The sample launch script (ecis-server) assumes some jar assemblies to simplify the classpath. At the moment, there is no assembly provided in the pom's.
- Locally, you should install the 'exotic' libraries required by Maven. These jars are located in directory 'libraries'. Local installation can be achieved with the following command for example:

		mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  
		    -Dfile=/Development/Dropbox/eCIS_Development/eCIS-LIB/compositionTemplate.jar 
		    -DgroupId=org.openehr 
		    -DartifactId=org.openehr.openEHR.v1 
		    -Dversion=1.0.0 
		    -Dpackaging=jar 
		    -DlocalRepositoryPath=/Development/Dropbox/eCIS_Development/eCIS-LIB/local-maven-repo

- Script ecis-server should be adapted to get the right classpath, path to required configuration, network parameters etc.
- Ditto for all configuration files.

The scripts and configuration samples are in directory `examples` 
    

