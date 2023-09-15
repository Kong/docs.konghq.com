---
title: Audit log reference
badge: enterprise
content_type: reference
---

{{site.konnect_short_name}} captures three types of events:

* **Authentication**: Triggered when a user attempts to log into the {{site.konnect_short_name}} web application or use the {{site.konnect_short_name}} API via a personal access token. Also triggered when a system account access token is used.
* **Authorization**: Triggered when a permission check is made for a user or system account against a resource.
* **Access logs**: Triggered when a request is made to the {{site.konnect_short_name}} API.

## Data Retention Period
{{site.konnect_short_name}} retains audit logs for 7 days. 

## Log formats

{{site.konnect_short_name}} delivers log events in [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or JSON. You may specify which format to use in the [audit log webhook](/konnect/org-management/audit-logging/webhook/) endpoint.

Webhook calls include a batch of events. Each event is formatted in either CEF or JSON and separated by a newline. The `Content-Type` is `application/text`.

To minimize payload size, the message body is compressed. The `Content-Encoding` is `application/gzip`.

All log entries include the following attributes:

Property | Description
---------|-------------
Timestamp | Time and date of the event in UTC.
`rt` | Milliseconds since Unix epoch.
`src` | The IP address of the request originator.
`org_id` | The originating organization ID.
`principal_id` | The user ID of the user that performed the action.
`kong_initiated` | Whether the action was performed by Kong
`trace_id` | The correlation ID of the request. Use this value to find all log entries for a given request.
`user_agent` | The user agent of the request: application, operating system, vendor, and version.
`sig` | An ED25519 signature.

## Authentication logs

Authentication attempts and their outcomes are logged whenever a user logs in to the Konnect application or uses the Konnect API.

Example log entry:

{% navtabs codeblock %}
{% navtab CEF %}
```
2023-05-19T00:03:39Z
konghq.com CEF:0|ExampleOrg|Konnect|1.0|AUTHENTICATION_TYPE_PAT|AUTHENTICATION_OUTCOME_SUCCESS|0|rt=3958q3097698 
src=127.0.0.1 
request=/api/v1/personal-access-tokens/introspect 
success=true 
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b 
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
    "event_product": "Konnect",
    "event_ts": "2023-05-16T00:28:01Z",
    "event_vendor": "KongInc",
    "event_version": "1.0",
    "name": "AUTHENTICATION_OUTCOME_SUCCESS",
    "org_id": "b065b594-6afc-4658-9101-5d9cf3f36b7b",
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
`AUTHENTICATION_TYPE` | Can be one of the following: <br> - `AUTHENTICATION_TYPE_BASIC`: basic email and password authentication <br> - `AUTHENTICATION_TYPE_SSO`: authentication with single sign-on (SSO) <br> - `AUTHENTICATION_TYPE_PAT`: authentication with a personal access token
`AUTHENTICATION_OUTCOME` | Can be one of the following: <br> - `AUTHENTICATION_OUTCOME_SUCCESS`: authentication is successful<br> - `AUTHENTICATION_OUTCOME_NOT_FOUND`: user was not found<br> - `AUTHENTICATION_OUTCOME_INVALID_PASSWORD`: invalid password specified <br> - `AUTHENTICATION_OUTCOME_LOCKED`: user account is locked<br> - `AUTHENTICATION_OUTCOME_DISABLED`: user account has been disabled
`success` | `true` or `false`, depending on whether authentication was successful or not.

## Authorization logs

Authorization log entries are created for every permission check in {{site.konnect_short_name}}.

Example log entry:

{% navtabs codeblock %}
{% navtab CEF %}
```
2023-05-19T00:03:39Z
konghq.com CEF:0|ExampleOrg|Konnect|1.0|konnect|Authz.portals|1|rt=16738287345642 
src=127.0.0.6 
action=retrieve 
granted=true 
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b 
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
    "event_class_id": "konnect",
    "event_product": "Konnect",
    "event_ts": "2023-05-16T00:28:01Z",
    "event_vendor": "KongInc",
    "event_version": "1.0",
    "granted": true,
    "name": "Authz.portals",
    "org_id": "b065b594-6afc-4658-9101-5d9cf3f36b7b",
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


{:.note}
> **Note:**
> As of Sept 15, 2023, the authorization logs have been renamed. This change has no effects on the traceability of the resources by id. These renames include:
>  - From `Authz.runtimegroups` to `Authz.control-planes`
>  - From `Authz.services` to `Authz.api-products`

## Access logs

Access logs include information about create, update, and delete requests to the {{site.konnect_short_name}} API.

Example log entry:

{% navtabs codeblock %}
{% navtab CEF %}
```
2023-05-16T20:09:54Z 
konghq.com CEF:0|KongInc|Konnect|1.0|KongGateway|Ingress|1|rt=1684267794226 
src=127.0.0.6
request=/konnect-api/api/vitals/v1/explore 
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
    "event_class_id": "KongGateway",
    "event_product": "Konnect",
    "event_ts": "2023-05-16T00:28:01Z",
    "event_vendor": "KongInc",
    "event_version": "1.0",
    "name": "Ingress",
    "org_id": "b065b594-6afc-4658-9101-5d9cf3f36b7b",
    "principal_id": "87655c36-8d63-48fe-9a1e-53b28dfbc19b",
    "query": "{}",
    "request": "/konnect-api/api/runtime_groups/1c026712-c17d-4e30-ac27-53a6cdc56b9c/services",
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
* [Audit logging in {{site.konnect_short_name}}](/konnect/org-management/audit-logging/)
* [Set up an audit log webhook](/konnect/org-management/audit-logging/webhook/)
* [Set up an audit log replay job](/konnect/org-management/audit-logging/replay-job/)
* [Verify audit log signatures](/konnect/org-management/audit-logging/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/v2/)
