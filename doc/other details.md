#Ehr Status other_details

This is a sort description of other_details handling.

##Background
Ehr Status other details is an archetype structure allowing passing various data extending Ehr attributes. This structure is further described in Ehr IM, [EHR_STATUS specification](http://www.openehr.org/releases/RM/latest/docs/ehr/ehr.html#_ehr_status_class "EHR_STATUS").

As for other archetyped structure, the actual other details Item Structure is serialized in a JSON map stored in the the DB table ehr.status.

##XML Representation
Conventionally and to minimize changes in XML binding code (in particular SSD schemas), we decided to represent other_details as an ItemList. For example, the following is a valid representation for other details:


	<items xmlns="http://schemas.openehr.org/v1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" archetype_node_id="openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0">
	    <name>
	        <value>Person anonymised parents</value>
	    </name>
	    <items xmlns:v1="http://schemas.openehr.org/v1" archetype_node_id="at0001" xsi:type="v1:CLUSTER">
	        <name>
	            <value>person</value>
	        </name>
	        <items archetype_node_id="openEHR-EHR-CLUSTER.person_anoymised_parent.v0" xsi:type="v1:CLUSTER">
	            <name>
	                <value>Person anonymised parent</value>
	            </name>
	            <archetype_details>
	                <archetype_id>
	                    <value>openEHR-EHR-CLUSTER.person_anoymised_parent.v0</value>
	                </archetype_id>
	                <rm_version>1.0.1</rm_version>
	            </archetype_details>
	            <items archetype_node_id="at0002" xsi:type="v1:ELEMENT">
	                <name>
	                    <value>Administrative Gender</value>
	                </name>
	                <value xsi:type="v1:DV_CODED_TEXT">
	                    <value>Male</value>
	                    <defining_code>
	                        <terminology_id>
	                            <value>local</value>
	                        </terminology_id>
	                        <code_string>at0003</code_string>
	                    </defining_code>
	                </value>
	            </items>
	            <items archetype_node_id="at0006" xsi:type="v1:ELEMENT">
	                <name>
	                    <value>Birth Sex</value>
	                </name>
	                <value xsi:type="v1:DV_CODED_TEXT">
	                    <value>Male</value>
	                    <defining_code>
	                        <terminology_id>
	                            <value>local</value>
	                        </terminology_id>
	                        <code_string>at0007</code_string>
	                    </defining_code>
	                </value>
	            </items>
	            <items archetype_node_id="at0009" xsi:type="v1:ELEMENT">
	                <name>
	                    <value>Vital Status</value>
	                </name>
	                <value xsi:type="v1:DV_CODED_TEXT">
	                    <value>OK</value>
	                    <defining_code>
	                        <terminology_id>
	                            <value>local</value>
	                        </terminology_id>
	                        <code_string>at0010</code_string>
	                    </defining_code>
	                </value>
	            </items>
	            <items archetype_node_id="at0012" xsi:type="v1:ELEMENT">
	                <name>
	                    <value>Birth Year</value>
	                </name>
	                <value xsi:type="v1:DV_DATE">
	                    <value>2013-01-01</value>
	                </value>
	            </items>
	        </items>
	    </items>
	</items>

The XML representation is parsed and bound to an equivalent RM representation.

###RM Binding
The root element of an XML representation is used to identify the actual class of the Item Structure, the following are currently supported:

- ITEM_TREE
- ITEM_SINGLE
- ITEM_TABLE
- ITEM_LIST
- CLUSTER
- ELEMENT

##Serialization
Once the XML representation is bound to its RM equivalent structured it is serialized to be persisted in the DB. The serialization is similar to other archetyped structure (care entries and other_context). To simplify the table structure and keep it consistent, the template Id is passed as a key value pair into the serialized representation. For example, the above XML data structure is serialized as follows:

	{
	  "$TEMPLATE_ID$": "person anonymised parent",
	  "/other_details[openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0 and name/value='Person anonymised parents']": {
	    "/items[at0001 and name/value='person']": {
	      "/items[openEHR-EHR-CLUSTER.person_anoymised_parent.v0]": [
	        {
	          "/items[at0002]": [
	            {
	              "/value": {
	                "/name": "Administrative Gender",
	                "/value": {
	                  "value": "Male",
	                  "definingCode": {
	                    "codeString": "at0003",
	                    "terminologyId": {
	                      "name": "local",
	                      "value": "local"
	                    }
	                  }
	                },
	                "/$PATH$": "/items[openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0 and name/value='Person anonymised parents']/items[at0001 and name/value='person']/items[openEHR-EHR-CLUSTER.person_anoymised_parent.v0 and name/value='Person anonymised parent']/items[at0002 and name/value='Administrative Gender']",
	                "/$CLASS$": "DvCodedText"
	              }
	            }
	          ],
	          "/items[at0006]": [
	            {
	              "/value": {
	                "/name": "Birth Sex",
	                "/value": {
	                  "value": "Male",
	                  "definingCode": {
	                    "codeString": "at0007",
	                    "terminologyId": {
	                      "name": "local",
	                      "value": "local"
	                    }
	                  }
	                },
	                "/$PATH$": "/items[openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0 and name/value='Person anonymised parents']/items[at0001 and name/value='person']/items[openEHR-EHR-CLUSTER.person_anoymised_parent.v0 and name/value='Person anonymised parent']/items[at0006 and name/value='Birth Sex']",
	                "/$CLASS$": "DvCodedText"
	              }
	            }
	          ],
	          "/items[at0009]": [
	            {
	              "/value": {
	                "/name": "Vital Status",
	                "/value": {
	                  "value": "OK",
	                  "definingCode": {
	                    "codeString": "at0010",
	                    "terminologyId": {
	                      "name": "local",
	                      "value": "local"
	                    }
	                  }
	                },
	                "/$PATH$": "/items[openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0 and name/value='Person anonymised parents']/items[at0001 and name/value='person']/items[openEHR-EHR-CLUSTER.person_anoymised_parent.v0 and name/value='Person anonymised parent']/items[at0009 and name/value='Vital Status']",
	                "/$CLASS$": "DvCodedText"
	              }
	            }
	          ],
	          "/items[at0012]": [
	            {
	              "/value": {
	                "/name": "Birth Year",
	                "/value": {
	                  "value": "2013-01-01",
	                  [...]
	                },
	                "/$PATH$": "/items[openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0 and name/value='Person anonymised parents']/items[at0001 and name/value='person']/items[openEHR-EHR-CLUSTER.person_anoymised_parent.v0 and name/value='Person anonymised parent']/items[at0012 and name/value='Birth Year']",
	                "/$CLASS$": "DvDate"
	              }
	            }
	          ]
	        }
	      ]
	    }
	  }
	}

##Structure Retrieval
The RM structure is rebuilt from its json representation using the template as model. The process is similar to the one used for Care Entries and Other Context. In this case, a singular Locatable is built. The resulting Locatable is then projected as an XML or JSON representation depending on the use case.

##Passing other_details in a query
If other_details is to be set, the query body should contain a JSON string as follows:

	{
		"otherDetails":"\u003citems xmlns\u003d\"http://schemas.openehr.org/v1\" xmlns:xsi\u003d\"http://www.w3.org/2001/XMLSchema-instance\" archetype_node_id\u003d\"openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0\"\u003e\n    \u003cname\u003e\n        \u003cvalue\u003ePerson anonymised parents\u003c/value\u003e\n    \u003c/name\u003e\n    \u003citems xmlns:v1\u003d\"http://schemas.openehr.org/v1\" archetype_node_id\u003d\"at0001\" xsi:type\u003d\"v1:CLUSTER\"\u003e\n        \u003cname\u003e\n            \u003cvalue\u003eperson\u003c/value\u003e\n        \u003c/name\u003e\n        \u003citems 
			[...]  
		\u003c/items\u003e\n\u003c/items\u003e",
		"otherDetailsTemplateId":"person anonymised parent"
	}

NB. the above example shows an HTML escaped encoded string as per json convention.

##Other Details Query

Whenever querying EhrStatus, the following is returned:

	{
	  "ehrStatus" : {
	    "queryable" : true,
	    "subjectIds" : {
	    },
	    "systemSettings" : "18-03-73-AF-0F-7C|christian-PC",
	    "otherDetails" : "<![CDATA[<items  xmlns=\"http://schemas.openehr.org/v1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" archetype_node_id=\"openEHR-EHR-ITEM_TREE.person_anonymised_parents.v0\">\r\n    <name>\r\n        <value>Person anonymised parents</value>\r\n    </name>\r\n    <items xmlns:v1=\"http://schemas.openehr.org/v1\" archetype_node_id=\"at0001\" xsi:type=\"v1:CLUSTER\">\r\n        <name>\r\n            <value>person</value>\r\n        </name>\r\n        <items archetype_node_id=\"openEHR-EHR-CLUSTER.person_anoymised_parent.v0\" xsi:type=\"v1:CLUSTER\">\r\n            <name>\r\n                <value>Person anonymised parent</value>\r\n            </name>\r\n            <archetype_details>\r\n                <archetype_id>\r\n                    <value>openEHR-EHR-CLUSTER.person_anoymised_parent.v0</value>\r\n                </archetype_id>\r\n                <rm_version>1.0.1</rm_version>\r\n            </archetype_details>\r\n            <items archetype_node_id=\"at0002\" xsi:type=\"v1:ELEMENT\">\r\n                <name>\r\n                    <value>Administrative Gender</value>\r\n                </name>\r\n                <value xsi:type=\"v1:DV_CODED_TEXT\">\r\n                    <value>Male</value>\r\n                    <defining_code>\r\n                        <terminology_id>\r\n                            <value>local</value>\r\n                        </terminology_id>\r\n                        <code_string>at0003</code_string>\r\n                    </defining_code>\r\n                </value>\r\n            </items>\r\n            <items archetype_node_id=\"at0006\" xsi:type=\"v1:ELEMENT\">\r\n                <name>\r\n                    <value>Birth Sex</value>\r\n                </name>\r\n                <value xsi:type=\"v1:DV_CODED_TEXT\">\r\n                    <value>Male</value>\r\n                    <defining_code>\r\n                        <terminology_id>\r\n                            <value>local</value>\r\n                        </terminology_id>\r\n                        <code_string>at0007</code_string>\r\n                    </defining_code>\r\n                </value>\r\n            </items>\r\n            <items archetype_node_id=\"at0009\" xsi:type=\"v1:ELEMENT\">\r\n                <name>\r\n                    <value>Vital Status</value>\r\n                </name>\r\n                <value xsi:type=\"v1:DV_CODED_TEXT\">\r\n                    <value>OK</value>\r\n                    <defining_code>\r\n                        <terminology_id>\r\n                            <value>local</value>\r\n                        </terminology_id>\r\n                        <code_string>at0010</code_string>\r\n                    </defining_code>\r\n                </value>\r\n            </items>\r\n            <items archetype_node_id=\"at0012\" xsi:type=\"v1:ELEMENT\">\r\n                <name>\r\n                    <value>Birth Year</value>\r\n                </name>\r\n                <value xsi:type=\"v1:DV_DATE\">\r\n                    <value>2013-01-01</value>\r\n                </value>\r\n            </items>\r\n        </items>\r\n    </items>\r\n</items>]]>",
	    "otherDetailsTemplateId" : "person anonymised parent",
	    "systemDescription" : "DEFAULT RUNNING SYSTEM",
	    "modifiable" : true
	  },
	  "meta" : {
	    "href" : "rest/v1/ehr?ehrId=adb1f493-9cc8-42e5-aee8-55c3ea55d93c"
	  },
	  "action" : "RETRIEVE",
	  "ehrId" : "adb1f493-9cc8-42e5-aee8-55c3ea55d93c"
	}

Note: other details XML structure is passed into a CDATA