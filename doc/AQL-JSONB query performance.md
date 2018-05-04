AQL and JSONB querying. Performance Notes
---
C.Chevalley 04.05.18

A quick note (so I don't forget) about AQL querying optimization and tests done. This will be used as reference to do some (minor) changes in AQL->SQL translation in order to benefit of some radical optimization.

### Current Status

At the time of this writing, AQL->SQL translation does transcribe WHERE statement into some simple JSONB jsquery expressions. The resulting expression uses standard test operators, as describe in the [jsquery repository](https://github.com/postgrespro/jsquery).

Specifically, we use mostly binary _boolean_ operators:

	=
	>
	<

Although this works OK,  this approach doesn't allow benefiting from the specific JSONB indexing: [GIN](https://www.postgresql.org/docs/current/static/datatype-json.html#JSON-INDEXING). Specifically, we expect to get significant performance improvement by using the containment operator ```@>```

At the moment, a typical SQL query on an entry is as follows (we query composition based on template ```IDCR - Medication Statement List.v0```:

	select entry.composition_id
	from ehr.entry
	where
	(entry.entry #>>
	'{/composition[openEHR-EHR-COMPOSITION.medication_list.v0 and name/value=''Medication statement list''],/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1],0,/items[openEHR-EHR-INSTRUCTION.medication_order.v1],0,/activities,/activities[at0001],0,/description[at0002],/items[at0173],0,/value,value}')
	='Dose Amount'

=> execution time: 10 ms

Another approach would be to use a containment operator, the expression is now:

	select entry.composition_id
	from ehr.entry
	where
	(entry.entry #>>
	'{/composition[openEHR-EHR-COMPOSITION.medication_list.v0 and name/value=''Medication statement list''],/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1],0,/items[openEHR-EHR-INSTRUCTION.medication_order.v1],0,/activities,/activities[at0001],0,/description[at0002],/items[at0173],0,/value}')::jsonb
	@> '"value":"Dose Amount"}'

=> execution time: 11 ms (a bit slower...)

With some filtering (as it is done now):

	select entry.composition_id
	from ehr.entry
	where
	(entry.entry #>>
	'{/composition[openEHR-EHR-COMPOSITION.medication_list.v0 and name/value=''Medication statement list''],/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1],0,/items[openEHR-EHR-INSTRUCTION.medication_order.v1],0,/activities,/activities[at0001],0,/description[at0002],/items[at0173],0,/value,value}')
	='Dose Amount'
	and entry.template_id = 'IDCR - Medication Statement List.v0'

=> execution time: 1.4 ms (~ 7x faster)

NB. we have a BTREE index on entry.template_id

Assuming we target a large number of records, 1ms is still too slow.

### Indexing specific JSONB items

Proper, non trivial, indexing is done based on monitoring and calculating operational statistics on actual query executions. If for example, the above query is of interest (and performed frequently), we may want to index that particular part of the composition tree. An introspection of template 'IDCR - Medication Statement List.v0' shows the structure of the node ```/items[at0173]```:

	{
        "min": 0,
        "aql_path": "/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1]/items[openEHR-EHR-INSTRUCTION.medication_order.v1]/activities[at0001]/description[at0002]/items[at0173]",
        "max": 1,
        "name": "Dose timing description",
        "description": "A narrative description of a specific part of overall directions.",
        "id": "dose_timing_description",
        "category": "ELEMENT",
        "type": "DV_TEXT",
        "ethercis_sql": "\"ehr\".\"entry\".\"entry\" #>> '{/composition[openEHR-EHR-COMPOSITION.medication_list.v0 and name/value=''Medication statement list''],/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1],0,/items[openEHR-EHR-INSTRUCTION.medication_order.v1],0,/activities,/activities[at0001],0,/description[at0002],/items[at0173],0,/Value}'",
        "constraints": [
            {
                "aql_path": "/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1]/items[openEHR-EHR-INSTRUCTION.medication_order.v1]/activities[at0001]/description[at0002]/items[at0173]/value",
                "mandatory_attributes": [
                    {
                        "name": "Value",
                        "attribute": "value",
                        "id": "value",
                        "type": "STRING"
                    }
                ],
                "attribute_name": "value",
                "constraint": {
                    "occurrence": {
                        "min": 1,
                        "max_op": "<=",
                        "min_op": ">=",
                        "max": 1
                    }
                },
                "type": "DV_TEXT"
            },
            {
                "aql_path": "/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1]/items[openEHR-EHR-INSTRUCTION.medication_order.v1]/activities[at0001]/description[at0002]/items[at0173]/name",
                "mandatory_attributes": [
                    {
                        "name": "Value",
                        "attribute": "value",
                        "id": "value",
                        "type": "STRING"
                    }
                ],
                "attribute_name": "name",
                "constraint": {
                    "occurrence": {
                        "min": 1,
                        "max_op": "<=",
                        "min_op": ">=",
                        "max": 1
                    }
                },
                "type": "DV_TEXT"
            }
        ],
        "node_id": "at0173"
    }, 


The indexing of this node is done as follows:

	create index _at0173_entry 
	ON ehr.entry
	USING GIN (
	(
	  (entry.entry #>>
			'{/composition[openEHR-EHR-COMPOSITION.medication_list.v0 and name/value=''Medication statement list''],/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1],0,/items[openEHR-EHR-INSTRUCTION.medication_order.v1],0,/activities,/activities[at0001],0,/description[at0002],/items[at0173],0,/value}')::jsonb
	  )
	JSONB_PATH_OPS
	)

We index specifically the value tree of the node which sql path is specified in the template introspection (```ethercis_sql```).

Performing the query:

	select entry.composition_id
	from ehr.entry
	where
	(entry.entry #>>
	'{/composition[openEHR-EHR-COMPOSITION.medication_list.v0 and name/value=''Medication statement list''],/content[openEHR-EHR-SECTION.medication_medical_devices_rcp.v1],0,/items[openEHR-EHR-INSTRUCTION.medication_order.v1],0,/activities,/activities[at0001],0,/description[at0002],/items[at0173],0,/value}')::jsonb
	@> '{"value":"Dose Amount"}'


=> execution time: 0.09 ms (> 100x faster)

By comparison, using a boolean expression doesn't show any improvement in the speed of execution without a GIN index (still > 1 ms).

In conclusion, using the containment operator ```@>``` in conjunction with a related GIN index offers significant query speed improvement and should be used whenever required.


