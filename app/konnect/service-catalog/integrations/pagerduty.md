---
title: PagerDuty Integration
content-type: reference
---

_Type: External_

The PagerDuty integration allows you to provide a way to alert the service team (via PagerDuty services) as well as provide information on current open incidents to consumers of the service directory. 

For each linked PagerDuty service, a summary should be provided showing current unresolved incidents and the current on-call user.
An option to start an incident for the PagerDuty service

## Authenticate the PagerDuty integration
An individual with sufficient Service Hub and PagerDuty privileges will need to complete an OAuth Authorization flow to authorize the Konnect Service Hub PagerDuty App to access the user’s PagerDuty services. Both Read and Write scopes are required.

## Bindable Entities

Entity | Binding Level | Description
-------|---------------|-------------
PagerDuty Service | Service | A PagerDuty service is any entity that can have incidents opened on it. In practice it could be a service, but could also be a group of services or an organization/team.


## Discovery

Q: Is discovery supported by this integration?
A: Yes.

Q: Is discovery enabled by default?
A: Yes.

Q: What bindable entities can be discovered?
A: PagerDuty Services

Q: What mechanism is used for discovery?
A: Pull/Ingestion model



