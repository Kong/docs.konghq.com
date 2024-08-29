---
title: Audit Logging in Konnect
badge: enterprise
content_type: explanation
---

Audit logging enables administrators to better spot security risks and maintain compliance of their core infrastructure. 

Audit logs can help you detect and respond to potential security incidents when they occur. Monitoring audit logs proactively can reduce the risk of outages and ensure continuous service for your users. No system can ever be completely secure, but audit logs can be a key part of your incident prevention infrastructure.

By tracking {{site.dev-portal_short_name}} audit logs, you gain the following benefits:
* **Security**: System events can be used to show abnormalities to be investigated, forensic information related to breaches, or provide evidence for compliance and regulatory purposes.
* **Compliance**: Regulators and auditors may require audit logs to confirm whether certain certification standards are met.
* **Debugging**: Audit logs can help determine the root causes of efficiency or performance issues.
* **Risk management**: Prevent issues or catch them early.

## Setting up dev-portal audit logging in {{site.dev-portal_short_name}}

{{site.dev-portal_short_name}} administrators can track streams of security events and operational changes per organization.
You can do this by [setting up a webhook](/konnect/dev-portal/audit-logging/webhook/) to send data to any 
log collection service that supports [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or JSON-formatted data.

Audit logging webhooks can be configured through the {{site.portal_short_name}} **Settings >> Audit Logs Setup** menu, or
using the [Dev Portal Audit Logs API](/konnect/api/audit-logs/latest/).
Only {{site.dev-portal_short_name}} org admins and portal admins can configure and view portal audit log webhooks. 

![Audit log webhook](/assets/images/products/konnect/audit-logs/konnect-audit-log-webhook.png)

Audit information includes authentication attempts and authorization requests.
Each of the audit events contains a trace ID that allows events to be correlated to specific actions. 
See the [audit log reference](/konnect/dev-portal/audit-logging/reference/) for details on what is logged.

{:.note}
> **Note:** You can't customize the events that {{site.dev-portal_short_name}} sends to the logs.
    
## More information
* [Set up an audit log destination](/konnect/dev-portal/audit-logging/destination/)
* [Set up an portal audit log webhook](/konnect/dev-portal/audit-logging/webhook/)
* [Set up an portal audit log replay job](/konnect/dev-portal/audit-logging/replay-job/)
* [Portal Audit log event reference](/konnect/dev-portal/audit-logging/reference/)
* [Verify audit log signatures](/konnect/dev-portal/audit-logging/verify-signatures/)
* [Dev Portal Audit Logs API](/konnect/api/audit-logs/latest/)
