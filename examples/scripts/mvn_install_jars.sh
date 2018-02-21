#!/bin/bash

cd ../../libraries/

#required for the ehr core  (and probably for the vehr) repository
mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=openEHR.v1.OperationalTemplate-1.0.1.jar  -DgroupId=org.openehr  -DartifactId=openEHR.v1.OperationalTemplate -Dversion=1.0.1  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=openEHR.v1.Template-1.0.1.jar       -DgroupId=org.openehr  -DartifactId=openEHR.v1.Template -Dversion=1.0.1  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=openehr-am-rm-term-1.0.9.jar       -DgroupId=org.openehr  -DartifactId=openehr-am-rm-term -Dversion=1.0.9  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=applib/adl-parser-1.0.9.jar      -DgroupId=org.openehr  -DartifactId=adl-parser -Dversion=1.0.9  -Dpackaging=jar 

#required for the Vehr repository
mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=ehrxml-1.0.0.jar       -DgroupId=ethercis  -DartifactId=ehrxml -Dversion=1.0.0  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=applib/session-logger-service-1.0-SNAPSHOT.jar       -DgroupId=ethercis  -DartifactId=session-logger-service -Dversion=1.0-SNAPSHOT  -Dpackaging=jar 

cd ../../ehrservice/3rdparty/

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=xml-serializer-1.0.9.jar      -DgroupId=org.openehr  -DartifactId=xml-serializer -Dversion=1.0.9  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=rm-builder-1.0.9.jar      -DgroupId=org.openehr  -DartifactId=rm-builder -Dversion=1.0.9  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=oet-parser-1.0.5.jar      -DgroupId=org.openehr  -DartifactId=oet-parser -Dversion=1.0.5  -Dpackaging=jar 

mvn org.apache.maven.plugins:maven-install-plugin:2.5.2:install-file  -Dfile=thinkehr-framework-jsonlib-2.3.0-JL32.jar      -DgroupId=org.openehr  -DartifactId=thinkehr-framework-jsonlib -Dversion=2.3.0-JL32  -Dpackaging=jar 
