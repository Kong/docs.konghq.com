---
nav_title: Headers
---

### Upstream Headers

When a JWT is valid and a Consumer has been authenticated, the plugin appends
some headers to the request before proxying it to the Upstream service
so that you can identify the Consumer in your code:

* `X-Consumer-ID`, the ID of the Consumer on Kong.
* `X-Consumer-Custom-ID`, the `custom_id` of the Consumer (if set).
* `X-Consumer-Username`, the `username` of the Consumer (if set).
* `X-Credential-Identifier`, the identifier of the credential (if set).
* `X-Anonymous-Consumer`, set to `true` when authentication failed, and
   the `anonymous` consumer was set instead.

You can use this information on your side to implement additional logic. You can
use the `X-Consumer-ID` value to query the Kong Admin API and retrieve more information about the Consumer.

### Send a request with the JWT

The JWT can now be included in a request to Kong by adding it as a header, if configured in `config.header_names` (which contains `Authorization` by default):

```bash
curl http://localhost:8000/<route-path> \
  -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY'
```

as a query string parameter, if configured in `config.uri_param_names` (which contains `jwt` by default):

```bash
curl http://localhost:8000/<route-path>?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY
```

or as cookie, if the name is configured in `config.cookie_names` (which is not enabled by default):

```bash
curl --cookie jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY http://localhost:8000/<route-path>
```

gRPC requests can include the JWT in a header:

```bash
grpcurl -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY' ...
```

The request will be inspected by Kong, whose behavior depends on the validity of the JWT:

request                        | proxied to upstream service | response status code
--------                       |--------------------------|---------------------
has no JWT                     | no                       | 401
missing or invalid `iss` claim | no                       | 401
invalid signature              | no                       | 401
valid signature                | yes                      | from the upstream service
valid signature, invalid verified claim _optional_ | no                       | 401

{:.note}
> **Note:** When the JWT is valid and proxied to the upstream service, {{site.base_gateway}} makes no modification to the request other than adding headers identifying the consumer. The JWT will be forwarded to your upstream service, which can assume its validity. It is now the role of your service to base64 decode the JWT claims and make use of them.

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object