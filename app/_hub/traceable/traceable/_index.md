---
# This file is for documenting an individual Kong plugin.

name: Traceable
publisher: Traceable
categories:
  - security
type: integration

desc: Enhance Kong with API posture management, runtime protection, analytics, and testing.
description: |
   With a simple and quick deployment of Traceable, you can confidently discover, test, and secure all of your APIs, then easily scale to meet the ongoing needs of your organization.
   
   Traceable:
   * discovers all of your APIs
   * continuously evaluates your API risk posture
   * tests your APIs for vulnerabilities as part of your SDLC
   * stops API attacks that lead to incidents such as data exfiltration
   * provides API analytics for threat hunting, root cause analysis, fraud detection, and forensic research

   Benefits:
   * Know your API risk exposure - Understand all of your API risks, where vulnerabilities are hiding, and where they might be out of compliance. Learn about all changes to your APIs and the potential risk imposed.
   * Know your data - Understand the nature of the data that flows between your microservices. Track changes that may impact customers or business-sensitive data, and know where sensitive data is potentially at risk.
   * Build Contextual Awareness - Learn the full API context and the unique behavior of your APIs, including user activity, API activity, data flow, and code execution. This allows you to quickly identify the right call patterns and attack patterns so you can immediately find and remediate API threats.
   * Know your business logic - Understand the unique business logic of all of your APIs and immediately detect known and unknown attacks, such as the OWASP web and API top 10, API fraud, API abuse, authentication and authorization vulnerabilities, and more.

   More details on [Traceable API Security](https://www.traceable.ai/?utm_medium=partner&utm_source=kong_hub){:target="_blank"}{:rel="noopener noreferrer"}

   To see Traceable in action you can [view our self-guided demo](https://www.traceable.ai/resources/lp/demo-api-security-exposure?utm_medium=partner&utm_source=kong_hub){:target="_blank"}{:rel="noopener noreferrer"} or [request a live demo](https://www.traceable.ai/request-a-demo?utm_medium=partner&utm_source=kong_hub){:target="_blank"}{:rel="noopener noreferrer"}

privacy_policy_url: https://www.traceable.ai/privacy-policy
terms_of_service_url: https://www.traceable.ai/terms-of-service/terms-of-service

# COMPATIBILITY
# Uncomment at least one of 'community_edition' (Kong Gateway open-source) or
# 'enterprise_edition' (Kong Gateway Enterprise) and set `compatible: true`.

kong_version_compatibility:
  community_edition:
    compatible:
    - 1.4.x
    - 1.5.x
    - 2.0.x
    - 2.1.x
    - 2.2.x
    - 2.3.x
    - 2.4.x
    - 2.5.x
    - 2.6.x
    - 2.7.x
    - 2.8.x
    - 3.0.x
  enterprise_edition:
    compatible:
    - 1.4.x
    - 1.5.x
    - 2.0.x
    - 2.1.x
    - 2.2.x
    - 2.3.x
    - 2.4.x
    - 2.5.x
    - 2.6.x
    - 2.7.x
    - 2.8.x
    - 3.0.x

#########################
# PLUGIN-ONLY SETTINGS below this line

params: # Metadata about your plugin
  dbless_compatible: yes
 
###############################################################################
# END YAML DATA

# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

## Installation

Traceable can be easily added to a Kong API Gateway ([gateway instructions](https://docs.traceable.ai/docs/kong){:target="_blank"}{:rel="noopener noreferrer"}) or to any Kong ingress controller ([ingress instructions](https://docs.traceable.ai/docs/kong-ingress-controller){:target="_blank"}{:rel="noopener noreferrer"}). 

## Trial Access

For access to a free trial please [contact our team](https://www.traceable.ai/Book-Meeting?utm_medium=partner&utm_source=kong_hub){:target="_blank"}{:rel="noopener noreferrer"}.