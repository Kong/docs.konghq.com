---
title: Service Catalog Scorecards
beta: true
---

Scorecards in {{site.service_catalog_name}} allow platform teams to monitor services for compliance with Kong-recommended and industry-defined best practices in {{site.konnect_saas}}. By [integrating](/konnect/service-catalog/integrations/) Service Catalog with third-party applications, you can also use those in scorecard criteria.

When creating a scorecard, you define the validation criteria and specify which services should be evaluated. Scorecards help you detect issues, like whether there are services in the catalog that don't have an on-call engineer assigned or if you have GitHub repositories with stale pull requests that aren't getting reviewed or closed. From the scorecard view, you can view details on either a per-service or per-criteria basis.

![Scorecards dashboard](/assets/images/products/konnect/konnect-service-catalog-scorecards.png){:.image-border}

## Scorecard templates

{{site.konnect_short_name}} provides several scorecard templates to help ensure your services adhere to industry best practices.

| Scorecard template | Description |
|--------------------|-------------|
| Service documentation | Ensures that your services are well-documented with ownership information, documentation files, and [API specs](https://apistylebook.stoplight.io/). |
| Service maturity | Measure performance reflecting industry-defined DORA metrics: deployment frequency, lead time for changes, change failure rate, and time to restore service. |
| Kong best practices | Best practices that we encourage users to follow when using other {{site.konnect_short_name}} applications. |
| Security and compliance | Checks for that services are protected through external monitoring and vulnerability management tools. |

## Enable scorecards on a service

1. In Service Catalog, click **Scorecards** in the sidebar. 
1. Click **New Scorecard**.
1. Name the scorecard, configure scorecard criteria, and select which services you want the scorecard to apply to. 
1. Click **Save**.


## Service documentation linting

By default, the service documentation template supports the following Spectral recipes:

| Category           | Description     | Link |
|------------|----------|------|
| **OAS Recommended** | Uses Stoplight's style guide. Only considers criteria tagged with `"recommended: true"` | [Stoplight Style Guide](https://apistylebook.stoplight.io/docs/stoplight-style-guide) |
| **OWASP Top 10**   | Set of rules to check for OWASP security guidelines | [OWASP Top 10 API Security Guide](https://apistylebook.stoplight.io/docs/owasp-top-10-2023) |
| **URL Versioning** | Set of rules to check for versioning | [API Versioning Guide](https://apistylebook.stoplight.io/docs/versioning) |
| **Documentation**  | Set of rules to check for documentation best practices | [API Documentation Guidelines](https://apistylebook.stoplight.io/docs/documentation) |

