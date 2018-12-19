# JWT 

## Configuration

`services.properties` parameters:

	server.security.policy.type=JWT
	server.jwt.key_file_path=${runtime.etc}/security/jwt.cf

The key file contains something similar to:

	key=secret

Alternatively, the key can be passed as a parameter (not recommended for production)

	server.jwt.key=not_so_secret

## Operation

The key can be modified at runtime, this option is only valid if the key is in a file as indicated above.

- Copy the new key into the file
- Reload the JWT configuration using JMX

	- com.ethercis.service
	
		- ServiceSecurityManager
		
			-> reload()   



