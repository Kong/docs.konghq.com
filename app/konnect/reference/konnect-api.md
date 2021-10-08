---
title: Using the Konnect API
no_version: true
---

{{site.konnect_product_name}} provides a RESTful admin API for administration.

This API is designed for internal use and provides full control over a Konnect
organization and its entities, so care should be taken when setting up
[user permissions](/konnect/org-management/users-and-roles).

For a list of all endpoints, see:
* [Konnect API Swagger documentation](https://konnect.konghq.com/docs)
* [Raw Swagger JSON](https://konnect.konghq.com/docs-json)

You can run {{site.konnect_short_name}} API requests using
[Insomnia](https://insomnia.rest), Kong's open-source API client. If you have
Insomnia installed, click the button below to import the Konnect
API spec.

<!-- Button to export spec into Insomnia -->
[![Run in Insomnia](https://insomnia.rest/images/run.svg){:.no-image-expand}](https://insomnia.rest/run/?label=Konnect%20API&uri=https%3A%2F%2Fkonnect.konghq.com%2Fdocs-json)
<!-- End button -->

{:.note}
> **Note**: If you have trouble importing the spec into Insomnia,
> update to the latest Insomnia version. If you have automatic
> updates enabled but are still running an older version, restart Insomnia
> to trigger the update.

## Making a Request to the Konnect API

Requests to the Konnect API must be authenticated. A request without
authentication will fail.

Try to access `/api/control_planes` without any authentication:

{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X GET https://konnect.konghq.com/api/control_planes
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http GET https://konnect.konghq.com/api/control_planes
```
{% endnavtab %}
{% endnavtabs %}

Since you didn't specify any authentication, the request should fail with a
`401 Unauthorized` error.

### Log into the Konnect API

Fetch a session cookie. Log in to Konnect using an authorized Konnect user's
email and password:

{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X POST https://konnect.konghq.com/api/auth \
  -H "Content-Type: application/json" \
  -d '{"username":"example@email.com","password":"somepwd"}'
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http https://konnect.konghq.com/api/auth \
  username=example@email.com \
  password=somepwd \
  --session=konnect
```
{% endnavtab %}
{% endnavtabs %}

The response includes a session cookie. Copy the `<cookie-value>` portion of
the `set-cookie` header:

```sh
HTTP/2 200
content-type: application/json; charset=utf-8
content-length: 225
x-dns-prefetch-control: off
x-frame-options: SAMEORIGIN
strict-transport-security: max-age=15552000; includeSubDomains
x-download-options: noopen
x-content-type-options: nosniff
x-xss-protection: 1; mode=block
etag: W/"e1-O0G7dvUQMOZe5ESlbWvxkYqeBGT"
set-cookie: <cookie-value>; Path=/; Expires=Wed, 23 Dec 2020 18:49:4GMT; HttpOnly; SameSite=Strict
date: Wed, 23 Dec 2020 17:49:48 GMT
x-kong-upstream-latency: 159
x-kong-proxy-latency: 6
via: kong/2.2.1

{"id":"31cd0c73-g8s8-5jk7-b39b-6013salh875dd","email":"example@email.com","org_id":"fsf9agf-076b-3597-8e2d3e36ah9sfvsb","org_name":"MyOrg","first_name":"First","last_name":"Last","expiration_date":"2020-12-23T18:49:48.823Z"}%      
```

### Make a request with the session cookie

Copy the session cookie and use it to fetch `/api/control_planes` again:

{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X GET https://konnect.konghq.com/api/control_planes \
  --cookie '<cookie-value>'
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http GET https://konnect.konghq.com/api/control_planes \
  Cookie:'<cookie-value>'
```
{% endnavtab %}
{% endnavtabs %}

This time, you should get an `HTTP 200` response code and the control plane
information.
