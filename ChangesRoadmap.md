Changes 
----
#####Ethercis-1.1.1 (December 2016)
Multiple AQL fixes and enhancements.

In particular, item structure names are now explicit in the jsonb structure. This allows to support queries in the form:

	b_a/name/value as type

Where

	contains EVALUATION b_a[openEHR-EHR-EVALUATION.clinical_synopsis.v1]

Current system should upgrade their DB using the migration utility
 
	migrate-db-aql

See in example section.

#####Ethercis-1.1.1 (November 2016)
This new snapshot contains various optimization to speed up AQL queries and composition retrieval. In  particular the AQL -> SQL translation produce quicker queries. NB. a number of indexes should be created, see pgsql_ehr.ddl in module jooq-pg for details. On the composition retrieval side, more local caching of Locatable re-usable structures is performed.

New format supported for compositions: RAW json. Sould be specified in the query as format=RAW.

Queries (both SQL and AQL) can be passed in a POST

Better database connection pooling using DBCP2. DB auto reconnection is activated by setting 

	server.persistence.dbcp2.test_on_borrow = true

in the DBCP2 section of services.properties

######Fixed various issues

- Shiro authenticate with authentication status kept at global thread level. This caused that any further authentication was granted regardless of credentials.
- REST API NPE
- Handling of itemlist 

######Enhancements

- Knowledge cache can be reloaded via the REST API (template/reload). Convenient if you upload templates directly into the knowledge directory (/etc/opt/ecis/knowledge).
- CORS should work better now, added (much) more allowed headers including Ehr-Session 

######To use this version please note the following

- Create the indexes in the database

		--- CREATED INDEX
		CREATE INDEX label_idx ON ehr.containment USING GIST (label);
		CREATE INDEX comp_id_idx ON ehr.containment USING BTREE(comp_id);
		CREATE INDEX gin_entry_path_idx ON ehr.entry USING gin(entry jsonb_path_ops);
		CREATE INDEX template_entry_idx ON ehr.entry (template_id);
		
		-- to optimize comp_expand, index FK's
		CREATE INDEX entry_composition_id_idx ON ehr.entry (composition_id);
		CREATE INDEX composition_composer_idx ON ehr.composition (composer);
		CREATE INDEX composition_ehr_idx ON ehr.composition (ehr_id);
		CREATE INDEX status_ehr_idx ON ehr.status (ehr_id);
		CREATE INDEX status_party_idx ON ehr.status (party);
		CREATE INDEX context_facility_idx ON ehr.event_context (facility);
		CREATE INDEX context_composition_id_idx ON ehr.event_context (composition_id);
		CREATE INDEX context_setting_idx ON ehr.event_context (setting)

- Update your ecis-server script to include the new service ecis-query library (see ecis-server in the examples)

		${LIB}/ecis-query-service-1.0.0-SNAPSHOT.jar:\

- DBCP2 connection type must be configured in services.properties (see in examples)

		#this configuration uses DBCP2
		server.persistence.implementation=jooq_dbcp2
		server.persistence.jooq.dialect=${jooq.dialect}
		server.persistence.jooq.url=${jooq.url}
		server.persistence.jooq.login=${jooq.login}
		server.persistence.jooq.password=${jooq.password}
		server.persistence.jooq.max_connections=100
		server.persistence.dbcp2.max_wait = 60
		server.persistence.dbcp2.set_pool_prepared_statements = true
		#server.persistence.dbcp2.set_max_prepared_statements = 200
  

#####Ethercis-1.1.1 (September 2016)
This is a new snapshot version with a number of bug fixes and improvements:

- Ehr status other_details (support input under RAW JSON format) including AQL queries
- Cleaned up AQL grammar (Lexer problem is solved)
- Support ARCHETYPEID in node predicate (AQL)
- Slightly modified persisted entry (jsonb)
- EtherCIS REST API can be configured to use Asynchronous queries
- Use log4j v2
- DB connections using connection pooling
- Multiple bug fix and got rid of numerous NPEs...

A utility (see in examples/scripts/migrate-db-aql) can be used to migrate a current DB to the new format

See also examples/config/services.properties for connection pooling configuration

	server.persistence.implementation=jooq_pg_pool

The asynchronous query mode can be set in service.properties:

	server.query.asynchronous=true
	server.threadpoolsize=20
	server.callback_timeout=10000


#####Ethercis-1.1.1 (August 2016)
- Supports validation

**NOTE**
Currently, the libraries supporting validation are:

	ecis-core-1.1.1-SNAPSHOT.jar
	ecis-validation-1.0-SNAPSHOT
 
The other libraries are unchanged. If you want to use the validation, please upload the two above jar files and change ecis-server script accordingly.

The validation can be disabled at run time with the following JVM property

	-Dvalidation.lenient=true


#####Ethercis-1.1.0 (July 2016)

- Support AQL query
- Changes in the JSONB entry structure:
	- better usage of arrays for /items
	- removed node name (name/value) in json key (but still kept in full path expressions)
- Changes in DB structure
	- added a CONTAINMENT table based on postgresql ltree as a pseudo index to resolve CONTAINMENT clause
	- added a view COMP_EXPAND to simplify SQL encoding
- use jOOQ 3.7, modified SQL query encoding to use dynamic query parts
- migration utility to migrate a 1.0.0 DB to 1.1.0 (com.ethercis.dao.access.util.MigrateEntry)
- fixed many bugs in composition serialization/building

Roadmap
--
- Q3 2016: Input validation based on Template/Archetype constraints (Done)
- Q3 2016: support ehr status other_details and other_context in AQL queries
- Q4 2016: Support of more AQL operators and predicates. Optimization of queries, indexing