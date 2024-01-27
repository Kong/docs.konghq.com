---
title: Troubleshoot PostgreSQL TLS
content_type: reference
---

## PostgreSQL

### Could not accept SSL connection

If you receive either of the following error messages, you are experiencing an issue with mismatched SSL versions.

```sh
LOG:  could not accept SSL connection: wrong version number
HINT:  This may indicate that the client does not support any SSL protocol version between TLSv1.1 and TLSv1.1.
```

```sh
LOG:  could not accept SSL connection: unsupported protocol
HINT:  This may indicate that the client does not support any SSL protocol version between TLSv1.2 and TLSv1.3.
```

In this case, the client is trying to connect to the server using a version of the TLS protocol that is not supported by the server. Check which version PostgreSQL supports and adjust the client-side TLS version. 

You can check the TLS version by running the `pg_config --configure` command. 

Kong recommends TLSv1.2 or higher. Lower versions are deprecated and are not considered secure.

### Could not load server certificate file

If you are receiving this error message: 

```sh
FATAL:  could not load server certificate file "server.crt": No such file or directory
```
The server is unable to find the certificate file. By default, the certificate file should be named `server.crt`, and it should be placed in the server's data directory. Other names are allowed, but they should be explicitly specified in the `ssl_cert_file`. 


### Could not access private key file

If you are receiving this error message: 

```
FATAL:  could not access private key file "server.key": No such file or directory
```
The server is unable to find the private key file. By default, the private key file should be named `server.key`, and it should be placed in the server's data directory. If you used another naming convention it should be explicitly set using the `ssl_key_file` parameter in the `postgresql.conf` file. 


### Incorrect private key permissions

```sh
FATAL:  private key file "/certs/example.com.key" has group or world access
DETAIL:  File must have permissions u=rw (0600) or less if owned by the database user, or permissions u=rw,g=r (0640) or less if owned by root.
```

If you receive this error, the permissions for the private key are incorrect. Use the information in the error message to apply the correct permissions to your private key. 

### Failed to verify the SSL certificate

```sh
LOG:  could not accept SSL connection: tlsv1 alert unknown ca
```
The client has failed to verify the PostgreSQL server certificate. To resolve this issue, make sure that the certificate matches the one applied to {{site.base_gateway}}. 


### Certificate verify failed

```sh
LOG:  could not accept SSL connection: certificate verify failed
```
The PostgreSQL server failed to verify the client certificate. You can fix this by verifying that the server provided in the `ssl_ca_file` parameter in `postgres.conf` is trusted by the CA. 

### Certificate authentication failed for `user`

```sh 
LOG:  provided user name (kong) and authenticated user name (foo@example.com) do not match
FATAL:  certificate authentication failed for user "kong"
```

This error message happens when the client certificate doesn't match the username specified in the database. 

### Connection requires a valid client certificate

```sh
FATAL:  connection requires a valid client certificate
```

This error occurs when the PostgreSQL server requires a client certificate for authentication, but the client, in this case {{site.base_gateway}}, was unable to provide a valid certificate. For this type of error, check if `pg_ssl_cert` and `pg_ssl_cert_key` are correctly set in `kong.conf`. 



## Troubleshooting TLS on {{site.base_gateway}}

### Protocol versions are not a match 

If you receive either of the following error messages: 

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: tlsv1 alert protocol version
```

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: unsupported protocol
```
The server and client versions are not in sync. Check the version that the PostgreSQL server is using and adjust the {{site.base_gateway}} version accordingly. 




### The server does not support SSL connections

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: the server does not support SSL connections
```

This error occurs when SSL is not supported by PostgreSQL. Configure PostgreSQL according to [the configuration instructions](/gateway/{{page.release}}/production/networking/configure-postgres-tls/).



### Certificate verify failed 

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: certificate verify failed
```
This error occurs when {{site.base_gateway}} fails to verify the PostgreSQL server certificate. Ensure that the PostgreSQL server has configured a trusted certificate and the corresponding CA chain is correctly set in `lua_ssl_trusted_certificate` within `kong.conf`. 


### Connection requires a valid client certificate

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: FATAL: connection requires a valid client certificate
```
{{site.base_gateway}} requires a client certificate for authentication, but the client was unable to provide a valid certificate. 

This error occurs when the PostgreSQL server requires a client certificate for authentication, but the {{site.base_gateway}} is unable to provide a valid certificate. For this type of error, check if `pg_ssl_cert` and `pg_ssl_cert_key` are correctly set in `kong.conf`. 


### tlsv1 alert unknown ca

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: tlsv1 alert unknown ca
```
The PostgreSQL server failed to verify the client certificate. Use a client certificate which is trusted by the CA set in `ssl_ca_file` within `postgres.conf`. 

### Certificate authentication failed for user

```sh
Error: [PostgreSQL error] failed to retrieve PostgreSQL server_version_num: FATAL: certificate authentication failed for user "kong"
```

The common name of the client certificate doesn't match the username set in the database. Add a username mapping in `pg_ident.conf` as described in the [PostgreSQL configuration instructions](/gateway/latest/production/networking/configure-postgres-tls/).
