---
title: Service Catalog Scorecards
beta: true
---

Scorecards in {{site.service_catalog_name}} allow platform teams to monitor services for compliance with Kong-recommended and industry-defined best practices in {{site.konnect_saas}}. By [integrating](/konnect/service-catalog/integrations/) Service Catalog with third-party applications, you can also use those in scorecard criteria.

When you enable a scorecard, you can choose from criteria that you want the service to report on. For example, you can track if an on-call engineer is assigned in PagerDuty or the number of open PRs in a GitHub repository. From the scorecard view, you can see how many services are passing or failing a criteria, and which specific services those are.

![Scorecards dashboard](/assets/images/products/konnect/konnect-service-catalog-scorecards.png){:.image-border}

## Scorecard templates

{{site.konnect_short_name}} provides several scorecard templates to help ensure your services adhere to industry best practices.

| Scorecard template | Description |
|--------------------|-------------|
| Service documentation | Evaluates how well a service’s documentation, including API specs, adheres to [OpenAPI industry standards](https://apistylebook.stoplight.io/). |
| Service maturity | Helps you determine how mature your services are based on criteria that use the [PagerDuty](/konnect/service-catalog/integrations/pagerduty/) and [GitHub](/konnect/service-catalog/integrations/github/) integrations. |
| Kong best practices | Determines how well your services adhere to Kong's best practice standards for Kong's features, such as [Gateway Services](/konnect/gateway-manager/configuration/#gateway-services). |
| Security and compliance | Helps you determine how secure your services are based on criteria such as pull request reviews and number of open vulnerabilities. |

## Enable scorecards on a service

1. In Service Catalog, click **Scorecards** in the sidebar. 
1. Click **New Scorecard**.
1. Name the scorecard, enable or disable scorecard criteria, and select which services you want the scorecard to apply to. 
1. Click **Save**.


