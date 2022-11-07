git push --set-upstream origin dynatrace---
name: Dynatrace  
publisher: Dynatrace, Inc.

categories:
  - analytics-monitoring

type: integration

desc: Scap and visualize metrics on Dynatrace
description: | 
  Dynatrace is a software monitoring solution that supports cloud and managed systems and accelerates digital transformation.
  With Dynatrace you can bring your infrastructure, applications and user behaviour monitoring into a single platform powered with atrificial intelligence.
  One of the monitoring pillars is metrics. Dynatrace integrates counter, gauge, and summary metrics and enables charting, alerting and various ways of anaysis.
  To collect Kong Gateway metrics on Dynatrace, you can use the [Kong Prometheus plugin](https://docs.konghq.com/hub/kong-inc/prometheus/)
  and [Dynatrace OneAgent](https://www.dynatrace.com/support/help/shortlink/oneagent-hub)
  or [Dynatrace Operator](https://www.dynatrace.com/support/help/shortlink/monitor-prometheus-metrics) (on Kubernetes).

support_url: https://support.dynatrace.com/

privacy_policy_url: https://www.dynatrace.com/company/trust-center/policies/recruitment-privacy-notice/

terms_of_service_url: 	https://www.dynatrace.com/company/trust-center/terms-of-use/

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1+
  enterprise_edition:
    compatible:
      - 2.1+

params:
  dbless_compatible: yes
  
---

To try Dynatrace for free, please register for a free trial [here](https://www.dynatrace.com/trial/).

### Installation

Specific instructions are provided on the [Dynatrace documentation portal](https://www.dynatrace.com/support/help/shortlink/kong-gateway).
