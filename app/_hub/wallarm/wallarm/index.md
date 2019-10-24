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
  Wallarm AI-Powered Security Platform automates application protection and security testing. Its NG WAF module seamlessly integrates with API gateway and protects APIs and microservices from OWASP Top 10, bots and application abuse with no manual rule configuration and ultra-low false positives.

  * Protects all types of REST, XML, SOAP and other HTTP APIs from XSS, XXE, SQL Injections, RCE and other OWASP Top 10 threats
  * Detects the microservice’s logic and payload boundary from stateless HTTP traffic analysis — without access to the code inside the container
  * Works well with CI/CD by updating security rules automatically
  * Provides visibility on malicious requests and uses vulnerability verification to cut down on the noise and false positives
  * Learns and decodes all the data formats including nested and encoded custom API protocols, such as JSON inside Base64 encoding.

#support_url:
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

#source_url:
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

terms_of_service_url: https://wallarm.com/terms-of-service.html

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
#    incompatible:
  enterprise_edition:
    compatible:
      - 0.33-x
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

More details on Wallarm NG WAF: https://wallarm.com/products/ng-waf.

Free Wallarm trial license is available at https://my.wallarm.com/signup?utm_source=konghub.

“Wallarm implementation was one of many steps to migrate our application iMedNet to AWS. Ensuring the ability to monitor and secure our web-based APIs and to meet HIPAA guidelines for PHI compliance were important in the decision to go with Wallarm”, said Gary Johnson, Infrastructure Architect at MedNetStudy.

“Wallarm offers an adaptive security platform including an integrated Web vulnerability scanner and NG-WAF solution with automatically generated security rules based on AI”, said Chris Rodriguez, Senior Security Analyst, Frost & Sullivan

### Installation

Wallarm is easy to deploy as a Kong module. Specific module installation instructions with complete OS-specific installation instructions provided here: https://docs.wallarm.com/en/admin-en/installation-kong-en.html
