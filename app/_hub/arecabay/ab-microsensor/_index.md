---
name: ArecaBay MicroSensor
publisher: ArecaBay

categories:
  - analytics-monitoring

type: plugin

desc: Discover, Monitor, and Secure your APIs at object/data level.
description: |
  ArecaBay enables enterprises to Discover, Monitor, and Secure APIs at object/data level.

  ArecaBay's Kong plugin installed in the Kong cluster is one type of ArecaBay MicroSensors that are light-weight software components built to access real-time API call level data without any modification to the applications or their runtime. They enable ArecaBay’s <b>Dynamic API Risk Trackers (DART)</b> and <b>API DLP</b>: a set of API level trackers and Data Leakage Prevention.

  DART provides an API data security posture dashboard for DevSecOps to continuously discover and monitor APIs across all clouds with zero-impact to apps. DART’s anomaly detection enables API DLP to take policy action against highly targeted data fields and transactions. Please visit this [link](https://www.arecabay.com/dart/){:target="_blank"}{:rel="noopener noreferrer"} for more details.

  In addition to API Security, for developers and/or DevOps, ArecaBay's Kong plugin can be used to monitor and log application API calls with selective object level data.  

support_url:
  https://www.arecabay.com/partners/kong#support

source_code:
  https://luarocks.org/modules/sekhar-arecabay/ab-microsensor

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

# COMPATIBILITY
# In the following sections, list Kong versions as array items.
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be considered to have "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: 
  community_edition:
    compatible:
      - 0.12.x
      - 0.13.x
      - 0.14.x
    incompatible:
  enterprise_edition: # optional
    compatible:
      - 0.32-x
      - 0.33-x
      - 0.34-x
    incompatible:

#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'
---
