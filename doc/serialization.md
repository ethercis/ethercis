# Serialization

The following details some important Ethercis internals. 

## Composition Serialization

A Composition is traversed to identify each element/attribute which value has been changed. The change is specified by a boolean. The composition content (entry) is serialized into a json structure similar to the following:

    {
      "openEHR-EHR-COMPOSITION.report.v1": {
        "openEHR-EHR-SECTION.history_rcp.v1": [
          {
            "openEHR-EHR-EVALUATION.reason_for_encounter.v1": [
              {
                "at0001": {
                  "at0004": {
                    "/name": "Question to MDT",
                    "/value": {"value": "Increasing back pain"},
                    "/$PATH$": "/content[openEHR-EHR-SECTION.history_rcp.v1]/items[openEHR-EHR-EVALUATION.reason_for_encounter.v1]/data[at0001]/items[at0004]",
                    "/$CLASS$": "DvText"
                  }
                }

An element is serialized with the following attributes:

- name: the name as found in the composition
- value: the element/attribute value formatted depending to the data type. The value depending on the type consists of a structured representation
- the full path to this element/attribute: the path is used to assign values of element attributes in the composition. It is also used to set specialized indexes (example: partial index on diastolic BP from archetype blood pressure regardless of the current template).
- A class name used to rebuild the data value object from the value structure

The template structure is projected into the json structure (it is a TreeMap), it allows using json specialized queries as discussed in PostgreSQL 9.4 [json functions and operators](http://www.postgresql.org/docs/9.4/static/functions-json.html)

## Queries

Querying in the DB involves mixing SQL and JSON functions and operators. For example, the following query selects the compositions id and entry where the SNELLEN visual acuity = '20/10' measured 28/08/2015 at around 7am :

    select * from (
    	select composition_id, entry.entry #>> '{openEHR-EHR-COMPOSITION.section_observation_test.v2,
    	openEHR-EHR-SECTION.visual_acuity_simple_test.v1, 0,
    		at0025, 0,
    			openEHR-EHR-OBSERVATION.visual_acuity.v1, 0,
    				at0001, [events],
    					at0002, 0,
    						/time, /value, value}' AS event_time from ethercis.ehr.entry

    where template_id LIKE 'section observation test.oet'
    	and entry.entry #>> '{openEHR-EHR-COMPOSITION.section_observation_test.v2,
    openEHR-EHR-SECTION.visual_acuity_simple_test.v1, 0,
    		at0025, 0,
    			openEHR-EHR-OBSERVATION.visual_acuity.v1, 0,
    				at0001, [events],
    					at0002, 0,
    						at0003,
    							at0053,
    								at0028, 0,
    									at0009, 0,
    						/value, /value, value}' = '20/10') SNELLEN

			where event_time LIKE '2015-08-28T07%';
            
NB. Whenever an array is used in the structure, an index should be specified unless a json array function is used to perform a transformation. For loop on array element is supported to perform  queries on a set if required.

Assuming the REST API is used to perform the query, a resultset as follows is returned:

     "resultSet": [
        {
          "composition_id": "256dfcc1-5b0d-460f-b61f-17f96354460b",
          "event_time": "2015-08-28T07:50:34.394+07:00"
        }
      ]


