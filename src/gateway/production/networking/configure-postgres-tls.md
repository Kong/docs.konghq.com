---
title: Configuring PostgreSQL TLS
content_type: tutorial
---

Configuring TLS adds a layer of security to {{site.base_gateway}} by ensuring that all data transmitted between {{site.base_gateway}} and the PostgreSQL server is encrypted. There are some advantages and disadvantages to this approach: 

* **Advantages**: 
  * Authentication: TLS can authenticate traffic between {{site.base_gateway}} and the PostgreSQL server. This helps prevent man-in-the-middle attacks. With TLS, {{site.base_gateway}} can verify that it is communicating with the correct PostgreSQL server, and the PostgreSQL server can verify that {{site.base_gateway}} or any other client is authorized to connect.
  * Encryption: The data that is transmitted between {{site.base_gateway}} and the PostgreSQL server is encrypted. This method protects your data from unauthorized access. 
  * Data integrity: With TLS, your data is protected during transport.
* **Disadvantages**: 
  * Complexity: Configuring and maintaining secure TLS connections requires managing certificates and may add additional complexity to your {{site.base_gateway}} instance.
  * Performance: Encrypting and decrypting data consumes additional computing resources which can impact the performance of {{site.base_gateway}}. 

This guide shows you how to configure TLS on PostgreSQL and {{site.base_gateway}} to secure your data in transport. 


## Prerequisites

