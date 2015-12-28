#FLAT JSON

The flat json format currently supported by Ethercis is a simple Path/Value representation of data in a Composition.

For example, a flat json data block is

	{
	        "/context/health_care_facility|name":"Northumbria Community NHS",
	        "/context/health_care_facility|identifier":"999999-345",
	        "/context/start_time":"2015-09-28T10:18:17.352+07:00",
	        "/context/end_time":"2015-09-28T11:18:17.352+07:00",
	        "/context/participation|function":"Oncologist",
	        "/context/participation|name":"Dr. Marcus Johnson",
	        "/context/participation|identifier":"1345678",
	        "/context/participation|mode":"face-to-face communication::openehr::216",
	        "/context/location":"local",
	        "/context/setting":"openehr::227|emergency care|",
	        "/composer|identifier":"1345678",
	        "/composer|name":"Dr. Marcus Johnson",
	        "/category":"openehr::433|event|",
	        "/territory":"FR",
	        "/language":"fr",
	        "/content[openEHR-EHR-SECTION.medications.v1]/items[openEHR-EHR-INSTRUCTION.medication.v1]/participation:0":"Nurse|1345678::Jessica|face-to-face communication::openehr::216",
	        "/content[openEHR-EHR-SECTION.medications.v1]/items[openEHR-EHR-INSTRUCTION.medication.v1]/participation:1":"Assistant|1345678::2.16.840.1.113883.2.1.4.3::NHS-UK::ANY::D. Mabuse|face-to-face communication::openehr::216",
	        "/content[openEHR-EHR-SECTION.medications.v1]/items[openEHR-EHR-INSTRUCTION.medication.v1]/activities[at0001]/timing":"before sleep",
	        "/content[openEHR-EHR-SECTION.medications.v1]/items[openEHR-EHR-INSTRUCTION.medication.v1]/activities[at0001]/description[openEHR-EHR-ITEM_TREE.medication_mod.v1]/items[at0001]":"aspirin",
	        "/content[openEHR-EHR-SECTION.medications.v1]/items[openEHR-EHR-INSTRUCTION.medication.v1]/activities[at0002]/timing":"lunch",
	        "/content[openEHR-EHR-SECTION.medications.v1]/items[openEHR-EHR-INSTRUCTION.medication.v1]/activities[at0002]/description[openEHR-EHR-ITEM_TREE.medication_mod.v1]/items[at0001]":"Atorvastatin"
	}



Paths
-

The path expression is directly issued from the [template designer](http://www.openehr.org/downloads/modellingtools) or a CKM like [openEHR UK CKM](http://www.clinicalmodels.org.uk/ckm/). For the latter select 'Show Path' option when displaying a template.

OpenEHR locatable path are described at: [Paths and Locators](http://www.openehr.org/releases/1.0.2/html/architecture/overview/Output/paths_and_locators.html)

NB. In a flat json block, path expressions consist of several sections:

- **/context** Hold the composition context attributes
- **a number of composition attributes** to specify: category, language etc
- **/content** the set of entries (care entries, section, admin entry etc.) 

Values
-
The syntaxt for encoding of OpenEHR data values follow several conventions depending on the type, see: [Data Types Specification](http://www.openehr.org/releases/1.0.2/architecture/rm/data_types_im.pdf) for more details


**DvCodedText**

	"terminology::code|value|"

**DvText**

	"text"

**CodePhrase**

	"terminology::code"

**DvDateTime**

	YYYY-MM-DDTHH:MM:SS

**DvTime**

	HH:MM:SS

**DvDate**

	YYYY-MM-DD

**DvBoolean**

	"true|false"

**DvInterval**

	Date interval: YYYY-MM-DD::YYYY-MM-DD
	[TBC]

**DvEHRURI**

	"a URL"

**DvOrdinal**

	Ordinal#|corresponding coded text	

	Example: `1|SNOMED-CT::313267000|Stroke|

**DvQuantity**

	magnitude,unit

	Example: "12,kg" "78.500,kg" (NB. the precision is implictly given by the number of digits in the decimal part)

**DvDuration**

	"ISO 8601 duration"

	Example: PT2h5m0s

**DvCount**

	integer_value

**DvProportion**

	numerator,denominator,proportion_kind

	Example: "25.3,100,2" "21,24,3" (respectively: PERCENT, FRACTION)

Proportion Kind:

    RATIO(0),
    UNITARY(1),
    PERCENT(2),
    FRACTION(3),
    INTEGER_FRACTION(4)

**DvMultimedia**
- not supported yet

**Participation**

A participation consists of several complex attributes and is represented sequentially:

        ...|function": "Oncologist"
        ...|identifier": "999999-8"
        ...|mode": "openehr::216|evil cabinet|"
        ...|name": "Dr. Caligari"

Another terse representation on one line:

	Nurse|1345678::Jessica|face-to-face communication::openehr::216

	function|id:name|mode::terminology::code

**Indexes**

Arrays are supported by specifying an index value prefixed by ":", for example:

	/content[openEHR-EHR-EVALUATION.verbal_examination.v1]/participation:0
	/content[openEHR-EHR-EVALUATION.verbal_examination.v1]/participation:1
	/content[openEHR-EHR-EVALUATION.verbal_examination.v1]/participation:2

Or by incrementing the at00xy expression:

	/items[openEHR-EHR-EVALUATION.reason_for_encounter.v1]/data[at0001]/items[at0002]:"does not sleep"
	/items[openEHR-EHR-EVALUATION.reason_for_encounter.v1]/data[at0001]/items[at0003]:"thinks too much"
	/items[openEHR-EHR-EVALUATION.reason_for_encounter.v1]/data[at0001]/items[at0004]:"thinks way too much"

**Choice**
The choice is specified by indicating the index of the alternative prefixed by '@', for example:

	"@1|Choice #1"

	- OR -
	
	"@2|local::111|Continue Indefinitely|"	
