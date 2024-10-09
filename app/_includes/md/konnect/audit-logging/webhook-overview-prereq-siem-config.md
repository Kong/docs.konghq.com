<!-- used in Org Audit Logging Set Up Webhook and Dev Portal Audit Logging Set Up Webhook-->
Webhooks are triggered via an HTTPS request using the following retry rules:

- Minimum retry wait time: 1 second
- Maximum retry wait time: 30 seconds
- Maximum number of retries: 4

A retry is performed on a connection error, server error (`500` HTTP status code), or too many requests (`429` HTTP status code).

{:.note}
> **Notes:**
* Only supports HTTPS Webhook endpoints.
* You can't customize the events that {{site.konnect_short_name}} sends to the logs.

## Prerequisites

A SIEM provider that supports the [ArcSight CEF Format](https://docs.centrify.com/Content/IntegrationContent/SIEM/arcsight-cef/arcsight-cef-format.htm) or raw JSON.

## Configure your SIEM provider

Before you can push audit logs to your SIEM provider, configure the service to receive logs. 
This configuration is specific to your vendor.

1. Check your SIEM documentation to find out where to send CEF or raw JSON data.

1. In your log collection service, configure a data collection endpoint to push logs to. {{site.konnect_short_name}} supports any HTTP authorization header type. Save the endpoint URL, this will be used later in {{site.konnect_short_name}}.

1. Create and save an access key from your SIEM provider. 

1. Configure your firewall settings to allow traffic through the port that you're going to use. 
See the [Konnect ports and network requirements](/konnect/network/).