## Usage

In order to authenticate the consumer, it must provide a valid certificate and
complete mutual TLS handshake with Kong.

The plugin validates the certificate provided against the configured CA list based on the
requested route or service.
- If the certificate is not trusted or has expired, the response will be
  `HTTP 401 TLS certificate failed verification`.
- If consumer did not present a valid certificate (this includes requests not
  sent to the HTTPS port), then the response will be `HTTP 401 No required TLS certificate was sent`.
  The exception is if the `config.anonymous` option was configured on the plugin, in which
  case the anonymous consumer is used and the request is allowed to proceed.


### Client certificate request
Client certificates are requested in the `ssl_certificate_by_lua` phase where Kong does not
have access to `route` and `workspace` information. Due to this information gap, Kong asks for
the client certificate by default on every handshake if the `mtls-auth` plugin is configured on any route or service.
In most cases, the failure of the client to present a client certificate is not going to affect subsequent
proxying if that route or service does not have the `mtls-auth` plugin applied. The exception is where
the client is a desktop browser, which prompts the end user to choose the client cert to send and
lead to user experience issues rather than proxy behavior problems. To improve this situation,
Kong builds an in-memory map of SNIs from the configured Kong routes that should present a client
certificate. To limit client certificate requests during handshake while ensuring the client
certificate is requested when needed, the in-memory map is dependent on the routes in
Kong having the SNIs attribute set. When any routes do not have SNIs set, Kong must request
the client certificate during every TLS handshake:

- On every request irrespective of Workspace when the plugin is enabled in global Workspace scope.
- On every request irrespective of Workspace when the plugin is applied at the service level
  and one or more of the routes *do not* have SNIs set.
- On every request irrespective of Workspace when the plugin is applied at the route level
  and one or more routes *do not* have SNIs set.
- On specific requests only when the plugin is applied at the route level and all routes have SNIs set.

SNIs must be set for all routes that mutual TLS authentication uses.

### Adding certificate authorities

To use this plugin, you must add certificate authority (CA) certificates. These are
stored in a separate `ca_certificates` store rather than the main certificates store because
they do not require private keys. To add one, obtain a PEM-encoded copy of your CA certificate
and POST it to `/ca_certificates`:

{% navtabs %}
{% navtab Kong Admin API %}
```bash
curl -sX POST https://kong:8001/ca_certificates -F cert=@cert.pem
{
  "tags": null,
  "created_at": 1566597621,
  "cert": "-----BEGIN CERTIFICATE-----\FullPEMOmittedForBrevity==\n-----END CERTIFICATE-----\n",
  "id": "322dce96-d434-4e0d-9038-311b3520f0a3"
}
```
{% endnavtab %}

{% navtab Konnect %}

Go through the Runtime Manager:
1. In {{site.konnect_short_name}}, click {% konnect_icon runtimes %} **Runtime Manager**.
2. Select the runtime instance you want to add the CA certificate to.
3. Click **Certificates**.
4. Select the **CA Certificates** tab.
5. Click **+ Add CA Certificate**
6. Copy and paste your certificate information and click **Save**.

You can view your certificate listed in the **Certificates** tab.

To add a certificate via curl, you need:
* {{site.konnect_short_name}} ID
* A generated access cookie

```bash
curl -X POST https:konnect.konghq.com/api/control_planes/[Konnect-ID]/ca_certificates -F cert=@testCACert.pem --cookie '[generated access cookie]'
```
{% endnavtab %}
{% endnavtabs %}
The `id` value returned can now be used for mTLS plugin configurations or consumer mappings.

{% if_plugin_version gte:3.1.x %}
### Sending the CA DNs during TLS handshake

By default, {{site.base_gateway}} won't send the CA DN list during the TLS handshake. More specifically,
the `certificate_authorities` in the CertificateRequest message is empty.

In some cases, the client may need this `certificate_authorities` to guide
certificate selection. Setting `config.send_ca_dn` to `true` will add the
CA certificates configured in the `config.ca_certificate` to the lists of
the corresponding SNIs.

