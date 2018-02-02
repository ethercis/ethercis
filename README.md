## How to set up a development environment for EtherCis

EtherCIS code base is distributed over two git repositories. [EhrService](https://github.com/ethercis/ehrservice) and [VirtualEhr](https://github.com/ethercis/VirtualEhr)
EhrService is the core functionality such as database access, validation, knowledge repository functionality (opt files) etc. VirtualEhr is a service layer that sits on top of this core functionality and brings together these core libraries to provide services such as Ehr, Composition etc. VirtualEhr also contains a project with an embedded web server that allows REST API access to these services. Finally, the [ethercis](https://github.com/ethercis/ethercis) repository provides documentation and other artefacts which are not directly code but are relevant to both two other repositories.

### Directory layout
It is recommended that you create a development directory which contains three git repositories as follows:

```
development_directory/
├── ehrservice/
│   ├── pom.xml
│   ├── ...
│
├── ethercis/
│   ├── README.md
│   ├── ...
│
├── VirtualEhr/
│   ├── pom.xml
│   ├── ...
```
As seen in the diagram above, ehrservice and VirtualEhr repositories are configured to use the [maven](https://maven.apache.org/) build tool. The instructions for building EtherCIS are based on maven. Note that your IDEs (Intellij Idea, Eclipse etc) maven integration may not always be perfect. Therefore, it is recommended that you make sure that you can build EtherCis using maven from the command line first, before attempting to use your IDE, even though it provides maven based functionality. The following steps assume this directory layout is in place.

### Building EtherCis

#### Requirements
Development on Ethercis requires the following:
- Java 8
- Maven
- Docker or a standalone postgresql 10 installation with required extensions.

The build instructions below have been tested on Ubuntu 16.04 with Java 8 and maven 3.3.9. Docker version: 17.05.0-ce. 

#### Install third party libraries
Ethercis makes use of third party libraries which must be installed to your local maven repository for the code to compile and run. In order to install these libraries you can either run the install_3rd_party_jars.sh script or run the following commands which is the content of this script:

```
cd ehrservice/libraries

#required for the ehr core  (and probably for the vehr) repository
mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=openEHR.v1.OperationalTemplate-1.0.1.jar  -DgroupId=org.openehr  -DartifactId=openEHR.v1.OperationalTemplate -Dversion=1.0.1  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=openEHR.v1.Template-1.0.1.jar       -DgroupId=org.openehr  -DartifactId=openEHR.v1.Template -Dversion=1.0.1  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=openehr-am-rm-term-1.0.9.jar       -DgroupId=org.openehr  -DartifactId=openehr-am-rm-term -Dversion=1.0.9  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=applib/adl-parser-1.0.9.jar      -DgroupId=org.openehr  -DartifactId=adl-parser -Dversion=1.0.9  -Dpackaging=jar

#required for the Vehr repository
mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=ehrxml-1.0.0.jar       -DgroupId=ethercis  -DartifactId=ehrxml -Dversion=1.0.0  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=applib/session-logger-service-1.0-SNAPSHOT.jar       -DgroupId=ethercis  -DartifactId=session-logger-service -Dversion=1.0-SNAPSHOT  -Dpackaging=jar

cd 3rdparty

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=xml-serializer-1.0.9.jar      -DgroupId=org.openehr  -DartifactId=xml-serializer -Dversion=1.0.9  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=rm-builder-1.0.9.jar      -DgroupId=org.openehr  -DartifactId=rm-builder -Dversion=1.0.9  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=oet-parser-1.0.5.jar      -DgroupId=org.openehr  -DartifactId=oet-parser -Dversion=1.0.5  -Dpackaging=jar

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=thinkehr-framework-jsonlib-2.3.0-JL32.jar      -DgroupId=org.openehr  -DartifactId=thinkehr-framework-jsonlib -Dversion=2.3.0-JL32  -Dpackaging=jar

```

#### Install Postgresql and run db scripts
After you install the third party libraries, the first thing you need to do is to set up [postgresql](https://www.postgresql.org/) server and install required extensions for postgres. You may think that you can set up a database after you compile the code but **you cannot compile the code unless you have a database with tables etc. in place**. This is due to EtherCis using a data access layer that processes the database to generate source files. So you need to have a database, install tables etc, then perform code generation **before** you build EtherCis. 

Installation instructions in the Ethercis installer package TODO: GIVE LINK explain how you can install postgresql and required extensions. For the purposes of development, it is recommended that you use [Docker](https://www.docker.com/).  If you want to build a docker image locally, that is, use a dockerfile to cook the image on your own, the dockerfile used by this code base is here (TODO: GIVE LINK)
A previously build image based on the dockerfile linked above can be found [here](https://hub.docker.com/r/serefarikan/ethercis-pg/) The following command starts an ephemeral container of this image:
`docker run -d -it --rm  --name="pg-ethercis" -e POSTGRES_PASSWORD=postgres -p 5432:5432 serefarikan/ethercis-pg:v1`
you can stop this container by `docker stop pg-ethercis`
*(WARNING: Make sure that you read the note about docker at the end of this document)*

Once the postgresql image is up (you may want to run the command without -d to ensure that postgres started) you must generate the database tables, stored procedures etc. as follows:

```
cd ehrservice
./gradlew db:flywayMigrate
```

The command above uses [gradle](https://gradle.org/) to run [flyway](https://flywaydb.org/) Gradle is a build tool like maven but it is not needed to build anything in the Ethercis code base. You can think of it as a scripting tool used in this step to easily generate database artefacts. 

#### Install core Ethercis libraries to local maven repository
Once the database is running (in docker or standalone) and the tables etc are created, you can install core Ethercis libraries as follows:
```
cd ehrservice
mvn clean install -Dmaven.test.failure.ignore=true
```
The above command builds and installs core Ethercis libraries to your local maven repository. Note that this command runs the tests but ignores failures. This is because we want to know what tests are failing but we don't want maven to cancel the build, which is the default behaviour in case tests fail. You can find a report of test outcomes under the target/site directory that is created by maven. 

The above mvn command triggers the build and  generates the java code that Ethercis will use to access the db during the build (jooq-pq module). This is why you need to have the database running when you're installing core Ethercis libraries: without a db running, code generation would not work. 

#### Install VirtualEhr libraries to local maven repository
Once the installation of the core libraries is done, we can build the higher level services by doing the following:
```
cd VirtualEhr
mvn clean install -Dmaven.test.failure.ignore=true
```
The above mvn build makes use of the core libraries installed in the previous step and also runs tests in the same way. In case you'd like to confirm that your development setup can start EtherCis and use the REST API, run the following commands:

```
cd VirtualEhr/vehr-integration-tests
mvn integration-test -Dcucumber.options="--glue com.ethercis.vehr src/test/resources/features/RestApiAQL.feature"
```

The above mvn command will run a single feature file which will start the embedded server, put some data in and query it using Aql. This is a good round-trip scenario to confirm that your development setup is in place and you're able to run EtherCIS based on the code on your disk.

Once you've completed all these steps, you can now starting working on Ethercis code base knowing that you have a correctly configured development environment. 

#### A note about docker containers
Remember that running an ephemeral docker image means that the whole container is deleted once you stop it. This means the next time you create a new container based on this image, **you need to run the gradle script again, to make sure the database is in place**. You may prefer to not to run an ephemeral image and keep using the stopped container if you find yourself forgetting to do this. Also remember that if you somehow run `mvn install` for the core repository while the db server is running but without the tables in place, you'll overwrite required db access library in the local maven repository with an empty one! Be careful, since this would then lead to VirtualEhr services failing. 
