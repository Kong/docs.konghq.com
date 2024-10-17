<!-- used in Org Audit Logging Set Up Webhook and Dev Portal Audit Logging Set Up Webhook-->
Webhooks are triggered via an HTTPS request using the following retry rules:

- Minimum retry wait time: 1 second
- Maximum retry wait time: 30 seconds
- Maximum number of retries: 4

A retry is performed on a connection error, server error (`500` HTTP status code), or too many requests (`429` HTTP status code).

{% if include.desc == "Dev Portal" %}
{:.note}
> **Note:** Currently, Dev Portal audit logs only support authentication logs, which are triggered when a user logs in to Dev Portal.
{% endif %}

## Prerequisites

* A SIEM provider that supports the [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or raw JSON.
* [Org Admin permissions](/konnect/org-management/teams-and-roles/teams-reference/)

## Configure your SIEM provider

Before you can push audit logs to your SIEM provider, configure the service to receive logs. 
This configuration is specific to your vendor.

1. In your log collection service, configure an HTTPS data collection endpoint you can send CEF or raw JSON data logs to. {{site.konnect_short_name}} supports any HTTP authorization header type. Save the endpoint URL, this will be used later in {{site.konnect_short_name}}.

1. Create and save an access key from your SIEM provider. 

1. Configure your network's firewall settings to allow traffic through the `8071` TCP or UDP port that {{site.konnect_short_name}} uses for audit logging. 
See the [Konnect ports and network requirements](/konnect/network/).