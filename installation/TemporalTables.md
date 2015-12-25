Object Versioning With Temporal Data
====================================

Temporal Data is an emerging technique to support time reference in DB records. This addition allows to define versioning mechanisms as well as time bound resilient data. In our approach we propose to adopt the concept of Temporal Databases available in several DB engine (DB2, Oracle, Teradata, PostgreSQL). See [Temporal_database](http://en.wikipedia.org/wiki/Temporal_database) and [Bitemporal_data](http://en.wikipedia.org/wiki/Bitemporal_data) for more details on this technique.

Bitemporal Data is a way to preserve information changes during transaction such as record amendment. It is possible to trace back history of changes or to get a snapshot of data state at a given time. Further, this technique allows keeping data for a long period of time if associated to a Hierarchical Storage system.Bitemporal Database supports various point-in-time versioning of data as well as corrections on versions. It is possible to compare versions of data or to analyze occurrences of changes etc. It is similar to common version control system used in usual development environments (CVS, SVN etc.).

This approach suits well the [TIMEWINDOW AQL](https://openehr.atlassian.net/wiki/display/spec/Archetype+Query+Language+Description) clause.

Temporal DB Structure
---------------------
Following the implementation of versioning of tables requiring change control, several tables have been dropped and reference to foreign keys has been rationalized to allow (much) more efficient handling of the delete query. The table definitions now support consistently ON DELETE CASCADE. This result in very fast delete processing.

Since temporal tables add a new dimension to the db structure, the change control tables have been removed: composition VERSION and CONTRIBUTION_VERSION. The relevant attributes have been migrated to their respective "parent" table.

Note that temporal tables do not specify a version id or number. The actual version sequence can be easily retrieved from the respective history table by grouping the the entries by original ids (such as composition id) and ordered by dates. The sequencing of entries allow to perform differentials on a set of entries (f.ex. to identify the transactional steps of a contribution).

The temporal tables CRUD use case are implemented following [IBM DB2 System-period temporal tables](https://www-01.ibm.com/support/knowledgecenter/SSEPGG_10.1.0/com.ibm.db2.luw.admin.dbobj.doc/doc/c0058477.html).
  

Temporal Data with PostgreSql on Linux
----------------------------------------
Please refer to [Pgxn Temporal_tables](http://pgxn.org/dist/temporal_tables/1.0.2/) for details and installation.

Temporal Data with PostgreSql on Windows
-----------------------------

This is to keep tracks of the process to successfully compile and deploy the versioning extension for a postgresql server instance. Since there are quite a number of combinations between postgresql server version and platform target, MSVC compiler and OS. Windows is, as expected, tricky and the following should help.

I have been using the code from temporal_tables 1.0.2 and the great [blog](http://blog.2ndquadrant.com/compiling-postgresql-extensions-visual-studio-windows/) from 2nd quadrant explaining how to compile a postgresql extension with a DLL for Windows. I plan to add more details for using gmake on Linux whenever the opportunity arise...

**The platform used is:**

Postgresql 9.4 (32bits)/Windows 7 64bits/MSVC 10 Express

Please note the 32 bits version as VisualStudio *Express* does not support 64bits architecture out of the box...

**Code modifications**

The code found in versioning.c requires some changes to support a DLL environment:

Line 34:

	#ifdef _MSC_VER
	PGDLLEXPORT Datum versioning(PG_FUNCTION_ARGS);
	#else
	Datum versioning(PG_FUNCTION_ARGS);
	#endif

And line 760:

	#ifdef _MSC_VER
	        return (TimestampTz) _nextafter(ts, DBL_MAX);
	#else
	        return (TimestampTz) nextafter(ts, DBL_MAX);
	#endif

NB. I am using the macro _MSC_VER to identify a compilation done with MSVC, at this stage I am not checking the actual version of the compiler.

**Compilation and DLL generation**

I have created a project called 'temporal_tables'. This name will be used to create 'temporal_tables.dll'. It is rather important to keep this name as it used to bind the corresponding control in the postgresql operating environment.

Following the indications from 2nd quadrant blog a few changes have been required: 

- not using pre-compiled headers (`Configuration Properties->C/C++->Precompiled Headers`, set to `Not Using Precompiled Headers`)
- missing libintl.h (not included in 9.4 distribution). The file can be downloaded here and should be copied in the /include path of the postgresql installation.

**Deployment**

Once the temporal_tables.dll is compiled it should be copied into the lib directory of the postgresql installation (on my machine: C:\Program Files (x86)\PostgreSQL\9.4\lib). The following extensions controls should be copied in the share/extension directory:

    temporal_tables.control
    temporal_tables--1.0.0--1.0.1
    temporal_tables--1.0.1--1.0.2
    temporal_tables--1.0.2 
