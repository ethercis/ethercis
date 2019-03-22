# Some Technical Notes about Running EtherCIS v1.3.0

C. Chevalley 22.3.2019

## services.properties default location

Config file `services.properties` can be located into the shell user directory and will be loaded automatically
at startup without specifying its location with argument `-propertyFile`

## Naming EtherCIS process (Linux)

If multiple instances are running, it may be convenient to name the executable, instead of just seeing `java`

Executing

```markdown
exec -a ecis-1 java -Dlog4j.configurationFile=file:./log4j.xml  -jar ~christian/IdeaProjects/ethercis-distribution/ethercis-1.3.0-SNAPSHOT-runtime.jar
``` 

Will lauch a process identified by `ecis-1`

```markdown
ps -ef | grep ecis-1
```

Shows

```markdown
christi+  2146  1976 99 15:08 pts/0    00:00:07 ecis-1 -Dlog4j.configurationFile=file:./log4j.xml -jar /home/christian/IdeaProjects/ethercis-distribution/ethercis-1.3.0-SNAPSHOT-runtime.jar
```

To stop the process, use a kill or better pkill

## Clustering

In v1.3.0 using JWT, role impersonation and simple launch strategy, it is now easy to create EtherCIS cluster farm without
the need of further containment techniques (the JVM is already a container). JVM can be tuned to deal with with various
memory, cpu time, gc etc. in combination with OS parameters, depending on the deployment scenario
 (see https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html).

Further, administering a cluster farm is supported by various tools including JMC (Java Mission Control) and other
commercial offerings.

Please note that clustering should also be deployed at DB level. See PostgreSQL documentation for more on this.