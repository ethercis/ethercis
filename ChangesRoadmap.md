Changes 
----
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
- Q3 2016: Input validation based on Template/Archetype constraints
- Q4 2016: Support of more AQL operators and predicates. Optimization of queries, indexing