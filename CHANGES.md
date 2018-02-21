Changes to Ethercis code base
========

This document is a summary of changes to EtherCIS code base.


Why?
-----------

There are two main goals for the piece of work that led to these changes:
- Establish a test driven development setup for Ethercis code base
- Integrate Ethercis repositories with a continuous build tool
An implicit goal related to both main goals is **to make is as easy as possible to get started with EtherCIS development**.

The changes required to achieve these goals are explained below. Note that these goals have overlapping aspects: a test driven development setup means tests should be executed in the continuous build environment and therefore both a developer's local development setup and continuous build environment's settings should be considered etc. 

Establish a test driven development setup for Ethercis code base
-----------
In order to arrive at a test driven setup, we need to leverage a build tool which will run unit and integration tests. Most of Ethercis code base uses maven with the exception of a repository that uses flyway integration to graddle to create the required database schemas.  Therefore, based on the discussions and resulting agreement, maven is kept as the build tool. 

The largest set of changes in the code base are related to maven. In fact, there are very little changes to actual java code that existed prior to this piece of work. Here is a set of changes to introduce a test driven development setup:

- Directory layout of all the projects that use maven (maven modules) are refactored so that maven plugins for unit and integration testing can find the tests at the default locations expected by maven. The non-test code directory layouts were mostly the same as the defaults so they have not changed much. An exception to this would be aql parser and jooq-pg projects: these two projects had wrong configurations in place to generate required source code and they were modified accordingly to fix this problem.

- Global settings.xml file for configuring maven was removed and the values it contained were copied over to individual root poms. The reasoning behind this is the fact that these values do not change that much and adding a settings file to a specific location is one more step in setting up a development environment which can be avoided. Finally: given an automated, maven driven test setup is the goal here, some variables defined in this settings file are likely to be eliminated anyway, instead referring to default or relative to build path locations.

- A docker image is created, based on a docker build file, in order to provide a postgresql installation with all the required extensions in place. This image is then used by the gradle/flyway integration to create the tables and later by the jooq-pg project to create java sources based on these tables. The same image is used by the Travis continuos integration tool to run tests in the hosted/cloud environment.

- Maven configuration for surefire maven unit test plugin is provided accross all projects that contain unit tests, so that unit tests can be run as part of builds.

- A project that makes use of Cucumber, a Behaviour Driven Development tool, is added to VirtualEhr repository. This is the recommended approach for describing and tracking the behaviour of Ethercis in a humanly readable but executable language. Cucumber is integrated to maven via its related plugin.

Integrate Ethercis repositories with a continuous build tool
---

Both the core components and service wrappers repositories are integrated to Travis continuous integration tool. This tool provides excellent integration with github and it allows bash scripts to be written to handle different phases of the build, which allows a very flexible build setup. 

Travis does not provide a file storage or publishing service, therefore, it is not possible to to access automatically generated artefacts from a build such as test reports. Therefore, a few bash scripts were used to publish test results in another github repository dedicated to this purpose. These scripts are triggered after successful builds and publish key reports and information to the github repository, which can be used as a report page for builds. 

Travis also does not support defining dependencies between github repositories so that commits automatically trigger builds. Again, bash scripting is used to build core components repository when a change to service wrappers is committed. This mechanism is quite flexible and can be extended to cover various cases. 

Current status
---

As things stand, the fork of Ethercis used for this work is now fairly easy to clone and build/run locally, assuming there is a docker installation in place to run the postgresql server.

This fork is behind the official Ethercis code base but changes to java code base should be easy to add to this fork, making it up to date in terms of code but in a structure that allows local development and community contributions easier, especially due to use of testing frameworks and continuous integration.


 
