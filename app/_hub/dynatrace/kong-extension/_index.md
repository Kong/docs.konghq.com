---
name: Dynatrace  
publisher: Dynatrace, Inc.

categories:
  - analytics-monitoring

type: integration

desc: Intelligently monitor, analyze, and optimize your Kong Gateway and its managed APIs.
description: | 
  With AI and complete automation, the Dynatrace platform provides answers, not just data, about the performance of applications, the underlying infrastructure, and users’ experience. That’s why many of the world’s largest enterprises trust Dynatrace to modernize and automate enterprise cloud operations, release better software faster, and deliver unrivaled digital experiences.  

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

Start your [free trial](https://www.dynatrace.com/trial/).

### Set up monitoring

With Dynatrace, you can get full observability for your Kong Gateway and its managed APIs.
To get trace insights, install [Dynatrace OneAgent]( https://www.dynatrace.com/support/help/shortlink/oneagent-hub/) or [set up Dynatrace on Kubernetes/OpenShift](https://www.dynatrace.com/support/help/shortlink/kubernetes-hub).
To get metric insights, use the [Kong Prometheus plugin]( https://docs.konghq.com/hub/kong-inc/prometheus/) in conjunction with [Dynatrace OneAgent]( https://www.dynatrace.com/support/help/shortlink/oneagent-hub/) or [Dynatrace Operator]( https://www.dynatrace.com/support/help/shortlink/monitor-prometheus-metrics/) (on Kubernetes).
For detailed instructions on Kong Gateway monitoring, see the [Dynatrace documentation](https://www.dynatrace.com/support/help/shortlink/kong-gateway).
