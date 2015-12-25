REST Dialect Support
====================

Since this platform will likely have to support multiple HTTP query syntax, there are a number of provisions to allow some flexibility when dealing with a new HTTP query syntax context.

Generally a query syntax is specified with a set of annotations and variable parameters. Since conditional compilation is not available in Java, the selection of a given dialect context is defined by a global variable to all services: dialectSpace

Dialect Space
-

This is defined in interface I_ServiceRunMode. It is initialized by a lauch parameter: -dialect as a command line argument:


	launcher.start(new String[]{
	        "-propertyFile", "test/resources/config/services.properties",
	        "-java_util_logging_config_file", "test/resources/config/logging.properties",
	        "-servicesFile", "test/resources/config/services.xml",
	        "-dialect", "EHRSCAPE",
	        "-server_port", "8080",
	        "-server_host", "localhost",
	        "-debug", "true"
	});


Likewise, a JVM property can be set with the same effect:

	server.mode.dialect


Currently, two dialects are supported:

    STANDARD
    EHRSCAPE 

Queries
-
The implementation supports query parameter substitution and query syntax specification depending on the run-time dialect.


**Parameter Substitution**

This is done at Class level, the parameter names are defined by dialect dependent annotations:

	@ParameterSetting( identification = {
	        @ParameterIdentification(id = "user", definition = {
	                @ParameterDefinition(mode = I_ServiceRunMode.DialectSpace.STANDARD, name = "user", type = String.class),
	                @ParameterDefinition(mode = I_ServiceRunMode.DialectSpace.EHRSCAPE, name = "username", type = String.class)
	        }),
	        @ParameterIdentification(id = "password", definition = {
	                @ParameterDefinition(mode = I_ServiceRunMode.DialectSpace.STANDARD, name = "password", type = String.class),
	                @ParameterDefinition(mode = I_ServiceRunMode.DialectSpace.EHRSCAPE, name = "password", type = String.class)
	        })
	})


The above example illustrates the redefinitions of parameters user and password depending on the dialect. For example, when emulating EhrScape, user is passed as `username` in the query.


**Query Specification**

A query is specified by mean of annotation (QuerySetting) in a method header. QuerySetting supports multiple dialects definition. At run-time, the corresponding syntax is picked up.

Example:

	@QuerySetting(dialect = {
	        @QuerySyntax(mode = DialectSpace.STANDARD, httpMethod = "GET", method = "connect", path = "vehr", responseType = ResponseType.Void),
	        @QuerySyntax(mode = DialectSpace.EHRSCAPE, httpMethod = "POST", method = "session", path = "rest/v1", responseType = ResponseType.String)
	        })

 
The above illustrate the connect to server syntax in two dialects assuming the parameter substitution explained above:

- STANDARD: `GET vehr/connect?user="joe"&password="doe"`
- EHRSCAPE: `POST rest/v1/session?username="joe"&password="doe"`

**Implicit Method**

In some EhrScape queries, no method is specified. For compatibility purpose it is substituted by MethodName.UNKNOWN ("unknown"). This allows to support authorization checking.

Example:

`GET /rest/v1/ehr/?subjectId=63436&subjectNamespace=ehrscape`

Is interpreted as:

    Path: /rest/v1/ehr

    Method: unknown

    Arguments: subjectId and subjectNamespace 
      

See URIParser::identifyMethod() for more on this