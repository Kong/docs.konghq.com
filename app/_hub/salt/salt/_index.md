---
name: Salt Security
publisher: Salt Security

categories:
  - security

type: integration

desc: Integrate Kong API Gateway with Salt Security Discovery & Prevention for API-based apps
description: |
  The Salt Security Kong deployment is used to capture a mirror of application traffic and send it to the Salt Security Service for analysis.
  This plugin has low CPU and memory consumption and adds no latency to the application since
  it does not sit in line with the production traffic.
  The plugin needs to see unencrypted traffic (after SSL termination)
  to enable the Salt Security service to perform analysis.

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

#terms_of_service_url:
  # (Optional) Link to your online TOS.

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
  enterprise_edition:
    compatible:
      - 0.35-x
      - 0.34-x
---
