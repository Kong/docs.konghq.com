---
title: Audit log reference
badge: enterprise
content_type: reference
beta: true
---

Konnect logs events in [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm).

## Authentication logs

Example log entry:

```
Jan 16 18:25:28 
konghq.com CEF:0|ExampleOrg|Konnect|1.0|AUTHENTICATION_TYPE_PAT|AUTHENTICATION_OUTCOME_SUCCESS|0|rt=3958q3097698 
src=127.0.0.1 
request=/api/v1/personal-access-tokens/introspect 
success=true 
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b 
principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b 
trace_id=3895213347334635099 
user_agent=grpc-go/1.51.0
```

Each authentication log entry contains the following:

Property | Description
---------|-------------
Timestamp | Time and date of the event in UTC.
`AUTHENTICATION_TYPE` | Can be one of the following: <br> - `AUTHENTICATION_TYPE_BASIC`: basic email and password authentication <br> - `AUTHENTICATION_TYPE_SSO`: authentication with single sign-on (SSO) <br> - `AUTHENTICATION_TYPE_PAT`: authentication with a personal access token
`AUTHENTICATION_OUTCOME` | Can be one of the following: <br> - `AUTHENTICATION_OUTCOME_SUCCESS`: authentication is successful<br> - `AUTHENTICATION_OUTCOME_NOT_FOUND`: user was not found<br> - `AUTHENTICATION_OUTCOME_INVALID_PASSWORD`: invalid password specified <br> - `AUTHENTICATION_OUTCOME_LOCKED`: user account is locked<br> - `AUTHENTICATION_OUTCOME_DISABLED`: user account has been disabled
`rt` | Milliseconds since Unix epoch.
`src` | The IP address of the request originator.
`success` | `true` or `false`, depending on whether authentication was successful or not.
`org_id` | The originating organization ID.
`principal_id` | The user ID of the user that performed the action.
`trace_id` | The trace ID of the request.
`user_agent` | The user agent of the request: application, operating system, vendor, and version.

## Authorization logs

Authorization log entries are created for every read and write operation in Konnect.

Example log entry:

```
Jan 16 00:25:40 
konghq.com CEF:0|ExampleOrg|Konnect|1.0|konnect|Authz.portals|1|rt=16738287345642 
src=127.0.0.6 
action=retrieve 
granted=true 
org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b 
principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b 
actor_id= 
trace_id=8809518331550410226 
user_agent=grpc-node/1.24.11 grpc-c/8.0.0 (linux; chttp2; ganges)
```

Each authorization log entry contains the following:

Property | Description
---------|-------------
Timestamp | Time and date of the event in UTC.
`service_name` | The name of the component within Konnect. For example, `portals` or `runtimegroups`. In the above example, this appears as `Authz.portals`.
`rt` | Milliseconds since Unix epoch.
`src` | The IP address of the request originator.
`action` | The type of action the user performed on the resource. For example, `retrieve`, `list`, or `edit`.
`granted` | Boolean indicating whether the authorization was granted or not.
`org_id` | The originating organization ID.
`principal_id` | The user ID of the user that performed the action.
`actor_id` | If using impersonation, the ID of the person doing the impersonation. Otherwise, this field is empty.
`trace_id` | The trace ID of the request.
`user_agent` | The user agent of the request: application, operating system, vendor, and version.

## See also
* [Audit logging in Konnect](/konnect/org-management/audit-logging/)
* [Set up an audit log webhook](/konnect/api/organization-settings/audit-logging/)
* [Organization Settings API](https://developer.konghq.com/spec/e46e7742-befb-49b1-9bf1-7cbe477ab818/d36126ee-ab8d-47b2-960f-5703da22cced/)