* [OpenSSL](https://www.openssl.org/)
* TLS support enabled in PostgreSQL.
  * If you are installing a pre-packaged distribution, or using the official Docker image, TLS support is already included.
  * If you are compiling PostgreSQL from source, TLS support must be enabled at build time using the `--with-ssl=openssl ` flag. In this case, the OpenSSL development package needs to be installed as well. 

## PostgreSQL setup

To set up the PostgreSQL server with TLS enabled, configure the following parameters in the `postgresql.conf` file:


```bash
ssl = on #This parameter tells PostgreSQL to start with `ssl`. 
ssl_cert_file = '/path/to/server.crt' # If this parameter isn't specified, the cert file must be named `server.crt` in the server's data directory. 
ssl_key_file = '/path/to/server.key' # This is the default directory, other locations and parameters can be specified. 
```

With these settings, the server can establish a secure communication channel with a client using TLS. If the client supports TLS, the server proceeds with the TLS handshake and establishes a secure connection. In the case where a client does not support SSL or TLS, the system will fall back on an unsecured connection. 

The key files that are referenced in the PostgreSQL configuration must have the right permissions. If the file is owned by the database user, it must be set to `u=rw (0600)`. Set this using the following command: 

`chmod 0600 /path/to/server.key`

If the file is owned by the root user, the permissions for the file must be `u=rw,g=r (0640)`. Set this using the following command: 

`chmod 0640 /path/to/server.key`. 

Certificates issued by intermediate certificate authorities can also be used, but the first certificate in `server.crt` must be the server's certificate, and it must match the server's private key.

### mTLS

Mutual Transport Layer Security (mTLS) is a protocol that provides an additional layer of security on top of the standard TLS protocol. mTLS requires that both the client and the server authenticate each other during the TLS handshake. If you require PostgreSQL to use mTLS authentication, there are mTLS specific parameters that must be set. 

```bash
ssl_ca_file = '/path/to/ca/chain.crt'
```

This parameter must be set to the file that contains the trusted certificate authority. By default, this only verifies against the configured certificate authority if a certificate is present. There are two approaches to enforcing client certificates during login: `cert` authentication and `clientcert` authentication.

#### `cert` authentication method

The `cert` authentication method uses SSL client certificates to perform authentication. For this method, edit the `hostssl` line in the  [`pg_hba.conf`](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html):

`hostssl all all all cert`

The `cert` authentication method enforces that a certificate is valid, and also ensures that the Common Name (`cn`) in the certificates matches the username or an applicable mapping of the requested database. 

Username mapping can be used to allow the `cn` to be different from the username in the database. You can learn more about username mapping in the PostgreSQL official [Username mapping docs](https://www.postgresql.org/docs/current/auth-username-maps.html). 

#### `clientcert` authentication option

The `clientcert` authentication option can combine any authentication method for `hostssl` entries with the verification of a client certificate. This allows the server to enforce that the certificate is valid and ensure that the `cn` in the certificate matches the username or the appropriate mapping. 

To use `clientcert` authentication, set the `hostssl` line in the `pg_hba.conf` file to the following: 

`hostssl all all all trust clientcert=verify-full`

With this setting, PostgreSQL allows any client to connect to the server over SSL/TLS, and the server can trust the client without asking for a password or other form of authentication. The server verifies the client certificate to ensure that the certificate is valid and the `cn` on the certificate matches the correct mapping in the database. 

{:.note}
>In both methods, the Certificate Revocation List (CRL) is also checked when a client connects to the server if the parameter `ssl_crl_file` is set. The CRL is used to revoke invalid certificates. 


## {{site.base_gateway}} TLS configuration

To configure TLS on {{site.base_gateway}}, add the following settings to the `kong.conf` configuration file: 

```bash
pg_ssl = on
pg_ssl_required = on
pg_ssl_verify = on
pg_ssl_version = tlsv1_2
lua_ssl_trusted_certificate = system,/path/to/ca/chain.crt
lua_ssl_verify_depth = 1
```
For more information about these parameters, see the {{site.base_gateway}} [PostgreSQL settings documentation](/gateway/{{page.release}}/reference/configuration/#postgres-settings), as well as the specific documentation for [`lua_ssl_trusted_certificate`](/gateway/{{page.release}}/reference/configuration/#lua_ssl_trusted_certificate) and [`lua_ssl_verify_depth`](/gateway/{{page.release}}/reference/configuration/#lua_ssl_verify_depth). 

### {{site.base_gateway}} mTLS configuration

If mTLS is required, {{site.base_gateway}} needs to be provide a certificate to the PostgreSQL server during the handshake process. This can be accomplished by adding the following settings to `kong.conf`: 

```bash
pg_ssl_cert = '/path/to/client.crt'
pg_ssl_cert_key = '/path/to/client.key'
```


* **`pg_ssl_cert`**  The absolute path to the PEM-encoded client TLS certificate for the PostgreSQL connection. Mutual TLS authentication against PostgreSQL is only enabled if this value is set.

* **`pg_ssl_cert_key`**  If `pg_ssl_cert` is set, the absolute path to the PEM-encoded client TLS private key for the PostgreSQL connection.

The client certificate **must** be trusted by one of the specified certificate authorities. The certificate authorities are set in the `ssl_ca_file` parameter in the PostgreSQL configuration file `postgres.conf`. 


## Creating certificates

Certificates can be created with OpenSSL using the default settings. 

### Intermediate CA chain 

An intermediate CA chain means the server or the client certificates are issued by an intermediate CA, not issued directly by the root CA. 

From the terminal, generate a root CA private key and self-sign a root CA certificate using these steps: 

1. Generate a root CA cert-key pair:

    ```sh
    openssl req -new -x509 -utf8 -nodes -subj "/CN=root.yourdomain.com" -config /etc/ssl/openssl.cnf -extensions v3_ca -days 3650 -keyout root.key -out root.crt
    ```
2. Generate an intermediate private key and certificate:
    1. Generate the CA private key and certificate signing request (CSR):
        ```sh
        openssl req -new -utf8 -nodes -subj "/CN=intermediate.yourdomain.com" -config /etc/ssl/openssl.cnf -keyout intermediate.key -out intermediate.csr
        ```
    1. Change the private key permissions:
        ```sh
        chmod og-rwx intermediate.key
        ```
    1. Create an intermediate CA certificate signed by the root CA: 
        ```sh
        openssl x509 -req -extfile /etc/ssl/openssl.cnf -extensions v3_ca -in intermediate.csr -days 1825 -CA root.crt -CAkey root.key -CAcreateserial -out intermediate.crt
        ```
3. Generate the server private key and certificate:
    1. Generate a server private key and certificate signing request (CSR):
        ```sh
        openssl req -new -utf8 -nodes -subj "/CN=dbhost.yourdomain.com" -config /etc/ssl/openssl.cnf -keyout server.key -out server.csr
        ```
    1. Change the permissions of the private key:
        ```sh
        chmod og-rwx server.key
        ```
    1. Create a server certificate signed by the intermediate CA:
        ```sh
        openssl x509 -req -in server.csr -days 365 -CA intermediate.crt -CAkey intermediate.key -CAcreateserial -out server.crt
        ```
4. Generate a private key and certificate for the client:
    1. Generate a client private key and certificate signing request (CSR):
        ```sh
       openssl req -new -utf8 -nodes -subj "/CN=kong" -config /etc/ssl/openssl.cnf -keyout client.key -out client.csr
       ```
    1.  Change the permissions of the private key:
        ```sh
        chmod og-rwx client.key
        ```
    1. Create a client certificate signed by an intermediate CA: 
        ```sh
        openssl x509 -req -in client.csr -days 365 -CA intermediate.crt -CAkey intermediate.key -CAcreateserial -out client.crt
        ```
5. Append the certificates:
    1. Complete the CA chain:
        ```sh
        cat intermediate.crt > chain.crt
        cat root.crt >> chain.crt
        ```
    2. **Optional**: append `intermediate.crt` to `server.crt`:
        ```sh
        cat intermediate.crt >> server.crt
        ```
        This step is typically done when the server is configured to use a certificate chain that includes the intermediate CA. If the server is not configured to use a certificate chain, or if the intermediate CA is already included in the `server.crt` file, this step is not necessary. 
    3. **Optional**: append `intermediate.crt` to `client.crt`:
        ```sh
        cat intermediate.crt >> client.crt
        ```
        This step is typically done when the client is configured to use a certificate chain that includes the intermediate CA. If the client is not configured to use a certificate chain, or if the intermediate CA is already included in the `client.crt` file, this step is not necessary. 

### Chain without intermediate CA

In some cases, the certificate chain can be signed directly by the root certificate authority instead of an intermediate CA. This type of chain may be used in situations where the certificate is issued by a well-known and trusted root CA, and the level of security and trust provided by an intermediate CA is not necessary. 

{:.important}
> **Important:** Not using an intermediate CA can be less secure than using an intermediate CA, because the chain is shorter, and there are no additional layers of security that would normally be provided by the intermediate CA. 

1. Generate a root CA cert key pair:

    ```sh
    openssl req -new -x509 -utf8 -nodes -subj "/CN=root.yourdomain.com" -config /etc/ssl/openssl.cnf -extensions v3_ca -days 3650 -keyout root.key -out root.crt
    ```
2. Generate server private key and certificate:
    1. Generate a server private key and certificate signing request (CSR):
        ```sh
        openssl req -new -utf8 -nodes -subj "/CN=dbhost.yourdomain.com" -config /etc/ssl/openssl.cnf -keyout server.key -out server.csr
        ```
    1. Change the permissions of the private key:
        ```sh
        chmod og-rwx server.key
        ```
    1. Create a server certificate signed by the intermediate CA:
        ```sh
        openssl x509 -req -in server.csr -days 365 -CA root.crt -CAkey root.key -CAcreateserial -out server.crt
        ```
3. Generate a private key and certificate for the client:
    1. Generate a client private key and certificate signing request (CSR):
        ```sh
       openssl req -new -utf8 -nodes -subj "/CN=kong" -config /etc/ssl/openssl.cnf -keyout client.key -out client.csr
       ```
    1.  Change the permissions of the private key:
        ```sh
        chmod og-rwx client.key
        ```
    1. Create a client certificate signed by an intermediate CA: 
        ```sh
        openssl x509 -req -in client.csr -days 365 -CA root.crt -CAkey root.key -CAcreateserial -out client.crt
        ```
### Self-signed certificates for testing

Self-signed certificates should **only** be used for testing.
1. Generate server key and self-signed cert:

    ```sh
   openssl req -new -x509 -utf8 -nodes -subj "/CN=dbhost.yourdomain.com" -config /etc/ssl/openssl.cnf -days 365 -keyout server.key -out server.crt
   ```
2. Change private key permissions: 
    ```sh
    chmod og-rwx server.key
    ```
3. Generate the client key and self-signed certificate:
    ```sh
    openssl req -new -x509 -utf8 -nodes -subj "/CN=kong" -config /etc/ssl/openssl.cnf -days 365 -keyout client.key -out client.crt
    ```
4. Change the permissions of the private key: 
    ```sh
    chmod og-rwx client.key
    ```

When you use a self-signed certificate, the `client.crt` should be specified in the `ssl_ca_file` parameter, and the `server.crt` should be specified in the `lua_ssl_trusted_certificate` parameter.
