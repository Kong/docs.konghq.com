---
name: Wallarm
publisher: Wallarm

categories:
  #- authentication
  - security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging

type: integration

desc: Wallarm is AI-Powered Security Platform for protecting microservices and APIs

description: |
  Wallarm Advanced API Security and WAAP products provide robust protection for APIs, microservices, and serverless workloads running in cloud-native environments. Hundreds of Security and DevOps teams choose Wallarm to get unique visibility into malicious traffic, robust protection across their whole API portfolio, and automated incident response for product security programs. Wallarm supports modern tech stacks, offering dozens of deployment options in public clouds, multi-cloud, and Kubernetes-based environments, in addition to providing a full cloud solution. Wallarm provides the following benefits:

  * Protect your web applications and APIs against OWASP Security Top-10 risks and other advanced API threats like injections, Broken Object Level Authorization (BOLA), and authentication failures.
  * Get runtime visibility across your entire API portfolio, minimize API drift, and prioritize security efforts (like pen tests or bug bounties) with alerts on new, changed, or deprecated endpoints.
  * Meet compliance requirements by tracking and protecting sensitive data, including personally identifiable information (PII), financial and health data, credentials and more.

#support_url:
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

#source_code:
  # (Optional) If your extension is open source, provide a link to your code.

#license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service:
  # (Optional) Text describing your terms of service.

terms_of_service_url: https://www.wallarm.com/terms-of-service

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.7.x
#    incompatible:
  enterprise_edition:
    compatible:
      - 2.7.x
#    incompatible:

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

More details on [Wallarm API Security Platform](https://www.wallarm.com/product/wallarm-cloud-native-platform-overview?utm_source=konghub){:target="_blank"}{:rel="noopener noreferrer"}.

Free Wallarm trial license is available [here](https://my.wallarm.com/signup?utm_source=konghub){:target="_blank"}{:rel="noopener noreferrer"}.



### Installation

Wallarm is easy to deploy as a Kong module. Specific module installation instructions with complete OS-specific installation instructions are provided [here](https://docs.wallarm.com/admin-en/installation-kong-en/?utm_source=konghub){:target="_blank"}{:rel="noopener noreferrer"}. 
