---
name: Signal Sciences
publisher: Signal Sciences

categories:
  #- authentication
  - security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging

type: integration

desc: Secure your web applications and APIs without impacting your business
description: |
  Signal Sciences integrates with Kong to block malicious requests to your APIs including SQLi, XSS, and more. Kong’s fast, autoscaling API gateway provides a powerful and secure enterprise-class platform to front web traffic, where Signal Sciences focuses on Layer 7 application security for that traffic. Without writing or tuning regex signatures, Signal Sciences provides immediate protection over the following:

  * OWASP Top 10
  * Application DoS
  * Brute force attacks
  * Account abuse and misuse
  * Request rate limiting
  * Account takeover attacks
  * Bad bots
  * Virtual patching

  Additionally with [Power Rules and Network Learning Exchange](https://labs.signalsciences.com/product-launch-2018-power-rules-and-network-learning-exchange){:target="_blank"}{:rel="noopener noreferrer"}, Signal Sciences provides protections beyond what WAFs have traditionally been able to provide.

  Installation is simple, using a native NGINX module and a local agent that feed data into Signal Sciences Cloud Engine.

  For a free trial of Signal Sciences, [send a request](https://info.signalsciences.com/request-a-trial-kong-signal-sciences-0){:target="_blank"}{:rel="noopener noreferrer"}.

  "Using the integrated solution from Kong and Signal Sciences gives us the support we need across all applications, including serverless applications, regardless of how or where they are deployed,” said Jonathan Agha, VP Information Security at WeWork. “With Kong and Signal Sciences, we get greater visibility and architectural flexibility than we have had in the past, without sacrificing performance."

  "They give you visibility in to attacks against your applications, and even auto-blocking a bunch of them without that turning into a cascading horror-show." - Patrick Gray, Risky Biz Producer

support_url: https://docs.signalsciences.net/

#source_code:
  # (Optional) If your extension is open source, provide a link to your code.

#license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

privacy_policy_url: https://www.signalsciences.com/privacy/

#terms_of_service:
  # (Optional) Text describing your terms of service.

#terms_of_service_url:
  # (Optional) Link to your online TOS.

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
  enterprise_edition:
    compatible:
      - 1.3-x
      - 0.36-x
      - 0.35-x
      - 0.34-x

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Installation

See the [Signal Sciences install guide](https://docs.signalsciences.net/install-guides/other-modules/kong/){:target="_blank"}{:rel="noopener noreferrer"} for installation instructions.
