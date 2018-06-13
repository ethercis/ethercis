# EtherCIS Roadmap #

Updated March 01, 2018

We will create quarterly minor releases on the following schedule:

- EtherCIS v1.2: June 1st, 2018
- EtherCIS v1.3: August 31st, 2018
- EtherCIS v1.4: November 30th, 2018
- EtherCIS v1.5: March 1st, 2019

As a rule of thumb, we introduce CRs fixes (and PRs wherever applicable) into releases as well as new features and enhancements depending on various factors such as requirements from projects, users suggestions, things we want to do (because we think they are cool) etc.

In between, whenever needed, we will release patches to fix critical issues as required. Patches are not intended to introduce new features/enhancements. Nevertheless GitHub code base will be updated in between to allow intermediary cut to be produced locally.  

The following are some kind of pre-announcements and should be considered as tentative schedule for the above releases.

## EtherCIS v1.2: June 1st, 2018

- Changes in building EtherCIS and Continuous Integration (merge from [Seref Arikan](https://github.com/serefarikan) great contribution). This will also enable creating Docker images to easily deploy runtime environment.
- EtherCIS libraries in Maven Central
- EtherCIS and CDR security
- AQL enhancements
	- smart type cast
	- array querying
	- name/value node predicate in path

NB. As of this version, the build tool will be Maven only. The reason is that we simply don't have the resources to deal with multiple build strategy.

## EtherCIS v1.3: August 31st, 2018

- DB based template caching and referential integrity
- Canonical JSON composition CRU + optimized persistence processing
- Demographic (RM) support in AQL with DB integration
- More AQL enhancements (nesting, stored queries, arithmetic, ADL matching)
 	- partial path
	- EXISTS operator

## EtherCIS v1.4: November 30th, 2018

- openEHR REST API v1.0 conformance
- Full text search on embedded jsonb fields (f.e. medical notes)

## EtherCIS v1.5: March 1st, 2019

Much to discuss still, what's come to mind are possibly:

- DB sharding
- Full text search (used for narratives in composition)
- openEHR DIRECTORY
- openEHR TASK
- Contribution signing support
- Non committed composition (draft composition)
- TBD
