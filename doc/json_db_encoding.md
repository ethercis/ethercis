# Item DB encoding
A quick note giving more details on how an ITEM_STRUCTURE is encoded into the DB as a json data

##Data Value

Generic format is

	{
		/name: "a_name"
		/value: { json structure matching the DataValue }
		/$PATH$: fully qualified path for the element
		/$CLASS$: "classname"
	}

Example

    {
      "/name": "Procedure name",
      "/value": {
        "value": "total replacement of hip",
        "definingCode": {
          "codeString": "52734007",
          "terminologyId": {
            "name": "SNOMED-CT",
            "value": "SNOMED-CT"
          }
        }
      },
      "/$PATH$": "/content[openEHR-EHR-SECTION.procedures_rcp.v1 and name/value='Procedures']/items[openEHR-EHR-ACTION.procedure.v1 and name/value='Procedure']/description[at0001]/items[at0002 and name/value='Procedure name']",
      "/$CLASS$": "DvCodedText"
    }

