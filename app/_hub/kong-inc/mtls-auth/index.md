---

name: Mutual TLS Authentication
publisher: Kong Inc.
version: 1.5.x

desc: Secure routes and services with client certificate and mutual TLS authentication
description: |
  Add mutual TLS authentication based on client-supplied certificate and configured trusted CA list. Automatically maps certificates to **Consumers** based on the common name field.

enterprise: true
type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: mtls-auth
  service_id: true
  route_id: true
  config:
    - name: anonymous
      required: false
      description: |
        An optional string (consumer UUID) value to use as an "anonymous" **Consumer** if authentication fails. If the request is left empty (which it is by default), it will fail with an authentication failure of either `HTTP 495` if the client presented a certificate that is not acceptable, or `HTTP 496` if the client failed to present certificate as requested. Please note that this value must refer to the **Consumer** `id` attribute, which is internal to Kong, and **not** its `custom_id`.
    - name: consumer_by
      required: false
      default: '`[ "username", "custom_id" ]`'
      description: |
        Whether to match the subject name of the client-supplied certificate against consumer's `username` and/or `custom_id` attribute. If set to `[]` (the empty array) then auto-matching is disabled.
    - name: ca_certificates
      required: true
      value_in_examples: [ "fdac360e-7b19-4ade-a553-6dd22937c82f" ]
      description: |
        List of CA Certificates strings to use as Certificate Authorities (CA) when validating a client certificate. At least one is required but you can specify as many as needed. The value of this array is comprised of primary keys (`id`).
    - name: skip_consumer_lookup
      default: "`false`"
      description: |
        Skip consumer look once certificate is trusted against the configured CA list.
    - name: authenticated_group_by
      default: "`CN`"
      required: true
      description: |
        Certificate property to use as the authenticated group. Valid values are `CN` (Common Name) or `DN` (Distinguished Name). Once `skip_consumer_lookup` is applied, any client with a valid certificate can access the Service/API. To restrict usage to only some of the authenticated users, also add the ACL plugin (not covered here) and create allowed or denied groups of users.
    - name: revocation_check_mode
      default: "`IGNORE_CA_ERROR`"
      description: |
        >**Known Issue:** The default value `IGNORE_CA_ERROR` has a known issue in versions 1.5.0.0 and later. As a workaround, manually set the value to `SKIP`.

        Controls client certificate revocation check behavior. Valid values are `SKIP`, `IGNORE_CA_ERROR`, or `STRICT`. If set to `SKIP`, no revocation check will be performed. If set to `IGNORE_CA_ERROR`, the plugin will respect the revocation status when either OCSP or CRL URL is set, and will not fail on network issues. If set to `STRICT`, the plugin will only treat the certificate as valid when it's able to verify the revocation status, and a missing OCSP or CRL URL in the certificate or a failure to connect to the server will result in a revoked status. If both OCSP and CRL URL are set, the plugin always checks OCSP first, and will only check CRL URL if it can't communicate with the OCSP server.
    - name: http_timeout
      default: "30000"
      description: |
        HTTP timeout threshold, in milliseconds, when communicating with the OCSP server or downloading CRL.
    - name: cert_cache_ttl
      default: "60000"
      description: |
        The length of time, in milliseconds, between refreshes of the revocation check status cache.

---

### Usage

In order to authenticate the **Consumer**, it must provide a valid certificate and
complete mutual TLS handshake with Kong.

The plugin will validate the certificate provided against the configured CA list based on the requested **Route** or **Service**.
If the certificate is not trusted or has expired, the response will be `HTTP 401` "TLS certificate failed verification."
If **Consumer** did not present a valid certificate (this includes requests not sent to the HTTPS port),
then the response will be `HTTP 401` "No required TLS certificate was sent". That exception is if the `config.anonymous`
option was configured on the plugin, in which case the anonymous **Consumer** will be used
and the request will be allowed to proceed.


### Client Certificate request
Client certificates are requested in `ssl_certifica_by_lua` phase where Kong does not have access to `route` and `workspace` information. Due to this information gap, Kong will ask for the client certificate on every handshake if the mtls-auth plugin is configured on any Route or Service. In most cases, the failure of the client to present a client certificate is not going to affect subsequent proxying if that Route or Service does not have the mtls-auth plugin applied. The exception is where the client is a desktop browser which will prompt the end user to choose the client cert to send and lead to User Experience issues rather than proxy behavior problems.
To improve this situation, Kong builds an in-memory map of SNIs from the configured Kong Routes that should present a client certificate. To limit client certificate requests during handshake while ensuring the client certificate is requested when needed, the in memory map is dependent on all the Routes in Kong having the SNIs attribute set. When any routes do not have SNIs set, Kong must request the client certificate during every TLS handshake.

