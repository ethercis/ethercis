Ethercis
========

**v1.3.0 March 2019**

What is it?
-----------

An [openEHR](http://www.openehr.org/) CDR essentially based on SQL that exposes its services *via* a REST API.

EtherCIS is a truly query-able openEHR CDR; meaning that a wealth of integration capabilities are enabled in 
a secure way at DB level:

- import/export of clinical data under various formats (SOAP, CSV, JSON etc.)
- integration with third party reporting applications (Jasper, BI etc.)
- direct feed from wearables, high throughput data feeds etc.
- Indexing specific value points (f.e. blood pressure values)

More documentation about the concepts and architecture of EtherCIS is located [here](http://docs.ethercis.org/)

Please also have a look to our [roadmap](https://github.com/ethercis/ethercis/blob/master/ethercis-roadmap.md) for more details

What's new?
-----------
A number of enhanced features are now mainstream:

#### JWT authentication
See https://github.com/ethercis/ethercis/blob/master/doc/JWT.md

#### HTTP/SSL support and HTTP server configuration
Background on configuring SSL/Jetty at https://www.eclipse.org/jetty/documentation/current/configuring-ssl.html
A whole set of configuration parameters are now supported.
See https://www.eclipse.org/jetty/documentation/9.4.x/quickstart-config-what.html for Jetty configuration explanation.
See https://github.com/ethercis/deploy-n-scripts/blob/master/ethercis-install/v1.3.0/config/services.properties 
(section REST SERVER CONFIGURATION) for the actual parameters to use in EtherCIS

#### Enhanced JMX support
JMX is supported with user defined signature algorithm (see https://github.com/ethercis/ethercis/issues/161)
In particular, the following service have a better JMX support to use in production:
ServiceSecurityManager: to reload JWT secret
All other services: more info + runtime version

NB. JMX must be activated at JVM level. See https://www.oracle.com/technetwork/java/javaseproducts/mission-control/index.html
for usage

#### Role Based Permissioning
This feature is based on Role Impersonation at DB level. This strategy ensures that only users/roles with
granted rights can access parts of the CDR. This does also support multi-tenancy.
Understanding of PostreSQL permission framework is given at https://wiki.postgresql.org/wiki/Row-security
See https://github.com/ethercis/ethercis/blob/master/doc/RLS.md for more on this issue

#### SSL DB Connectivity
See https://github.com/ethercis/ethercis/blob/master/doc/EtherCIS-SSL.md

#### Library Upgrade
jOOQ 3.11
Jetty 9.4

#### Better Build Process
All build are now self-contained using Maven, that is no more 'exotic' libraries need to be installed locally.

#### Single Jar for Execution
Support very simple launch command line such as:

```markdown
java -jar lib/ethercis-1.3.0-SNAPSHOT-runtime.jar -propertyFile config/services.properties
```

#### GDPR Features
EHR Erasure: This allows now to delete entirely an EHR using a simple REST DELETE.
Audit Trail: see log4j.xml and logging.properties in https://github.com/ethercis/deploy-n-scripts/tree/master/ethercis-install/v1.3.0/config

Building EtherCIS
=====

To build the set of required libraries to run an EtherCIS server instance, you need to compile 3 sets of components:

- [openehr-java-libs](https://github.com/ethercis/openehr-java-libs) these are the low level openEHR RM/AM classes
used to represent the abstract [openEHR RM model](http://www.openehr.org/releases/trunk/UML/)
- [ehrservice](https://github.com/ethercis/ehrservice) this layer binds the persistence to the RM model including dealing
with templates etc. This is the actual core layer of the architecture
- [VirtualEhr](https://github.com/ethercis/VirtualEhr) is the projection of the core layer in services. Currently this
provides a REST API as described [here](http://docs.ethercis.org/APIs.html)

- You need to compile each module as indicated in their respective README (mvn clean install, this assumes a local 
PostgreSQL 10 install with the test database loaded). 
A global setting for the assembly of *uber* jars should be done in your `settings.xml`.

- EtherCIS can be launched with a Fat Executable JAR, see  https://github.com/ethercis/deploy-n-scripts/tree/master/ethercis-install/v1.3.0
for more details. The Fat jar is provided in this repository as well.

Note on building with Maven
---
For v1.3.0 all local libraries (e.g. the ones not found in Maven Central or compiled in previous steps) are provided
there is no need to install them locally

Project Structure
---
To allow various deployment and integration, the project is partitioned in two parts:

- core components: this part deals with OpenEhr object handling, serialization, deserialization, knowledge management and persistence
- service wrappers: this part encapsulate core components into a service framework with a REST API and JMX instrumentalization.

**Core Components**

The core modules are located in the repository [ehrservice](https://github.com/ethercis/ehrservice):

- core: fundamental operations and encoding of OpenEhr entities
- ehrdao: persistence of OpenEhr entities using a mixed model (relational/NoSql)
- knowledge-cache: caching of OpenEhr knowledge models (operational templates in particular)
- aql-processor: two passes SQL translation and query execution
- jooq-pg: utility module, binds ethercis table to jOOQ/Postgresql 9.4
- transform is mainly used to deal with raw json
- validation is responsible to check data input in relation to an openEHR template
- webtemplate implements template introspection
- db is used to perform DB configuration, upgrade and initial table loading in the case of a first install

**Service Wrappers**

The services and framework are located in [VirtualEhr](https://github.com/ethercis/VirtualEhr)

- `ServiceManager` service management framework
- `VEhrService` Query gateway of a running server instance
- `ResourceAccessService` a common service to access external resources (DB, knowledge etc.)
- `PartyIdentifiedService` wrapper to interact with OpenEhr PartyIdentified entities
- `LogonService` controls user login/logout and sessions
- `AuthenticationService` wrap a security policy provider
- `CacheKnowledgeService` wrapper of knowledge-cache to allow user queries
- `EhrService` deals with user queries on OpenEhr Ehr and Ehr Status objects
- `CompositionService` deals with user queries on Composition objects
- `QueryService` supports AQL/SQL querying

Please refer to the respective component's README for more details on the above

**openEHR Java Reference Library**
The modules used in EtherCIS are in [openehr-java-libs](https://github.com/ethercis/openehr-java-libs)

**Database**

EtherCIS requires PostgreSQL 10+.

The database is based on bi-temporal tables keeping records history. 
See [pgsql_ehr.ddl](https://github.com/ethercis/ehrservice/blob/remote-github/ehrdao/resources/ddls/pgsql_ehr.ddl) 
for more details on the actual structure and triggers.

The DB can be generated by running the above ddl script. DB `ethercis` should exist.

Tables TERRITORY, LANGUAGE and CONCEPT should be populated from openEHR local terminology definition contained in `terminology.xml`. 
Script `populate-concept` is provided to perform this task (see [ethercis/examples/scripts](https://github.com/ethercis/ethercis/tree/master/examples))

###### Required PostgreSQL extensions

<html>
<body>
<table border="1" style="border-collapse:collapse">
<tr><td>plpgsql</td><td>1.0</td><td></td></tr>
<tr><td>jsquery</td><td>1.0</td><td>https://github.com/postgrespro/jsquery</td></tr>
<tr><td>ltree</td><td>1.0</td><td>https://www.postgresql.org/docs/9.10/static/ltree.html</td></tr>
<tr><td>temporal_tables</td><td>1.0.2</td><td>http://pgxn.org/dist/temporal_tables/</td></tr>
<tr><td>uuid-ossp</td><td>1.0</td><td>https://www.postgresql.org/docs/9.5/static/uuid-ossp.html</td></tr>
</table>
</body>
</html>

####### Setting up the DB with Maven and flyway

See https://github.com/ethercis/ehrservice/tree/remote-github/ecisdb

## Upgrading from 1.2.0 to 1.3.0

1. File `services.properties` needs to be upgraded to use the new features. An example is given in the code base [here](https://github.com/ethercis/VirtualEhr/blob/master/VEhrService/src/test/resources/config/services.properties).
2. Upgrade the DB using flayway https://github.com/ethercis/ehrservice/tree/remote-github/ecisdb
3. Adapt the launch script using the single Fat JAR created with https://github.com/ethercis/deploy-n-scripts/tree/master/distribution

#### Using JWT
If you use JWT authentication, you will need to specify the key for verifying a token. The key can be given as a property (not recommended) or in a file. The file format is given [here](https://github.com/ethercis/VirtualEhr/blob/master/VEhrService/src/test/resources/config/security/jwt.cfg).

#### DAC and RLS security at DB level
This configuration applies whenever JWT authentication is specified and property `server.security.db_role` in `services.properties` is true. This performs a so-called *session impersonation* on the DB connection. 

The impersonation can be prioritized on user id or role. The role impersonation is possibly preferred since the DB privilege definitions is somewhat simpler. However, in a multi-tenancy environment, user based permission must be required. At this time, roles and permissions at DB level require DB administration skills. Documentation on how to perform these operations are described in Postgresql main site: [RLS](https://www.postgresql.org/docs/current/static/ddl-rowsecurity.html), [DAC](https://www.postgresql.org/docs/current/static/user-manag.html) and [MAC](https://www.postgresql.org/docs/current/static/sql-security-label.html) (if required).

## How To Run It?

- Script `ecis-server` should be adapted to get the right classpath, path to required configuration, network parameters etc.
- Ditto for all configuration files.

Script `ecis-server` uses *uber* jars to keep the modularity of the platform as well as to ease the production of patches. 
The jars are posted at [libraries](https://github.com/ethercis/ethercis/tree/master/libraries) until a better file repository is identified.

Documentation And Examples
-

In this section you will find:

- [Examples](https://github.com/ethercis/ethercis/tree/master/examples) scripts and configuration files to run ethercis on a Linux box. Scripts can be adapted to launch the server on  Windows if required.
- [Libraries](https://github.com/ethercis/ethercis/tree/master/libraries) some pre-compiled libraries to make life a bit easier (mostly xml bindings classes and one to avoid conflicts with the patches from the core module
- [Installation](https://github.com/ethercis/ethercis/tree/master/installation) documentation and readme's, mostly to install a system
- [Link to deploy scripts](https://github.com/ethercis/deploy-n-scripts) - towards enabling a quick and easy set up
- [Get authenticated & basic openEHR template list](https://github.com/ethercis/ethercis/blob/master/doc/Getting_%20authenticated_and_templateList_onEthercis.md) - to get authenticated and then the openEHR CDR template list to get started
- More info on the [REST API](https://github.com/ethercis/ethercis/blob/master/doc/rest%20api.md) and [FLAT JSON](https://github.com/ethercis/ethercis/blob/master/doc/flat%20json.md)
- [Composition Serialization and Query](https://github.com/ethercis/ethercis/blob/master/doc/serialization.md)

Changes
======

V1.3.0 (March 2019)
-----------------

- Tests, librairies, dependencies: CR#13, CR#14, CR#27, CR#60, CR#61, CR#87, CR#98, CR#123, CR#124
- Raw Json Support: CR#73, CR#118, CR#119
- Template Introspection: CR#74, CR#113, CR#114, CR#115, CR#125 
- AQL enhancements: CR#91, CR#92, CR#95, CR#100, CR#101, CR#111, CR#112, CR#116, CR#121, CR#69, CR#24
- Security: CR#64, CR#65

Was not a CR:

- REST Server configuration
- Template Data Cache
- DAC + row level security (RLS)


V1.2.0 (Jun 2018)
-----------------

- Tests, librairies, dependencies: CR#13, CR#14, CR#27, CR#60, CR#61, CR#87, CR#98, CR#123, CR#124
- Raw Json Support: CR#73, CR#118, CR#119
- Template Introspection: CR#74, CR#113, CR#114, CR#115, CR#125 
- AQL enhancements: CR#91, CR#92, CR#95, CR#100, CR#101, CR#111, CR#112, CR#116, CR#121, CR#69, CR#24
- Security: CR#64, CR#65

Was not a CR:

- REST Server configuration
- Template Data Cache
- DAC + row level security (RLS)

v1.1.2 (Apr 10 2018)
--------------------
This version merges Sheref's PR to allow CI using Travis.

There are several changes including:

- Tests are more or less operational but nevertheless work is needed to make them more meaningful (as well as coverage). To disable the tests, set maven skip test flag to ```true``` in the respective POMs:

            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>2.19</version>
                <configuration>
                    <skipTests>true</skipTests>
                </configuration>
            </plugin>

- This version now uses PostgreSQL v10+. This is due mainly to better support returning compositions from AQL under
a (canonical) JSON format. PostgreSQL 10 comes with interesting jsonb functions that makes this part easier since 
JSON encoding can be partially done at DB level (NB. in the future this encoding shall be totally performed at DB level). The corresponding DB functions are in a flyway migration [script](https://github.com/ethercis/ehrservice/blob/remote-github/db/src/main/resources/db/migration/V5__raw_json_encoding.sql)
which can be run manually

- To run the tests, it is expected that a DB is installed locally and contains test data. The test data can be restored
from a [backup file](https://github.com/ethercis/VirtualEhr/blob/master/file_repo/db_test/testdb-pg10.backup). The restore
can be done using PGAdmin4 (since we use PostgreSQL 10). An easy way to proceed is to CASCADE DELETE schema 'ehr' and perform the restore using pg_restore as described in this [document](https://github.com/ethercis/ethercis/blob/master/doc/DB%20administration.md). Please note that the referential integrity trigger must be disabled. 

The DB installation can be done using the script found [here](https://github.com/ethercis/deploy-n-scripts/blob/master/ethercis-install/v1.1.0/install-db.sh). The install process is described in the [deploy-n-scripts](https://github.com/ethercis/deploy-n-scripts) section.


Spring-is-almost-there Edition Feb 2018
---------------------------------------

##### Changes in library structure

Few changes in the Uber jar generation to remove pesky dependencies on, yet-to-be-removed, org.openehr legacy classes. This has an impact on the classpath of the launch script to hold few more jars not included into the Uber jars anymore. Please note this will be modified soon as we are migrating to a continuous integration framework with Docker image generation.

The changes consists in the following classpath addition in ecis-server script:

```
${APPLIB}/CompositionTemplate.jar:\
${APPLIB}/openEHR.v1.Template.jar:\
${APPLIB}/composition_xml.jar:\
${APPLIB}/openEHR.v1.OperationalTemplate.jar
```
The above libraries have been added to lib/application repository.

The main repository lib/deploy is updated with the latest changes.

##### Operational Template Introspection (CR #74)

A new feature now support OPT introspection. Useful to automate some client UI construct or others. 
It is also opening the door to further data analytics potential as introspection results can be used to further support complex DB queries. 
See documentation in [OPT introspection](https://github.com/ethercis/ethercis/blob/master/doc/OPT%20introspection.md "OPT introspection")

##### Full template querying returning a JSON object (CR #73)

This changes allows to get a whole composition from a template in JSON format. 

To integrate this feature, a number of steps are required:

- Migration of PostgreSQL to at least 9.6 (10 is recommended)
- Installation of the functions supporting JSON encoding at DB level. A script is provided to help in this process. 
See in [resources/raw_json_encoding](https://github.com/ethercis/ehrservice/tree/remote-github/db/src/main/resources/raw_json_encoding)

In the future, we plan to support most of encoding/retrieval/querying at DB level only (by-passing most of the middleware logic) for performance reason.

##### Multiple fixes and enhancements

Please see the list of closed/in-test CRs for more details.

## Product/Project Support
This product /project is supported by the Ripple Foundation, who aim to enhance the EtherCIS solution. 
We are working to fund as many of the enhancements of EtherCIS as we can based on projects that our non profit organisation supports.

We will try to fix any key bugs and documentation errors ourselves. Other issues, requests for enhancements or feature additions, will be added to the project backlog.

If you have a problem/issue/bug report, please log as an issue on this repo. 

If you want to ask the EtherCIS community a question/discuss an issue, after reading the documentation that is available, please visit our [Gitter chat channel for EtherCIS](https://gitter.im/Ripple-Foundation/EtherCIS)

The Ripple Foundation is committed to offering free and open software, with quality, free and open documentation, but unfortunately is unable to offer free support for all issues/pull requests.

(Our latest thinking on the best model to support our open platform mission in healthcare may best be understood by reading this article. https://opensource.com/business/16/4/refactoring-open-source-business-models

If you would like to offer some of your energy/ suggest other ideas towards progressing an open platform in healthcare, please contact us at info@ripple.foundation )

If you need support with a particular issue/pull request, please let us know and we can consider a bounty source (https://www.bountysource.com/), or indeed a formal project/support arrangement to get particular issues/requirements reviewed/ addressed.

Thanks for your interest in EtherCIS

The Ripple Foundation
http://ripple.foundation/
 
