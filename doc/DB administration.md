# EtherCIS DB Basic Administration #

CCH, 12.06.2017

## Background information

EtherCIS DB consists in three types of relational tables

- openEHR RM persistence: where the actual compositions, EHR data are actually stored
- Template-headings: reflect the associations between operational templates and *headings* used to build cache summaries
- openEHR static data: these are tables containing references including: concepts, languages and territories codifications

## Backup and Restore

Make sure you perform a DB backup prior cleaning up the DB.

Backup using postgres is done using `pg_dump` . It is generally located at:

	/usr/bin/pg_dump

The actual options used are the following

	/usr/bin/pg_dump 
		--host 192.168.2.113 
		--port 5432 
		--username "postgres" 
		--no-password  
		--format custom 
		--blobs
		--verbose 
		--file "<destination backup file path with extension>" 
		--schema "ehr" "ethercis"

NB. format **custom** is the recommended format. 

On Windows: 

```
C:\PostgreSQL\10\bin\pg_dump --username postgres --no-password --format custom --blobs --verbose --file ehr_dump.custom --schema "ehr" "ethercis"
```
On a remote server, using from a shell

	 pg_dump --host localhost --port 5432 --username "postgres" --no-password --format custom --blobs --verbose --file ./ethercis-170612.custom.bak --schema "ehr" "ethercis"

See pg_dump [documentation](https://www.postgresql.org/docs/current/static/app-pgdump.html) for more details.

Reciprocally, to restore the DB, we use `pg_restore` for instance with the following options:

	/usr/bin/pg_restore 
		--host localhost 
		--port 5434 
		--username "postgres" 
		--dbname "ethercis" 
		--no-password  
		--section data 
		--disable-triggers 
		--no-data-for-failed-tables 
		--verbose 
		"<backup file path with extension>"


The following parameters are useful

- **section data**: direct to restore data only (eg. no schema, functions etc.)
- **disable-triggers**: do not enforce referential integrity during restore
- **no-data-for-failed-tables**: do not complain if data are duplicated for instance (static data tables f.e.)

See pg_restore [documentation](https://www.postgresql.org/docs/current/static/app-pgrestore.html) for more details.

## Cleaning up the DB

Since the clean-up consists in deleting openEHR RM persisted data, simple SQL commands can be used to invoke function purge_db()


### Example with PostMan

	{"sql":
		"
		SELECT * from ehr.purge_db();
		"
	}

Should return (warning: a bit slow...)

	{
	    "executedSQL": "\r\n\tSELECT * from ehr.purge_db();\r\n\t",
	    "resultSet": [
	        {
	            "purge_db": "Persisted RM data deleted..."
	        }
	    ]
	}

### From a shell

 	#psql -U postgres -c "select * from ehr.purge_db()" ethercis

### From Webmin (if applicable)

Access Postgresql server plugin:

`Servers->PostgreSQL Database`

Select database ethercis

Execute SQL:

`SELECT * from ehr.purge_db();`


## Note on Function purge_db()

The function uses DDL statement TRUNCATE, this implies it request an exclusive lock on each table. The lock may cause significant delays during the execution. 

To check if the function is properly installed, `psql` can be used

	#psql -U postgres ethercis

	#\df ehr.*

	Schema |                  Name                   | Result data type |                                                          Argument data types                                                           |  Type
	--------+-----------------------------------------+------------------+----------------------------------------------------------------------------------------------------------------------------------------+---------
	 ehr    | cache_summary_delete_trigger            | trigger          |                                                                                                                                        | trigger
	 ehr    | cache_summary_update_insert_trigger     | trigger          |                                                                                                                                        | trigger
	 ehr    | create_items_dv_count                   | json             | text, bigint, text                                                                                                                     | normal
	 ehr    | create_items_dv_date_time               | json             | text, timestamp with time zone, text                                                                                                   | normal
	 ehr    | encode_node_name                        | json             | text                                                                                                                                   | normal
	 ehr    | entry_versioning_trigger                | trigger          |                                                                                                                                        | trigger
	 ehr    | event_context_versioning_delete_trigger | trigger          |                                                                                                                                        | trigger
	 ehr    | event_context_versioning_upsert_trigger | trigger          |                                                                                                                                        | trigger
	 ehr    | get_cache_committer                     | uuid             |                                                                                                                                        | normal
	 ehr    | get_cache_system                        | uuid             |                                                                                                                                        | normal
	 ehr    | init_other_context                      | void             |                                                                                                                                        | normal
	 ehr    | is_event_context_summary_cache          | boolean          | uuid                                                                                                                                   | normal
	 ehr    | other_context                           | jsonb            |                                                                                                                                        | normal
	 ehr    | other_context_for_ehr                   | jsonb            | uuid                                                                                                                                   | normal
	 ehr    | other_context_summary_field             | jsonb            | timestamp with time zone, bigint, timestamp with time zone, bigint, timestamp with time zone, bigint, timestamp with time zone, bigint | normal
	 ehr    | purge_db                                | text             |                                                                                                                                        | normal
	 ehr    | set_cache_for_ehr                       | uuid             | uuid                                                                                                                                   | normal
	 ehr    | update_cache_for_ehr                    | uuid             | uuid                                                                                                                                   | normal
	(18 rows)

	(to get the function definition)

	# \df+ ehr.purge_db

	CREATE OR REPLACE FUNCTION ehr.purge_db()
	 RETURNS text
	 LANGUAGE plpgsql
	AS $function$   BEGIN     TRUNCATE     ehr.compo_xref,     ehr.containment,     ehr.ehr,     ehr.entry_history,     ehr.composition_history,     ehr.event_context,     ehr.event_context_history,     ehr.participation_history,     ehr.contribution_history,     ehr.status_history,     ehr.party_identified,     ehr.system,     ehr.entry,     ehr.participation,     ehr.event_context,     ehr.party_identified,     ehr.identifier,     ehr.composition,     ehr.contribution CASCADE;     RETURN 'Persisted RM data deleted...';   END   $function$
	
	(NB. This is into VI, exit by <ESC> q!)

 	
	
