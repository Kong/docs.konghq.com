---
title: Audit log reference
badge: enterprise
content_type: reference
---

{{site.dev-portal_short_name}} captures three types of events:

* **Authentication**: Triggered when a user attempts to log into the {{site.dev-portal_short_name}} web application.
* **Authorization**: Triggered when a permission check is made for a developer against a resource.
* **Access logs**: Triggered when a request is made to the {{site.dev-portal_short_name}} API.

## Data Retention Period
{{site.dev-portal_short_name}} retains audit logs for 7 days. 

## Log formats

{{site.dev-portal_short_name}} delivers log events in [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or JSON. You may specify which format to use in the [audit log destination](/konnect/dev-portal/audit-logging/destination/) endpoint.

Webhook calls include a batch of events. Each event is formatted in either CEF or JSON and separated by a newline. The `Content-Type` is `text/plain`.

To minimize payload size, the message body is compressed. The `Content-Encoding` is `application/gzip`.

All log entries include the following attributes:

Property | Description
---------|-------------
Timestamp | Time and date of the event in UTC.
`rt` | Milliseconds since Unix epoch.
`src` | The IP address of the request originator.
`org_id` | The originating organization ID.
`portal_id` | The originating portal ID.
`principal_id` | The user ID of the user that performed the action.
`kong_initiated` | Whether the action was performed by Kong
`trace_id` | The correlation ID of the request. Use this value to find all log entries for a given request.
`user_agent` | The user agent of the request: application, operating system, vendor, and version.
`sig` | An ED25519 signature.

## Authentication logs

Authentication attempts and their outcomes are logged whenever a user logs in to the Dev Portal web application.

Example log entry:

{% navtabs codeblock %}
{% navtab CEF %}
```
2023-05-19T00:03:39Z
konghq.com CEF:0|ExamplePortal|Dev-Portal|1.0|AUTHENTICATION_OUTCOME_SUCCESS|0|rt=3958q3097698 
src=127.0.0.1 
request=/api/v1/authenticate 
success=true
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b
portal_id=6e04452b-99ce-4bef-ae4f-3e3dc035e070
principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b 
trace_id=3895213347334635099 
user_agent=grpc-go/1.51.0
sig=N_4q2pCgeg0Fg4oGJSfUWKScnTCiC79vq8PIX6Sc_rwaxdWKpVfPwkW45yK_oOFV9gHOmnJBffcB1NmTSwRRDg
```
{% endnavtab %}
{% navtab JSON %}
```json
{
    "cef_version": 0,
    "event_class_id": "AUTHENTICATION_TYPE_BASIC",
    "event_product": "Dev-Portal",
    "event_ts": "2023-05-16T00:28:01Z",
    "event_vendor": "KongInc",
    "event_version": "1.0",
    "name": "AUTHENTICATION_OUTCOME_SUCCESS",
    "org_id": "b065b594-6afc-4658-9101-5d9cf3f36b7b",
    "portal_id": "6e04452b-99ce-4bef-ae4f-3e3dc035e070",
    "principal_id": "87655c36-8d63-48fe-9a1e-53b28dfbc19b",
    "request": "/api/v1/authenticate",
    "rt": "1684524079524",
    "severity": 0,
    "sig": "N_4q2pCgeg0Fg4oGJSfUWKScnTCiC79vq8PIX6Sc_rwaxdWKpVfPwkW45yK_oOFV9gHOmnJBffcB1NmTSwRRDg",
    "src": "127.0.0.6",
    "success": "true",
    "trace_id": 6891110586028963295,
    "user_agent": "grpc-node-js/1.8.10"
}
```
{% endnavtab %}
{% endnavtabs %}

In addition to the defaults, each authentication log entry also contains the following attributes:

Property | Description
---------|-------------
`AUTHENTICATION_TYPE` | Can be one of the following: <br> - `AUTHENTICATION_TYPE_BASIC`: basic email and password authentication <br> - `AUTHENTICATION_TYPE_SSO`: authentication with single sign-on (SSO)
`AUTHENTICATION_OUTCOME` | Can be one of the following: <br> - `AUTHENTICATION_OUTCOME_SUCCESS`: authentication is successful<br> - `AUTHENTICATION_OUTCOME_NOT_FOUND`: user was not found<br> - `AUTHENTICATION_OUTCOME_INVALID_PASSWORD`: invalid password specified
`success` | `true` or `false`, depending on whether authentication was successful or not.

## Authorization logs

Authorization log entries are created for every permission check in {{site.dev-portal_short_name}}.

Example log entry:

{% navtabs codeblock %}
{% navtab CEF %}
```
2023-05-19T00:03:39Z
konghq.com CEF:0|ExamplePortal|Dev-Portal|1.0|Dev-Portal|Authz.applications|1|rt=16738287345642 
src=127.0.0.6 
action=retrieve 
granted=true 
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b
portal_id=6e04452b-99ce-4bef-ae4f-3e3dc035e070
principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b 
actor_id= 
trace_id=8809518331550410226 
user_agent=grpc-node/1.24.11 grpc-c/8.0.0 (linux; chttp2; ganges)
sig=N_4q2pCgeg0Fg4oGJSfUWKScnTCiC79vq8PIX6Sc_rwaxdWKpVfPwkW45yK_oOFV9gHOmnJBffcB1NmTSwRRDg
```
{% endnavtab %}
{% navtab JSON %}
```json
{
    "action": "list",
    "cef_version": 0,
    "event_class_id": "Dev-Portal",
    "event_product": "Dev-Portal",
    "event_ts": "2023-05-16T00:28:01Z",
    "event_vendor": "KongInc",
    "event_version": "1.0",
    "granted": true,
    "name": "Authz.applications",
    "org_id": "b065b594-6afc-4658-9101-5d9cf3f36b7b",
    "portal_id": "6e04452b-99ce-4bef-ae4f-3e3dc035e070",
    "principal_id": "87655c36-8d63-48fe-9a1e-53b28dfbc19b",
    "rt": "1684196881193",
    "severity": 1,
    "sig": "N_4q2pCgeg0Fg4oGJSfUWKScnTCiC79vq8PIX6Sc_rwaxdWKpVfPwkW45yK_oOFV9gHOmnJBffcB1NmTSwRRDg",
    "src": "127.0.0.6",
    "trace_id": 6891110586028963295,
    "user_agent": "grpc-node-js/1.8.10"
}
```
{% endnavtab %}
{% endnavtabs %}

In addition to the defaults, each authorization log entry also contains the following attributes:

Property | Description
---------|-------------
`action` | The type of action the user performed on the resource. For example, `retrieve`, `list`, or `edit`.
`granted` | Boolean indicating whether the authorization was granted or not.

## Access logs

Access logs include information about create, update, and delete requests to the {{site.dev-portal_short_name}} API.

Example log entry:

{% navtabs codeblock %}
{% navtab CEF %}
```
2023-05-16T20:09:54Z 
konghq.com CEF:0|KongInc|Dev-Portal|1.0|PortalApplication|Ingress|1|rt=1684267794226 
src=127.0.0.6
request=/portal-api/api/applications
act=POST 
status=200 
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b 
principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b 
user_agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 
trace_id=1146381705542353508 
query={"end":"1684270800","start":"1684098000"} 
sig=JxJaQG3Bozrb5WdHE_Y0HaOsim2F1Xsq_bCfk71VgsfldkLAD_SF234cnKNS
```
{% endnavtab %}
{% navtab JSON %}
```json
{
    "act": "POST",
    "cef_version": 0,
    "event_class_id": "PortalApplication",
    "event_product": "Dev-portal",
    "event_ts": "2023-05-16T00:28:01Z",
    "event_vendor": "KongInc",
    "event_version": "1.0",
    "name": "Ingress",
    "org_id": "b065b594-6afc-4658-9101-5d9cf3f36b7b",
    "principal_id": "87655c36-8d63-48fe-9a1e-53b28dfbc19b",
    "query": "{}",
    "request": "/portal-api/api/applications",
    "rt": "1684196881193",
    "severity": 1,
    "src": "127.0.0.6",
    "status": 201,
    "trace_id": 6891110586028963295,
    "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
    "sig": "N_4q2pCgeg0Fg4oGJSfUWKScnTCiC79vq8PIX6Sc_rwaxdWKpVfPwkW45yK_oOFV9gHOmnJBffcB1NmTSwRRDg",
}
```
{% endnavtab %}
{% endnavtabs %}

In addition to the defaults, each access log entry also contains the following attributes:

Property | Description
---------|-------------
`request` | The endpoint that was called.
`query` | The request query parameters, if any.
`act` | The HTTP request method; for example, `POST`, `PATCH`, `PUT`, or `DELETE`.
`status` | The HTTP response code; for example, `200` or `403`.


## See also
* [Audit logging in {{site.dev-portal_short_name}}](/konnect/dev-portal/audit-logging/)
* [Set up an audit log webhook](/konnect/dev-portal/audit-logging/webhook/)
* [Set up an audit log replay job](/konnect/dev-portal/audit-logging/replay-job/)
* [Verify audit log signatures](/konnect/dev-portal/audit-logging/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/latest/)
