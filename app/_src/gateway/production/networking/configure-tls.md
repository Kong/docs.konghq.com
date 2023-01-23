---
title: Configure TLS
content_type: how-to
---

Configuring TLS adds a layer of security to {{site.base_gateway}} by ensuring that all data transmitted between {{site.base_gateway}} and the PostgreSQL server is encrypted. The table below contains a list of advantages and disadvantages to this approach: 

* Advantages: 
  * Authentication: TLS can authenticate traffic to {{site.base_gateway}} and the PostgreSQL server. This helps in the prevention of man-in-the-middle attacks. With TLS {{site.base_gateway}} can verify that it is communicating with the correct PostgreSQL server, and the PostgreSQl server can verify that {{site.base_gateway}} or any other client is authorized to connect.
  * Encryption: The data that is transmited between {{site.base_gateway}} and the PostgreSQL server is encrypted using symmetric key encryption, this means the same key used to encrypt the data is used to decrypt the data. This method protects your data from unauthorized access. 
  * Data integrity: With TLS your data is protected during transport.
* Disadvantages: 
  * Complexity: Configuring and maintaining secure TLS connections require the management of certificates and may add additional complexity to your {{site.base_gateway}} instance.
  * Performance: Encrypting and decrypting data consumes additional computing resources which can impact the performance of {{site.base_gateway}}. 

This guide will show you how to configure TLS on PostgreSQL and {{site.base_gateway}} to secure your data in transport. 


## Prerequisites <!-- Optional -->

