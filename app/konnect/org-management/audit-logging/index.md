---
title: Audit Logging in Konnect
badge: enterprise
content_type: explanation
---

Audit logging enables administrators to better spot security risks and maintain compliance of their core infrastructure. 

Audit logs can help you detect and respond to potential security incidents when they occur. Monitoring audit logs proactively can reduce the risk of outages and ensure continuous service for your users. No system can ever be completely secure, but audit logs can be a key part of your incident prevention infrastructure.

By tracking {{site.konnect_short_name}} audit logs, you gain the following benefits:
* **Security**: System events can be used to show abnormalities to be investigated, forensic information related to breaches, or provide evidence for compliance and regulatory purposes.
* **Compliance**: Regulators and auditors may require audit logs to confirm whether certain certification standards are met.
* **Debugging**: Audit logs can help determine the root causes of efficiency or performance issues.
* **Risk management**: Prevent issues or catch them early.

## Setting up audit logging in {{site.konnect_short_name}}

{{site.konnect_short_name}} administrators can track streams of security events and operational changes per organization.
You can do this by [setting up a webhook](/konnect/org-management/audit-logging/webhook/) to send data to any 
log collection service that supports [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or JSON-formatted data.

Audit logging webhooks can be configured through the {{site.konenct_short_name}} **Organization** menu, or
using the [Audit Logs API](/konnect/api/audit-logs/v2/).
Only {{site.konnect_short_name}} org admins can configure and view audit log webhooks. 

![Audit log webhook](/assets/images/products/konnect/audit-logs/konnect-audit-log-webhook.png)

Audit information includes authentication attempts and authorization requests.
Each of the audit events contains a trace ID that allows events to be correlated to specific actions. 
See the [audit log reference](/konnect/org-management/audit-logging/reference/) for details on what is logged.

{:.note}
> **Note:** You can't customize the events that {{site.konnect_short_name}} sends to the logs.

## More information
* [Set up an audit log webhook](/konnect/org-management/audit-logging/webhook/)
* [Set up an audit log replay job](/konnect/org-management/audit-logging/replay-job/)
* [Audit log event reference](/konnect/org-management/audit-logging/reference/)
* [Verify audit log signatures](/konnect/org-management/audit-logging/verify-signatures/)
* [Audit Logs API](/konnect/api/audit-logs/v2/)
