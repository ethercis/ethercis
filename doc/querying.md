#Querying

EtherCIS supports AQL and SQL querying

##SQL querying (*not recommended*)
SQL querying allows to perform direct query to the DB using any kind of extensions, functions etc. The format is:

	GET <host:port>/rest/v1/query?sql=select id from ehr.composition;

Result:

	{
	"executedSQL": "select id from ehr.composition;",
	"resultSet": [
	{
	"id": "064f266c-8f5a-453a-a17d-3acfe4fd89ab"
	},
	{
	"id": "4e607cd7-1f21-4d16-b14b-4239f48b9b04"
	},
	{
	"id": "a3f1c0d3-1895-44ef-a230-fb85b74afe85"
	},
	{...

##AQL querying

An AQL query is for instance (please not it is formatted to make it read-able)

	GET <host:port>/rest/v1/query?aql=select a/uid/value as uid,
	a/context/start_time/value as date_created, 
	a_a/data[at0001]/events[at0002]/data[at0003]/items[at0005]/value/value as test_name,
	a_a/data[at0001]/events[at0002]/data[at0003]/items[at0075]/value/value as sample_taken, 
	c/items[at0002]/items[at0001]/value/name as what, 
	c/items[at0002]/items[at0001]/value/value/magnitude as value, 
	c/items[at0002]/items[at0001]/value/value/units as units 
	from EHR e 
		contains COMPOSITION a[openEHR-EHR-COMPOSITION.report-result.v1] 
			contains OBSERVATION a_a[openEHR-EHR-OBSERVATION.laboratory_test.v0] 
				contains CLUSTER c[openEHR-EHR-CLUSTER.laboratory_test_panel.v0] 
	where a/name/value='Laboratory test report' AND e/ehr_status/subject/external_ref/id/value = '9999999000'

The result is as follows:

	{
	"executedAQL": "select a/uid/value as uid, a/context/start_time/value as date_created, a_a/data[at0001]/events[at0002]/data[at0003]/items[at0005]/value/value as test_name, a_a/data[at0001]/events[at0002]/data[at0003]/items[at0075]/value/value as sample_taken, c/items[at0002]/items[at0001]/value/name as what, c/items[at0002]/items[at0001]/value/value/magnitude as value, c/items[at0002]/items[at0001]/value/value/units as units from EHR e contains COMPOSITION a[openEHR-EHR-COMPOSITION.report-result.v1] contains OBSERVATION a_a[openEHR-EHR-OBSERVATION.laboratory_test.v0] contains CLUSTER c[openEHR-EHR-CLUSTER.laboratory_test_panel.v0] where a/name/value='Laboratory test report' AND e/ehr_status/subject/external_ref/id/value = '9999999000'",
	"resultSet": [
	{
	"uid": "55280300-9031-4390-8a90-a4e34feb51f1::testaqluk.ethercis.org::1",
	"what": "total protein measurement",
	"date_created": "2015-05-12T06:17:09+02:00",
	"sample_taken": "2015-05-11T00:13:24.518+02:00",
	"units": "g/l",
	"test_name": "hepatic function panel",
	"value": "67.0"
	},
	{
	"uid": "810272ac-28e8-4928-b61b-79dcef4b4170::testaqluk.ethercis.org::1",
	"what": "Urea",
	"date_created": "2015-03-22T06:11:02+02:00",
	"sample_taken": "2015-02-22T00:11:02.518+02:00",
	"units": "mmol/l",
	"test_name": "Urea, electrolytes and creatinine measurement",
	"value": "7.4"
	
	[.....]