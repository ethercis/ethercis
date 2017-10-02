# EtherCIS Roadmap #

Updated September 04, 2017

This roadmap is based on

- current issue backlog 
- tickets present in the previous repository (Assembla).
- Features that are needed to deploy EtherCIS in a production environment
- Enhancements we think are useful in a foreseeable future 

The timeframe targets are tentatively aligned with feedback from users as well as deployment projects due sometime next year.
 
# Timeframes #

|Timeframe | Description|When|
|----------|------------|----|
|Immediate |CR's and bugs that need immediate attention, integrated in next release|Q4 17
|Short Term|CR's and required enhancements for a beta release in production|Q1 18
|Medium Term| CR's and enhancements needed to deploy EtherCIS fully in supervised production| Q3 18 |
|Long Term| Features and Enhancements required to deal with large scale deployment|2019

# Action Items

## Immediate ##

- Easy install script: install EtherCIS + configure DB in less than 5' from scratch
- Identify distribution strategy and repository
- Refactor dependency on org.openehr java ref library (no more partial dependency)
- Make tests not dependent on local configuration and DB state
- EtherCIS version numbering

## Short Term ##

### Core components
- Transactional create/update composition
- Better template handling
	- Referential integrity composition-template (now a template can be changed unilaterally)
	- DB based template caching + versioning
- AQL multiple fixes and enhancements
	- smarter type cast in queries (based on template constraints)
	- partial node predicates 
	- partial path
	- RAW JSON returned for whole object query (composition)
	- DISTINCT support
	- EXISTS support
- Identify and document simple FHIR/EtherCIS bridging
- ECISFLAT syntax/support fix (instruction UID, optional attributes etc.)

### Security
- JWT/OAuth support: authentication and authorization, RBAC
- OpenId support: resolve id token to user (openEHR contribution etc.)
- HTTPS
- Propagate security policies to DB (row level policies, roles etc.)

### Monitoring, Auditability
- Fully implement service monitoring with admin interaction (JMX, partially implemented at this stage). Plan to use Jolokia since JSR160 is problematic in VMs.
- Finalize Logging/auditing 

## Medium Term ##
- EtherCIS clustering: multiple EtherCIS server instances sharing common resources -> allow load balancing, horizontal scalability + fail over capability.
- Cached session management, depends on openEHR REST API conformance requirements
- DB Master/Slave configuration
- Enhanced connection pooling, transactional load balancer (bonecp, pgbouncer)
- Continuous integration, automated tests
- Maven central EtherCIS artefacts (jars)
- Multi Tenancy
- Partial openEHR REST API conformance

### Core components
- Distributed Knowledge service (Template Cache)

## Long Term

- Native FHIR integration
- JSON composition input/update
- DB sharding
- Full text search (used for narratives in composition, requires jsonb/Postgresql 9.10)
- openEHR DIRECTORY
- openEHR TASK
- Direct DB insert/update
- AQL path resolution at DB level
- AQL support of 'foreign' operators and functions (aggregation, math etc.)
- AQL querying of arrays returning denormalized dataset
- GDL
- Contribution signing support
- Full openEHR REST API conformance
- Non committed composition (draft composition)

# Completed Features

The following is a non exhaustive list of what has been done so far in the past months.

- RAW JSON support (AQL)
- Input validation based on Template constraints
- Example of trigger usage for indicators (patient summary cache)
- AQL multiple syntax and operators enhancements
- GraphQL query support (prototype, licensing needs clarification)
- Filling in the gaps with Marand's API (demonstrated)
