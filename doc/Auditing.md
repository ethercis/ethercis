# Auditing

C. Chevalley 22.3.2019

Multiple logggers are active in a running instance, in particular, we do have logging at 2 levels:

1. Java process (JVM level)
2. DB level

## Java Level Auditing

The logging configuration is set in file `log4j.xml`. This is based on the Apache Logger framework which offer
a wealth of capabilities (https://logging.apache.org/log4j/2.x/)

In EtherCIS, an important logger is the Audit Log which trace and record all REST transactions. It is identified by
'ETHERCIS_AUDIT_LOG'

For example:

```
2019-03-22 15:31:12.575 [qtp1764996806-19] INFO  ETHERCIS_AUDIT_LOG - USER[SHIRO]_guest:post:rest/v1/session
2019-03-22 15:32:01.335 [qtp1764996806-14] INFO  ETHERCIS_AUDIT_LOG - userId=USER[SHIRO]_guest,method=get,path=rest/v1/ehr/status,qryparams={subjectNamespace=testIssuer;SecretSessionId=CCH-1234;x-client-ip=192.168.1.23;subjectId=99999-1234;}
```

The log also contains a lot of other information related to process internals etc.

Some level of logging can be performed with various tools including jconsole.

## DB Level Auditing

At DB level, all *contributing* transactions are logged as an entry into table `CONTRIBUTION`

A contribution may have the following state:

- `complete` the posted/updated composition/ehr is complete
- `incomplete` the posted/updated composition/ehr is not complete, a draft f.e. 
- `deleted` the composition/ehr is deleted

NB. at this stage, only complete and deleted are used.

The transition is also provided in the table as
- `creation` a POST 
- `amendment` not used
- `modification` an UPDATE
- `synthesis` not used
- `Unknown` not used
- `deleted`a DELETE

Using an SQL query it is then possible to get a complete image of the contribution with corresponding data

## Aggregation of Logging

The above logs provide the basis to answer such questions as *who did access which record, when, from where*. To generate
reports we suggest to use a log aggregator such as GrayLog (https://www.graylog.org/). This platform allows to create
GDPR compliant log analytics and reports.


