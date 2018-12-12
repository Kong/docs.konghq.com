---
name: ArecaBay MicroSensor
publisher: ArecaBay

categories: 
  - security
  - analytics-monitoring
  - logging

type: plugin

desc: Discover, Monitor, and Secure your APIs at object/data level.
description: |
  ArecaBay enables enterprises to Discover, Monitor, and Secure APIs at object/data level.

  ArecaBay's Kong plugin installed in the Kong cluster is one type of ArecaBay MicroSensors that are light-weight software components built to access real-time API call level data without any modification to the applications or their runtime. They enable ArecaBay’s <b>Dynamic API Risk Trackers (DART)</b> and <b>API DLP</b>: a set of API level trackers and Data Leakage Prevention.

  DART provides an API data security posture dashboard for DevSecOps to continuously discover and monitor APIs across all clouds with zero-impact to apps. DART’s anomaly detection enables API DLP to take policy action against highly targeted data fields and transactions. Please visit this <a href = "https://www.arecabay.com/dart/">link</a> for more details.

  In addition to API Security, for developers and/or DevOps, ArecaBay's Kong plugin can be used to monitor and log application API calls with selective object level data.  

support_url:
  https://www.arecabay.com/partners/kong#support

source_url:
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

params: 
  name: ab-microsensor
  api_id: true
  service_id: true
  consumer_id: true
  route_id: true
  config: 
    - name: ab_localbay_ip
      required: yes
      default: 
      value_in_examples:
      description:
        The ArecaBay LocalBay IP that this plugin will connect and provide API event data.

    - name: ab_localbay_port
      required: yes
      default: 
      value_in_examples:
      description:
        The ArecaBay LocalBay Port that this plugin will connect and provide API event data.

    - name: ab_tenant_id
      required: yes
      default: 
      value_in_examples:
      description:
        The tenant id specific to the ArecaBay LocalBay.

    - name: ab_localbay_passphrase
      required: yes
      default: 
      value_in_examples:
      description:
        The passphrase for authentication with LocalBay.

    - name: ab_microsensor_name
      required: yes
      default: 
      value_in_examples:
      description:
        The name of this microsensor to be used for display purposes in the web console.

    - name: ab_microsensor_id
      required: yes
      default: 
      value_in_examples:
      description:
        The id of this microsensor.

  extra:
    # This is for additional remarks about your configuration.
---

## Installation
The installation of ArecaBay's Kong Plugin and the corresponding ArecaBay components is extremely simple and easy. It involves the following two steps:
1. Install and setup ArecaBay's Kong Plugin
2. Access ArecaBay Cloud Webconsole and configure ArecaBay Kong Plugin as a MicroSensor

### Install and setup ArecaBay's Kong Plugin
Install the ArecaBay's Kong plugin (ab-microsensor) on each node in your Kong cluster via luarocks. As this plugin source is already hosted in Luarocks.org, please run the below command:

```
luarocks install kong-plugin-ab-microsensor
```

Add to the custom_plugins list in your Kong configuration (on each Kong node):

```
custom_plugins = ab-microsensor
```

### Access ArecaBay Cloud Webconsole and setup LocalBay
Please visit the following page <a href = "https://www.arecabay.com/partners/kong">https://www.arecabay.com/partners/kong</a> and request your ArecaBay Cloud Webconsole account. Follow the quickstart guide within the Webconsole to configure your Kong Plugin as a MicroSensor. This involves providing details for the Kong Plugin MicroSensor and downloading the setup script. Run the setup script which internally uses the Kong Admin API to configure & run the Kong Plugin as a global plugin.  

