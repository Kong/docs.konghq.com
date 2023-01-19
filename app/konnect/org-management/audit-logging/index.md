---
title: Audit Logging in Konnect
badge: enterprise
content_type: explanation
beta: true
---

Audit logging enables administrators to better spot security risks and maintain compliance of their core infrastructure. 

No system is completely secure. Audit logs provide a mechanism to catch abnormal events when those events occur. 
If potential security incidents are not caught early, perpetrators can cause issues or even downtime with a company’s infrastructure, 
leading to serious consequences such as outages and lost revenue.

By tracking Konnect audit logs, you gain the following benefits:
* **Security**: System events can be used to show abnormalities to be investigated, forensic information related to breaches, or provide evidence.
* **Compliance**: Some regulations require audit logs, or audit logs are needed to show auditors who confirm whether certain certification standards are met.
* **Debugging**: Audit logs give insights into why there is a current level of efficiency or performance. 
* **Risk management**: Prevent issues or catch them early.

## Setting up audit logging in Konnect

Konnect administrators can track streams of security events and operational changes per organization.
You can do this by [setting up a webhook](/konnect/api/organization-settings/audit-logging/) to send data to any 
log collection service that supports [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm).

Audit logging webhooks must be configured using the [Organization Settings API](https://developer.konghq.com/spec/e46e7742-befb-49b1-9bf1-7cbe477ab818/d36126ee-ab8d-47b2-960f-5703da22cced).
Only Konnect organization administrators can configure and view audit log webhooks. 

Audit information includes authentication attempts, authorization requests, and gateway access logs. 
Each of the audit events contains a trace ID that allows events to be correlated to specific actions. 
See the [audit log reference](/konnect/org-management/audit-logging/reference) for details on what is logged.

{:.note}
> **Notes:**
* The Konnect UI does not currently support viewing audit logs.
* You can't customize the events that Konnect sends to the logs.



