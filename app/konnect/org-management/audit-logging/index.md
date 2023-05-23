---
title: Audit Logging in Konnect
badge: enterprise
content_type: explanation
beta: true
---

Audit logging enables administrators to better spot security risks and maintain compliance of their core infrastructure. 

Audit logs can help you detect and respond to potential security incidents when they occur. Monitoring audit logs proactively can reduce the risk of outages and ensure continuous service for your users. No system can ever be completely secure, but audit logs can be a key part of your incident prevention infrastructure.

By tracking {{site.konnect_short_name}} audit logs, you gain the following benefits:
* **Security**: System events can be used to show abnormalities to be investigated, forensic information related to breaches, or provide evidence for compliance and regulatory purposes.
* **Compliance**: Regulators and auditors may require audit logs to confirm whether certain certification standards are met.
* **Debugging**: Audit logs can help determine the root causes of efficiency or performance issues.
* **Risk management**: Prevent issues or catch them early.

![Audit log webhook](/assets/images/docs/konnect/konnect-audit-log-webhook.png)

## Setting up audit logging in {{site.konnect_short_name}}

{{site.konnect_short_name}} administrators can track streams of security events and operational changes per organization.
You can do this by [setting up a webhook](/konnect/org-management/audit-logging/webhook/) to send data to any 
log collection service that supports [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or JSON-formatted data.

Audit logging webhooks can be configured through the {{site.konenct_short_name}} **Organization** menu, or
using the [Organization Settings API](https://developer.konghq.com/spec/e46e7742-befb-49b1-9bf1-7cbe477ab818/d36126ee-ab8d-47b2-960f-5703da22cced).
Only {{site.konnect_short_name}} organization administrators can configure and view audit log webhooks. 

Audit information includes authentication attempts, authorization requests, and gateway access logs. 
Each of the audit events contains a trace ID that allows events to be correlated to specific actions. 
See the [audit log reference](/konnect/org-management/audit-logging/reference) for details on what is logged.

{:.note}
> **Note:**
* You can't customize the events that {{site.konnect_short_name}} sends to the logs.



