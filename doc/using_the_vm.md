#Using the EtherCIS VM

##Preliminary tasks
Initially, the VM userid/password is set to 'root'/'reverse'. This can be changed later on using standard Linux CentOS admin commands.
The VM is intended to run a server and therefore there is not much graphical tools available.

EtherCIS server should be started manually (Postgres starts automatically however). The command is:

	/opt/ecis/bin/ecis-server (start|stop|clear)

You need to set your IP address (e.g. the one that is actually bridged from your host) in the launch script ecis-server with the variable:

	SERVER_HOST=192.168.100.2

When you start your server, you can check if it is listening using within your VM

	netstat -lntp

=> you should get a LISTEN state on your IP address at port 8080.

you can also check ethercis log with:

	tail -f /var/opt/ecis/ethercis_test.log

It should indicate that the server is listening... 

NB. intitially the log level is set to WARNING, a more verbose logging is provided with a lower level, for instance INFO. See /etc/opt/ecis/log4j.xml and change the last lines to read:

		...
		<root>
			<level value="INFO"/>
			<appender-ref ref="CONSOLE"/>
		</root>
	</log4j:configuration>

NB2. ethercis_test.log is intended to be used for test purpose, it is merely stdout and stderr redirection. In production, this should be disabled.

##Playing with the server
The following is brief introduction of basic REST API queries.

All transactions are performed within a session. To login, you can use guest/guest:

	POST <your-address>:8080/rest/v1/session?username=guest&password=guest

It returns the session id you have to pass for each transactions (Ehr-Session in this emulation mode). For example:

	Ehr-Session     sessionId:127.0.0.1-guest-1445236950327--1204452739-3

To disconnect:

	DELETE <your-address>:8080/rest/v1/session (assuming the session id is properly sets in the header)

The VM is somewhat "virgin" (kind of). There are no patient created, but this is done implicitly when you create a new EHR.

	POST <your address>:8080/rest/v1/ehr?subjectId=77777-1234&subjectNamespace=testIssuer

There is a problem list archetype you can use 'LCR Allergies List.v0'. You can generate an example of fields using:

	GET <your address>:8080/rest/v1/template/LCR%20Allergies%20List.v0/example?format=FLAT&exampleFilter=INPUT

You should get:

	{
	  "allergies_list/_uid": "cc2b2f6b-2992-449a-9852-7a925840c7ca::example.ethercis.com::1",
	  "allergies_list/language|code": "en",
	  "allergies_list/language|terminology": "ISO_639-1",
	  "allergies_list/territory|code": "GB",
	  "allergies_list/territory|terminology": "ISO_3166-1",
	  "allergies_list/context/_health_care_facility|id": "123456-123",
	  "allergies_list/context/_health_care_facility|id_scheme": "ETHERCIS-SCHEME",
	  "allergies_list/context/_health_care_facility|id_namespace": "DEMOGRAPHIC",
	  "allergies_list/context/_health_care_facility|name": "FACILITY",
	  "allergies_list/context/start_time": "2016-04-08T18:21:44.204+08:00",
	  "allergies_list/context/setting|code": "238",
	  "allergies_list/context/setting|value": "Other Care",
	  "allergies_list/context/setting|terminology": "openehr",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/exclusion_statement:0": "text value",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/substance_agent:0|code": "at9999",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/substance_agent:0|value": "coded text value",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/substance_agent:0|terminology": "local",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/comment": "text value",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/date_last_updated": "2010-01-01T10:00:00.000+08:00",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/language|code": "en",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/language|terminology": "ISO_639-1",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/encoding|code": "UTF-8",
	  "allergies_list/allergies_and_adverse_reactions:0/exclusion_of_an_adverse_reaction:0/encoding|terminology": "IANA_character-sets",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/causative_agent|code": "0123456789",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/causative_agent|value": "coded text value",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/causative_agent|terminology": "terminology:SNOMED-CT",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/reaction|code": "0123456789",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/reaction|value": "coded text value",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/reaction|terminology": "terminology:SNOMED-CT",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/severity|code": "at0009",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/severity|value": "Mild",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/severity|terminology": "local",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/certainty|code": "at0015",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/certainty|value": "Unlikely",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/certainty|terminology": "local",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/reaction_details/comment": "text value",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/language|code": "en",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/language|terminology": "ISO_639-1",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/encoding|code": "UTF-8",
	  "allergies_list/allergies_and_adverse_reactions:0/adverse_reaction:0/encoding|terminology": "IANA_character-sets",
	  "allergies_list/composer|id": "1234-5678",
	  "allergies_list/composer|id_scheme": "ETHERCIS-TEST",
	  "allergies_list/composer|id_namespace": "DEMOGRAPHIC",
	  "allergies_list/composer|name": "Composer",
	  "allergies_list/composer/_identifier:0": "1234-5678",
	  "allergies_list/composer/_identifier:0|issuer": "ETHERCIS",
	  "allergies_list/composer/_identifier:0|assigner": "dummy",
	  "allergies_list/composer/_identifier:0|type": "dummy"
	}

With this you can start creating/querying compositions, as described in [REST API](rest%20api.md "REST API")