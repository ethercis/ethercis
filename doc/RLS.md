# Row Level Security in PostgreSQL 

C.Chevalley 22.3.19

## Background

Postgresql row level policy (RLS) allows to slice DB table  in a set of rows satisfying one or more criterion. The principles and syntax are given at https://www.postgresql.org/docs/9.5/ddl-rowsecurity.html

To manage patient's consents in a simple manner (that is: access to the EHR is granted or not regardless of the role/user),  


Please note that RLS is enforced to all non-superuser.

# EtherCIS and Impersonation

In EtherCIS, the RLS strategy is enabled only if role based session is activated. A role base session uses the concept of session impersonation; whenever a transaction is performed, a specific role is applied to that session using DDL command `SET ROLE`. The actual impersonation is done using RoleControlledSession class from module ResourceAccessService. Please note that without the impersonation, all accesses are done using the user specified at DB connection time (f.e. 'postgres') if that user is a super user, RLS policies are **not** enforced.

Ensure that role based security is enforced at db level

	server.security.db_role=true

The impersonation can be done on a subject or principal basis
	
	# if true, principal (role) takes precedence on subject
	server.security.role_precedence=false

## JWT requirement

This precedence mechanism applies to impersonation based on JWT. With JWT, a token is passed with the query (Bearer) and contains

- a subject id
- an optional claim containing the role(s). A comma delimited role list is valid. Please note that in the context of RLS, only one role is permissible.

Whenever impersonation is activated, each transaction to the DB is prepended by a 'SET ROLE' clause which switch the permission context to that user or role for the transaction.

## Enabling RLS at DB Level

Create a default policy to allow accesses to all ehr. If this policy is not set, a default-deny policy is activated.

	CREATE POLICY user_all ON ehr.ehr FOR ALL USING (true) WITH CHECK (true);

This policy must be dropped whenever an access revocation is defined (policies are ORed).

	DROP POLICY user_all ON ehr.ehr;

The same must be done with all tables involved in the consent management mechanism.

## Create a restrictive Policy

The following policy renders ehr with id `a37f7046-a596-4784-9ec3-eea74b0ffc4f` not visible to all *normal* users. Note that a superuser may still access it.

	CREATE POLICY ehr_a37f7046_a596_47849ec3_eea74b0ffc4f 
		ON ehr.ehr
		FOR ALL
		USING(ehr.id <> 'a37f7046-a596-4784-9ec3-eea74b0ffc4f')

Nb. to drop the policy:

	DROP POLICY ehr_a37f7046_a596_47849ec3_eea74b0ffc4f ON ehr.ehr

# List active policies

	select * from pg_policies;

# Other Permission and Security Details

PostgreSQL support a broad range of permission strategies. Please see the following documents for more details:

https://www.postgresql.org/docs/10/user-manag.html
https://wiki.postgresql.org/wiki/Row-security
https://www.stigviewer.com/stig/postgresql_9.x/2017-01-20/











