---
title: Service Catalog Scorecards
beta: true
---

Scorecards in {{site.service_catalog_name}} allow platform teams to monitor services for compliance with Kong-recommended and industry-defined best practices in {{site.konnect_saas}}. By [integrating](/konnect/service-catalog/integrations/) Service Catalog with third-party applications, you can also use those in scorecard criteria.

When you enable a scorecard, you can choose from built-in criteria that you want the service to report on. For example, you can track if an on-call engineer is assigned in PagerDuty or the number of open PRs in a GitHub repository. From the scorecard view, you can see how many services are passing or failing a criteria, and which specific services those are.

![Scorecards dashboard](/assets/images/products/konnect/konnect-service-catalog-scorecards.png){:.image-border}

## Built-in scorecards

{{site.konnect_short_name}} provides several built-in scorecards to help ensure your services adhere to industry best practices:

* Service documentation
* Service maturity
* Kong best practices
* Security and compliance

### Service documentation

This built-in scorecard evaluates how well a service’s documentation, including API specs, adheres to industry standards.

It contains the following criteria by default:
* If a service contains documentation 
* If an owner is assigned to the service
* If the API spec passes the [recommended OpenAPI spec linting test](link)

### Service maturity

This built-in scorecard helps you determine how mature your services are based on criteria that use the [PagerDuty](/konnect/service-catalog/integrations/pagerduty/) and [GitHub](/konnect/service-catalog/integrations/github/) integrations. 

It contains the following criteria by default:
* The PagerDuty service has an active status 
* An on call engineer is assigned
* Number of incidents triggered in a timeframe
* Incident median time-to-resolution timeframe
* Number of open PRs
* Number of PR reviews required to merge into the default branch
* Median success of a GitHub action workflow over a timeframe
* Flakiness of a GitHub action workflow over a timeframe

### Kong best practices

This built-in scorecard determines how well your Gateway Services or [Mesh Manager](/konnect/mesh-manager/) adheres to Kong's best practice standards.

It contains the following criteria by default:
* Gateway Service error rate over a timeframe
* Gateway Service latency over a timeframe
* If mTLS is enabled for Mesh Manager
* If Mesh Manager uses HTTPS

### Security and compliance

This built-in scorecard helps you determine how secure your services are.

It contains the following criteria by default:
* Number of vulnerabilities that are open in [GitHub](/konnect/service-catalog/integrations/github/) or [Traceable](/konnect/service-catalog/integrations/traceable/)
* If the external-facing Traceable service is fronted by {{site.base_gateway}}
* If [Datadog](/konnect/service-catalog/integrations/datadog/) Monitor is configured and enabled

## Enable scorecards on a service

1. In Service Catalog, click **Scorecards** in the sidebar. 
1. Click **New Scorecard**.
1. Name the scorecard, enable or disable scorecard criteria, and select which services you want the scorecard to apply to. 
1. Click **Save**.