- On every request irrespective of Workspace when plugin enabled in global Workspace scope.
- On every request irrespective of Workspace when plugin applied at Service level
  and one or more of the Routes *do not* have SNIs set.
- On every request irrespective of Workspace when plugin applied at Route level
  and one or more Routes *do not* have SNIs set.
- On specific request only when plugin applied at route level and all Routes have SNIs set.

The result is all Routes must have SNIs if you wish to restrict the handshake request for client certificates to specific requests.


### Adding certificate authorities

In order to use this plugin, you must add certificate authority certificates. These are stored in a separate ca-certificates store rather than the main certificates store, as they do not require private keys. To add one, obtain a PEM-encoded copy of your CA certificate and POST it to `/ca_certificates`:

```bash
$ curl -sX POST https://kong:8001/ca_certificates -F cert=@cert.pem
{
  "tags": null,
  "created_at": 1566597621,
  "cert": "-----BEGIN CERTIFICATE-----\FullPEMOmittedForBrevity==\n-----END CERTIFICATE-----\n",
  "id": "322dce96-d434-4e0d-9038-311b3520f0a3"
}
```

The `id` value returned can now be used for mTLS plugin configurations or consumer mappings.

### Create manual mappings between certificate and Consumer object

Sometimes you may not wish to use automatic Consumer lookup or you have certificates
that contain a field value not associated with **Consumer** objects directly. In those
situations, you may manually assign one or more subject names to the **Consumer** object for
identifying the correct Consumer.

**Note:** "Subject names" refers to the certificate's Subject Alternative Names (SAN) or
"Common Name" (CN). CN will only be used if the SAN extension does not exist.

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/mtls-auth \
    -d 'subject_name=test@example.com'
HTTP/1.1 201 Created

{
    "consumer": { "id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007" },
    "created_at": 1443371053000,
    "subject_name": "test@example.com"
}
```

* `consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.

form parameter                          | default | description
---                                     | ---     | ---
`subject_name`<br>*required*            |         | The Subject Alternative Name (SAN) or Common Name (CN) that should be mapped to `consumer` (in that order of lookup).
`ca_certificate`<br>*optional*          |         | UUID of the Certificate Authority (CA) that the certificate has to be verifiable by for the mapping to success. This is to help distinguish multiple certificates with the same subject name but are issued under different CAs. If empty, the subject name will match certificates issued by any CA under the corresponding `config.ca_certificates`.

### Matching behaviors

Once a client certificate has been verified as valid, the **Consumer** object will be determined in the following order unless `skip_consumer_lookup` is set to `true`:

1. Manual mappings with `subject_name` matching the certificate's SAN or CN (in that order) and `ca_certificate = <issuing authority of the client certificate>`
2. Manual mappings with `subject_name` matching the certificate's SAN or CN (in that order) and `ca_certificate = NULL`
3. If `config.consumer_by` is not null, Consumer with `username` and/or `id` matching the certificate's SAN or CN (in that order)
4. The `config.anonymous` consumer (if set)

**Note**: matching will stop as soon as the first successful match is found.

When a client has been authenticated, the plugin will append headers to the request before proxying it to the upstream service so that you can identify the **Consumer** in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set)
* `X-Consumer-Username`, the `username` of the Consumer (if set)
* `X-Credential-Username`, the `username` of the Credential (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer` will be set to `true` if authentication failed and the 'anonymous' **Consumer** was set instead.

When `skip_consumer_lookup` is set to `true`, consumer lookup will be skipped and instead of appending aforementioned headers, plugin will append following two headers

* `X-Client-Cert-Dn`, distinguished name of the client certificate
* `X-Client-Cert-San`, SAN of the client certificate

Once `skip_consumer_lookup` is applied, any client with a valid certificate can access the Service/API.
To restrict usage to only some of the authenticated users, also add the ACL plugin (not covered here) and create allowed or denied groups of users using same
certificate property being set in `authenticated_group_by`.

### Troubleshooting

When authentication fails, the client does not have access to any details explaining the
failure. The security reason for this omission is to prevent malicious reconnaissance.
Instead, the details are recorded inside Kong's error logs under the `[mtls-auth]`
filter.


[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[acl-associating]: /plugins/acl/#associating-consumers
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
