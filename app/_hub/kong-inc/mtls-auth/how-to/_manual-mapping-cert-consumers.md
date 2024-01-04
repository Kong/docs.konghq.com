---
nav_title: Manual Mappings Between Certificate and Consumer Objects
title: Manual Mappings Between Certificate and Consumer Objects
---
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
curl -X POST http://localhost:8001/consumers/{consumer}/mtls-auth \
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
