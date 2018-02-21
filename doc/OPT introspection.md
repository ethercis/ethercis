# Operational Template Introspection

## Introduction

This module generates a json view of an openEHR operational template to ease/automate client operation. The json structure reflects the template construct and gives details on value point constraints such as units for quantities, valid options for coded text etc. 

The json representation aims at being faithful to the convention and terminology commonly used in the openEHR Reference Model (RM). More details are given in the very useful [UML openEHR portal](http://www.openehr.org/releases/trunk/UML/index.html).

## JSON template introspected structure

NB. as usual with JSON, the key/values expressions come in no particular order.

An introspection structure consists in the actual template tree structure with identifiers and attribute:

```
{
  "uid": "27441ebc-6d0e-4c12-a681-bbdd3c80fbe6",
  "default_language": "en",
  "languages": [
    "en"
  ],
  "concept": "RIPPLE - Conformance Test template",
  "tree": {},
  "template_id": "RIPPLE - Conformance Test template"
}
```

The ```tree``` contains the actual composition structure:

```
"tree": {
	"children": [ ... ],
	"name": "Encounter",
	"description": "Interaction, contact or care event between a subject of care and healthcare provider(s).",
	"type": "COMPOSITION",
	"node_id": "openEHR-EHR-COMPOSITION.encounter.v1"
},
``` 

```children``` contains the COMPOSITION attributes (composer, language, category etc.) as well as the item structure

```
  {
    "aql_path": "/content[openEHR-EHR-SECTION.adhoc.v1]",
    "children": [ ... ],
    "name": "Ad hoc heading",
    "description": "A generic section header which should be renamed in a template to suit a specific clinical context.",
    "type": "SECTION",
    "node_id": "openEHR-EHR-SECTION.adhoc.v1"
  },
```

Recursively traversing the item structure, actual ELEMENT value points are expressed following the same conventions. For example a DV_QUANTITY:

```
 {
    "aql_path": "/content[openEHR-EHR-SECTION.adhoc.v1]/items[openEHR-EHR-OBSERVATION.demo.v1]/data[at0001]/events[at0002]/data[at0003]/items[at0004]/items[at0012]",
    "children": [
      {
        "mandatory_attributes": [
          {
            "attribute": "magnitude",
            "type": "DOUBLE"
          },
          {
            "attribute": "units",
            "type": "STRING"
          }
        ],
        "terminology_binding": {
          "code": "122",
          "terminology": "openehr",
          "label": "Length"
        },
        "constraint": {
          "occurrence": {
            "min": 1,
            "max_op": "<=",
            "min_op": ">=",
            "max": 1
          },
          "validation": [
            {
              "magnitude": {
                "min": 0.0,
                "max_op": "<=",
                "min_op": ">=",
                "max": 100.0
              },
              "units": "cm"
            },
            {
              "units": "mm"
            },
            {
              "units": "in"
            },
            {
              "units": "ft"
            }
          ]
        },
        "type": "DV_QUANTITY"
      }
    ],
    "name": "Quantity",
    "description": "A quantity data type used to record a measurement associated with its' appropriate units.  These are derived from ISO standards and the Reference model enables conversion between these units. The example shown here is length.",
    "type": "DV_QUANTITY",
    "ethercis_sql": "\"ehr\".\"entry\".\"entry\" #\u003e\u003e \u0027{/content[openEHR-EHR-SECTION.adhoc.v1],0,/items[openEHR-EHR-OBSERVATION.demo.v1],0,/data[at0001],/events,/events[at0002],0,/data[at0003],/items[at0004],0,/items[at0012]}\u0027",
    "node_id": "at0012"
  },
```

## Value Point Expression

### Generic attributes

The following attributes are provided for all ELEMENT value points

| attribute | description                   |
|-----------|-------------------------------|
| name		| the name of the ELEMENT		|
| description | the ELEMENT description as provided at Archetype level|
| type  	| the actual value point type or ```MULTIPLE``` whenever multiple types are supported |
| aql_path | the path expression that can be used partially or as a whole in an AQL query |
| ethercis_sql | specific PostrgeSQL jsonb query expression to select the value point |
| node_id | the Locatable node id for this ELEMENT |
| children | provides specific details: mandatory value points, constraints etc.|

NB. The path expressions must be suffixed depending on the value point selected. For example if the aql_path for a DV_QUANTITY element is:

```
/content[openEHR-EHR-SECTION.adhoc.v1]/items[openEHR-EHR-OBSERVATION.demo.v1]/data[at0001]/events[at0002]/data[at0003]/items[at0004]/items[at0012]
```

To retrieve the data value 'magnitude' the expression will be suffixed accordingly
```
/content[openEHR-EHR-SECTION.adhoc.v1]/items[openEHR-EHR-OBSERVATION.demo.v1]/data[at0001]/events[at0002]/data[at0003]/items[at0004]/items[at0012]/value/magnitude
```

The supported attribute names are specified in the children section.

### Data Values attributes

The ELEMENT ```children``` section contains various attributes specific to the data value type. In particular:

- ```mandatory_attributes``` these are the data value attributes mandatory for a specific type. For example, a DV_QUANTITY expects the value points ```magnitude``` and ```units```. A DV_CODED_TEXT, ```defining_code``` and ```value``` etc.
- ```constraint``` optionnally gives the specific validation attributes for the data value and value points. For example the list of defining codes for a CODE_PHRASE. It also specifies the occurrence whenever applicable.
- ```type``` the actual type of the value type. This is useful whenever multiple types are supported by an ELEMENT (f.e. DV_TEXT **and** DV_CODED_TEXT)
- ```attribute_name``` used to identify a specific data value for an element. Some element supports 2 data values for example: name (DV_CODED_TEXT) and value (DV_QUANTITY).

### DV_QUANTITY

A DV_QUANTITY specification is as follows:

```
{
	"mandatory_attributes": [
	  {
	    "attribute": "magnitude",
	    "type": "DOUBLE"
	  },
	  {
	    "attribute": "units",
	    "type": "STRING"
	  }
	],
	"terminology_binding": {
	  "code": "382",
	  "terminology": "openehr",
	  "label": "Frequency"
	},
	"attribute_name": "value",
	"constraint": {
	  "occurrence": {
	    "min": 1,
        "max_op": "<=",
        "min_op": ">=",
	    "max": 1
	  },
	  "validation": [
	    {
	      "magnitude": {
	        "min": 0.0,
	        "max_op": "<",
	        "min_op": ">=",
	        "max": -1.0
	      },
	      "units": "/min"
	    }
	  ]
	},
	"type": "DV_QUANTITY"
}
```

The ```terminology_binding``` attribute specify the definition used for this data value
```constraint``` contains the occurrence for the data value (here mandatory), as well as the magnitude limits corresponding to a specified units. 

### DV_CODED_TEXT

The constraint/defining_code section contains the list of valid coded phrase for the data value

```
 {
    "mandatory_attributes": [
      {
        "attribute": "defining_code",
        "type": "CODE_PHRASE"
      },
      {
        "attribute": "value",
        "type": "STRING"
      }
    ],
    "constraint": {
      "defining_code": [
        {
          "code_string": "at1003",
          "terminology": "local",
          "description": "The subject was standing.",
          "value": "Standing"
        },
        {
          "code_string": "at1001",
          "terminology": "local",
          "description": "The subject was sitting (for example on bed or chair).",
          "value": "Sitting"
        },
        {
          "code_string": "at1002",
          "terminology": "local",
          "description": "The subject was reclining.",
          "value": "Reclining"
        },
        {
          "code_string": "at1000",
          "terminology": "local",
          "description": "The subject was lying flat.",
          "value": "Lying"
        }
      ],
      "occurrence": {
        "min": 1,
        "max_op": "<=",
        "min_op": ">=",
        "max": 1
      }
    },
    "attribute_name": "value",
    "type": "DV_CODED_TEXT"
  }
```

### DV_ORDINAL

As for DV_CODED_TEXT, constraint/symbol give the list of valid code and integer values for the data value:

```
 {
    "mandatory_attributes": [
      {
        "attribute": "symbol",
        "type": "DV_CODED_TEXT"
      },
      {
        "attribute": "value",
        "type": "INT"
      }
    ],
    "attribute_name": "value",
    "constraint": {
      "symbol": [
        {
          "code": "at0038",
          "terminology": "local",
          "description": "No pain",
          "value": 0
        },
        {
          "code": "at0039",
          "terminology": "local",
          "description": "Slight pain",
          "value": 1
        },
        {
          "code": "at0040",
          "terminology": "local",
          "description": "Mild pain",
          "value": 2
        },
        {
          "code": "at0041",
          "terminology": "local",
          "description": "Moderate pain",
          "value": 5
        },
        {
          "code": "at0042",
          "terminology": "local",
          "description": "Severe pain",
          "value": 9
        },
        {
          "code": "at0043",
          "terminology": "local",
          "description": "Most severe pain imaginable",
          "value": 10
        }
      ]
    },
    "type": "DV_ORDINAL"
  }
```

### Time specification: DATE, TIME, DATE_TIME, DURATION

These element may have a pattern specified in the constraint:

```
  {
    "mandatory_attributes": [
      {
        "attribute": "value",
        "type": "STRING"
      }
    ],
    "attribute_name": "value",
    "constraint": {
      "pattern": "yyyy-??-??T??:??:??",
      "occurrence": {
        "min": 1,
        "max_op": "<=",
        "min_op": ">=",
        "max": 1
      }
    },
    "type": "DV_DATE_TIME"
  }
```

### DV_PROPORTION

Constraints are specified per value points. Constraint for ```type``` (proportion kind) is always specified.

```
 {
    "mandatory_attributes": [
      {
        "attribute": "type",
        "type": "PROPORTION_KIND"
      },
      {
        "attribute": "denominator",
        "type": "DOUBLE"
      },
      {
        "attribute": "numerator",
        "type": "DOUBLE"
      }
    ],
    "attribute_name": "value",
    "constraint": {
      "occurrence": {
        "min": 1,
        "max_op": "<=",
        "min_op": ">=",
        "max": 1
      },
      "type": {
        "values": [
          {
            "label": "RATIO",
            "value": 0
          },
          {
            "label": "PERCENT",
            "value": 2
          },
          {
            "label": "FRACTION",
            "value": 3
          },
          {
            "label": "INTEGER_FRACTION",
            "value": 4
          }
        ],
        "description": "Indicates semantic type of proportion",
        "type": "INTEGER"
      }
    },
    "type": "DV_PROPORTION"
  }
```

### DV_BOOLEAN

Boolean constraint specifies whether of not true and/or false are actual *valid* values.

```
 {
    "mandatory_attributes": [
      {
        "attribute": "value",
        "type": "STRING"
      }
    ],
    "attribute_name": "value",
    "constraint": {
      "true_valid": true,
      "false_valid": false,
      "occurrence": {
        "min": 1,
        "max_op": "<=",
        "min_op": ">=",
        "max": 1
      }
    },
    "type": "DV_BOOLEAN"
  }
```

### DV_INTERVAL

Since it is a generic type specialized by the nature of the ordering components (quantity, count, date etc.). The constraint specifies the valid types, with specific constraints, for the interval:

```
{
    "mandatory_attributes": [
      {
        "attribute": "upper",
        "type": "DV_QUANTITY"
      },
      {
        "attribute": "lower",
        "type": "DV_QUANTITY"
      }
    ],
    "attribute_name": "value",
    "constraint": {
      "upper": {
        "mandatory_attributes": [
          {
            "attribute": "magnitude",
            "type": "DOUBLE"
          },
          {
            "attribute": "units",
            "type": "STRING"
          }
        ],
        "terminology_binding": {
          "code": "122",
          "terminology": "openehr",
          "label": "Length"
        },
        "attribute_name": "upper",
        "constraint": {
          "occurrence": {
            "min": 1,
            "max_op": "\u003c\u003d",
            "min_op": "\u003e\u003d",
            "max": 1
          },
          "validation": [
            {
              "units": "cm"
            },
            {
              "units": "m"
            },
            {
              "units": "in"
            },
            {
              "units": "ft"
            }
          ]
        },
        "type": "DV_QUANTITY"
      },
      "lower": {
        "mandatory_attributes": [
          {
            "attribute": "magnitude",
            "type": "DOUBLE"
          },
          {
            "attribute": "units",
            "type": "STRING"
          }
        ],
        "terminology_binding": {
          "code": "122",
          "terminology": "openehr",
          "label": "Length"
        },
        "attribute_name": "lower",
        "constraint": {
          "occurrence": {
            "min": 1,
            "max_op": "\u003c\u003d",
            "min_op": "\u003e\u003d",
            "max": 1
          },
          "validation": [
            {
              "units": "cm"
            },
            {
              "units": "m"
            },
            {
              "units": "in"
            },
            {
              "units": "ft"
            }
          ]
        },
        "type": "DV_QUANTITY"
      },
      "occurrence": {
        "min": 1,
        "max_op": "\u003c\u003d",
        "min_op": "\u003e\u003d",
        "max": 1
      }
    },
    "type": "DV_INTERVAL"
  }
```

Another example for an INTERVAL of dates:

```
 {
	"mandatory_attributes": [
	  {
	    "attribute": "upper",
	    "type": "DV_DATE_TIME"
	  },
	  {
	    "attribute": "lower",
	    "type": "DV_DATE_TIME"
	  }
	],
	"attribute_name": "value",
	"constraint": {
	  "upper": {
	    "mandatory_attributes": [
	      {
	        "attribute": "value",
	        "type": "STRING"
	      }
	    ],
	    "attribute_name": "upper",
	    "constraint": {
	      "occurrence": {
	        "min": 1,
	        "max_op": "\u003c\u003d",
	        "min_op": "\u003e\u003d",
	        "max": 1
	      }
	    },
	    "type": "DV_DATE_TIME"
	  },
	  "lower": {
	    "mandatory_attributes": [
	      {
	        "attribute": "value",
	        "type": "STRING"
	      }
	    ],
	    "attribute_name": "lower",
	    "constraint": {
	      "occurrence": {
	        "min": 1,
	        "max_op": "\u003c\u003d",
	        "min_op": "\u003e\u003d",
	        "max": 1
	      }
	    },
	    "type": "DV_DATE_TIME"
	  },
	  "occurrence": {
	    "min": 1,
	    "max_op": "\u003c\u003d",
	    "min_op": "\u003e\u003d",
	    "max": 1
	  }
	},
	"type": "DV_INTERVAL"
}
```

### Other Value Types

Since these type do not present specific constraint, the format is as follows:

```
  {
    "mandatory_attributes": [
      {
        "attribute": "media_type",
        "type": "CODE_PHRASE"
      }
    ],
    "attribute_name": "value",
    "constraint": {
      "occurrence": {
        "min": 1,
        "max_op": "\u003c\u003d",
        "min_op": "\u003e\u003d",
        "max": 1
      }
    },
    "type": "DV_MULTIMEDIA"
  }
```

```
  {
    "mandatory_attributes": [
      {
        "attribute": "value",
        "type": "STRING"
      }
    ],
    "attribute_name": "name",
    "constraint": {
      "occurrence": {
        "min": 1,
        "max_op": "\u003c\u003d",
        "min_op": "\u003e\u003d",
        "max": 1
      }
    },
    "type": "DV_TEXT"
  }
```

### COMPOSITION attributes

These attributes follow the same convention as described above.

Generally, only the aql_path is specified since the sql query is trivial (SQL only).

# How to use it?

## Querying for an introspection

The REST API syntax is similar to querying for a template example, just substitute 'example' by 'introspect', for example:

```
<URL>/rest/v1/template/IDCR%20-%20Adverse%20Reaction%20List.v1/introspect
```

The result is a whole json body representing the instrospection. In case of error, 400 is returned.






