As mentioned in [Client certificate request](#client-certificate-request),
due to the phase gap, {{site.base_gateway}} doesn't know the route information in the
`ssl_certificate_by_lua` phase, which is decided in the later `access` phase.
Therefore {{site.base_gateway}} builds an in-memory map of SNIs. The CA DN list will eventually
be associated with the SNIs. If multiple `mtls-auth` plugins with different
`config.ca_certificate` are associated to the same SNI, the CA DNs will be
merged. For example:

- When the plugin is enabled in the **global** Workspace scope, the CA DNs
  are associated with a special SNI, "\*".
- When the plugin is applied at the **service** level, the CA DNs are
  associated with every SNI of every route to this service. If a route has no
  SNIs set, then the CA DNs are associated with a special SNI, "\*".
- When the plugin is applied at the **route** level, the CA DNs are
  associated with every SNI configured on this route. If the route has no SNIs set, then the CA DNs are associated with a special SNI, "\*".

During the mTLS handshake, if the client sends a SNI in the ClientHello message and
the SNI is found in the in-memory map of SNIs, then the corresponding CA DN list is sent in CertificatRequest message.

If the client doesn't send SNIs in the ClientHello message or the SNI sent is
unknown to {{site.base_gateway}}, then the CA DN list associated with "\*" is sent only when the client certificate is requested.
{% endif_plugin_version %}

### Create manual mappings between certificate and consumer object

Sometimes, you might not want to use automatic consumer lookup, or you have certificates
that contain a field value not directly associated with consumer objects. In those
situations, you may manually assign one or more subject names to the consumer object for
identifying the correct consumer.

{:.note}
> **Note**: Subject names refer to the certificate's Subject Alternative Names (SAN) or
Common Name (CN). CN is only used if the SAN extension does not exist.

{% navtabs %}
{% navtab Kong Admin API %}

Create a mapping:

```bash
curl -X POST http://kong:8001/consumers/{consumer}/mtls-auth \
    -d 'subject_name=test@example.com'
```

Where `{consumer}` is the `id` or `username` property of the
[consumer](/gateway/latest/admin-api/#consumer-object) entity to associate the
credentials to.

Once created, you'll see a `201` success message:

```json
HTTP/1.1 201 Created

{
    "consumer": { "id": "876bf719-8f18-4ce5-cc9f-5b5af6c36007" },
    "created_at": 1443371053000,
    "subject_name": "test@example.com"
}
```

{% endnavtab %}
{% navtab Declarative (YAML) %}

To create a subject name mapping using declarative configuration, you must generate a UUID for each `mtls_auth_credentials` mapping. You can use any
UUID generator to do this. Here are some common ones, depending on your OS:
* [Linux](https://man7.org/linux/man-pages/man1/uuidgen.1.html)
* [MacOS](https://www.unix.com/man-page/mojave/1/uuidgen/)
* [Windows](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid?view=powershell-7)

After you have generated a UUID, add the following to your declarative
configuration file:

```yaml
consumers:
- custom_id: my-consumer
  username: {consumer}
  mtls_auth_credentials:
  - id: bda09448-3b10-4da7-a83b-2a8ba6021f0c
    subject_name: test@example.com
```

{% endnavtab %}
{% endnavtabs %}

#### Parameters for manual mapping

Form Parameter                            | Default | Description
---                                       | ---     | ---
`id`<br>*required for declarative config* |  none   | UUID of the consumer-mapping. Required if adding mapping using declarative configuration, otherwise generated automatically by Kong's Admin API.
`subject_name`<br>*required*              |  none   | The Subject Alternative Name (SAN) or Common Name (CN) that should be mapped to `consumer` (in order of lookup).
`ca_certificate`<br>*optional*            |  none   | **If using the Kong Admin API:** UUID of the Certificate Authority (CA). <br><br> **If using declarative configuration:** Full PEM-encoded CA certificate. <br><br>The provided CA UUID or full certificate has to be verifiable by the issuing certificate authority for the mapping to succeed. This is to help distinguish multiple certificates with the same subject name that are issued under different CAs. <br><br>If empty, the subject name matches certificates issued by any CA under the corresponding `config.ca_certificates`.

### Matching behaviors

After a client certificate has been verified as valid, the consumer object is determined in the following order, unless `skip_consumer_lookup` is set to `true`:

1. Manual mappings with `subject_name` matching the certificate's SAN or CN (in that order) and `ca_certificate = <issuing authority of the client certificate>`
2. Manual mappings with `subject_name` matching the certificate's SAN or CN (in that order) and `ca_certificate = NULL`
3. If `config.consumer_by` is not null, consumer with `username` and/or `id` matching the certificate's SAN or CN (in that order)
4. The `config.anonymous` consumer (if set)

{:.note}
> **Note**: Matching stops as soon as the first successful match is found.

{% include_cached /md/plugins-hub/upstream-headers.md %}

When `skip_consumer_lookup` is set to `true`, consumer lookup is skipped and instead of appending aforementioned headers, the plugin appends the following two headers

* `X-Client-Cert-Dn`, distinguished name of the client certificate
* `X-Client-Cert-San`, SAN of the client certificate

Once `skip_consumer_lookup` is applied, any client with a valid certificate can access the Service/API.
To restrict usage to only some of the authenticated users, also add the ACL plugin (not covered here) and create
allowed or denied groups of users using the same
certificate property being set in `authenticated_group_by`.

### Troubleshooting

When authentication fails, the client does not have access to any details that explain the
failure. The security reason for this omission is to prevent malicious reconnaissance.
Instead, the details are recorded inside Kong's error logs under the `[mtls-auth]`
filter.