* [OpenSSL](https://www.openssl.org/)
* TLS support enabled in PostgreSQL
  * If you are installing a pre-packaged distribution, or using the offical docker image, TLS support is already compiled in.
  * If you are compiling PostgreSQl from source, TLS support must be enabled at build time using the `--with-ssl=openssl ` flag. In this case OpenSSL will need to be installed as well. 

## PostgreSQL setup

To setup Postgres server with TLS enabled you have to configure the following parameters in the `postgresql.conf` file:


```bash
ssl = on #This parameter tells PostgreSQL to start with `ssl`. 
ssl_cert_file = '/path/to/server.crt' # This is the default directory, other locations and parameters can be specified. 
ssl_key_file = '/path/to/server.key' # This is the default directory, other locations and parameters can be specified. 
```

With these settings the server will establish a secure communication channel with a client using TLS, and if the client supports TLS proceed with the TLS handshake and establish a secure connection. In the case where a client does not support SSL or TLS the system will fall back on an unsecured connection. 

The key files that are referenced in the PostgreSQL configuration must have the right permissions. If the file is owned by the database user, it must be set to `u=rw (0600)`, you can set this using the following command: 

`chmod 0600 /path/to/server.crt`

If the file is owned by the root user, the permissions for the file must be `u=rw,g=r (0640)`, you can set this using the following command: 

`chmod 0640 /path/to/server.crt`. 

Certificates issued by intermediate certificate authorities can also be used, but the first certificate in `server.crt` must be the server's certificate, and it must match the server's private key. This is because the certificate must match the private key of the server, and the intermediate certificate authority to establish a chain of trust. 

### mTLS

Mutual Transport Layer Security (mTLS) is a protocol that provides an additional layer of security on top of the standard TLS protocol. mTLS requires that both the client and the server authenticate each other during the TLS handshake. If you require PostgreSQL to use mTLS authentication there are mTLS specific parameters that must be set. 

```bash
ssl_ca_file = '/path/to/ca/chain.crt'
```

This parameter must be set to the file that contains the key for the trusted certificate authority. By default this only verifies against the configured certificate authority if a certificate is present. There are two approaches to enforcing client certificates during login. 

### `cert` authentication method

The first method is called the `cert` authentication method, it uses SSL client certificates to perform authentication. For this method, edit the `hostssl` line in the  [`pg_hba.conf`](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html). 

`hostssl all all all cert`

The `cert` authentication method enforces that a certificate is valid, and also ensures that the Common Name (`cn`) in the certificates mathes the user name or an applicable mapping of the requested database. 

Username mapping can be used to allow the `cn` to be different from the username in the database. You can learn more about username mapping on the PostgreSQL official [Username mapping docs](https://www.postgresql.org/docs/current/auth-username-maps.html). 

### `clientcert` authentication method

The `clientcert` authentication method is used to verify client certificates. It is a way to combine any authentication method for `hostssl` entries with the verification of a client certificate. This allows the server to enforce that the certificate is valid and ensure that the `cn` in the certificate matches the username or the appropriate mapping. 

So by setting the `hostssl` line in the `pg_hba.conf` file to the following: 

`hostssl all all all trust clientcert=verify-full`

PostgreSQL will allow any client to connect to the server over SSL/TLS, and the server will trust the client without asking for a password or other form of authentication. The server will verify the client certificate to ensure that it is valid and that the `cn` on the certificate matches the correct mapping in the data base. 

{:.note}
>In both methods the Certificate Revocation List (CRL) is also checked when a client connects to the server. The CRL is used to revoke invalid certificates. 

## Configure TLS on {{site.base_gateway}}

The following section will cov

### {{site.base_gateway}} TLS configuration

To configure TLS on {{site.base_gateway}}, add the following settings to the `kong.conf` configuration file: 

```bash
pg_ssl = on
pg_ssl_required = on
pg_ssl_verify = on
pg_ssl_version = tlsv1_2
lua_ssl_trusted_certificate = system,/path/to/ca/chain.crt
lua_ssl_verify_depth = 1
```
For more information about the following parameters, please read the configuration {{site.base_gateway}} [PostgreSQl settings documentation](/gateway/latest/reference/configuration/#postgres-settings), as well as the specific documentation for [`lua_ssl_trusted_certificate`](/gateway/latest/reference/configuration/#lua_ssl_trusted_certificate), and [`lua_ssl_verify_depth`](/gateway/latest/configuration/#lua_ssl_verify_depth). 

### {{site.base_gateway}} mTLS configuration

If mTLS is required, {{site.base_gateway}} needs to be provide a certificate to the PostgreSQL server during the handshake process. This can be accomplished by adding these two settings to `kong.conf` 

```bash
pg_ssl_cert = '/path/to/client.crt'
pg_ssl_cert_key = '/path/to/client.key'
```


* **pg_ssl_cert**  The absolute path to the PEM encoded client TLS certificate for the PostgreSQL connection. Mutual TLS authentication against PostgreSQL is only enabled if this value is set.

* **pg_ssl_cert_key**  If `pg_ssl_cert` is set, the absolute path to the PEM encoded client TLS private key for the PostgreSQL connection.

The client certificate **must** be trusted by one of the specified certificate authorities. The ceritificate authorities are set in the `ssl_ca_file` in the PostgreSQL configuration file `postgres.conf`. 


## Creating Certificates

Certificates can be created with OpenSSL using the default settings. 

### Intermediate CA chain 

Generate root CA private key and self-sign a root CA certificate, from the terminal using these steps: 

1. Generate a root CA cert key pair:

    ```sh
    openssl req -new -x509 -utf8 -nodes -subj "/CN=root.yourdomain.com" -config /etc/ssl/openssl.cnf -extensions v3_ca -days 3650 -keyout root.key -out root.crt
    ```
2. Generate an intermediate private key and certificate
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
3. Generate server private key and certificate
    1. Generate a server private key and certificate signing request (CSR)
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
4. Generate a private key and certificate for the client
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
5. Append the certificates
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









The combined method combines any authentication method in the `hostssl` entry with cerfication of a client certificate using the `clientcert` authentication option. 

## Task section <!-- Header optional if there's only one task section in the article -->

Task sections break down the task into steps that the user completes in sequential order. The title for a how-to task section directs the user to perform an action and generally starts with a verb. Examples include "Install Kubernetes", "Configure the security settings", and "Create a microservice".

Continuing the previous example of installing software, here's an example:

1. On your computer, open the terminal.
1. Install ____ with the terminal:
    ```sh
    example code
    ```
1. Optional: To also install ____ to manage documents, install it using the terminal:
    ```sh
    example code
    ```
1. To ______, do the following:
    1. Click **Start**.
    1. Click **Stop**.
1. To ____, do one of the following:
    * If you are using Kubernetes, start the software:
        ```sh
        example code
        ```
    * If you are using Docker, start the software:
        ```sh
        example code
        ```

{:.note}
> **Note**: You can also use notes to highlight important information. Try to keep them short.

You can also use tabs in a section. For example, if you can install the software with macOS or Docker, you might have a tab with instructions for macOS and a tab with instructions for Docker.

{% navtabs %}
{% navtab macOS %}

1. Open Terminal...
1. Run....

{% endnavtab %}
{% navtab Docker %}

1. Open Docker...
1. Run....

{% endnavtab %}
{% endnavtabs %}

## Second task section <!-- Optional -->

Adding additional sections can be helpful if you have to switch from working in one product to another or if you switch from one task, like installing to configuring.

1. First step.
1. Second step.

## See also <!-- Optional -->

This section should include a list of tutorials or other pages that a user can visit to extend their learning from this tutorial.

See the following examples of how-to documentation:
* [Analytics reports](https://docs.konghq.com/gateway/latest/kong-enterprise/analytics/reports/)
* [Service directory mapping](https://docs.konghq.com/gateway/latest/kong-manager/auth/ldap/service-directory-mapping/)
* [Custom entities](https://docs.konghq.com/gateway/latest/plugin-development/custom-entities/)