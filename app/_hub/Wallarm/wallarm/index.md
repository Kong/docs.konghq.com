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
  Wallarm AI-powered security platform automates application protection and security testing. Hundreds of customers already rely on Wallarm to secure websites, microservices and APIs running on private and public clouds. Wallarm AI enables application-specific dynamic WAF rules, proactively tests for vulnerabilities, and creates feedback loop to improve detection accuracy.

  * Detects the microservice’s logic and payload boundary from stateless http traffic analysis — without access to the code inside the container
  * Discovers new containers as they come on-line and uses machine learning to create dynamic security rules, instead of ACLs and signatures
  * Works well with CI/CD by updating security rules automatically and using vulnerability verification to cut down on the noise and false positives
  * Learns and decodes all the data formats including nested and encoded custom API protocols, such as JSON inside base64 encoding.

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

### Installation

Wallarm module is available on http://repo.wallarm.com.  Specific module installation instructions with complete OS-specific installation instructions provided here: https://docs.wallarm.com/en/admin-en/installation-kong-en.html
