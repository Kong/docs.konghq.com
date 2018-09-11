---
name: Kong Splunk Log

categories:
  - logging

type: plugin

desc: Log API transactions to Splunk using the Splunk HTTP collector

description: |
  Kong provides many great logging tools out of the box - this is a modified version of the Kong HTTP logging plugin that has been refactored and tailored to work with Splunk.

support_url: https://github.com/Optum/kong-splunk-log/issues

source_url: https://github.com/Optum/kong-splunk-log

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
      - 0.13.x
      - 0.12.x
    incompatible:
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.3.x
      - 0.2.x
  enterprise_edition:
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x
      - 0.31-x
      - 0.30-x
    incompatible:
      - 0.29-x

params:
  name: kong-splunk-log
  api_id: true
  service_id: true
  consumer_id: false
  route_id: true

  config:
    - name: splunk_access_token
      required: true
      value_in_examples: aaaaaaaa-bbbb-cccc-dddd-ffffffffffff
      urlencode_in_examples: false
      default:
      description: |
        Passes required Splunk header `Authorization Splunk:`
        `aaaaaaaa-bbbb-cccc-dddd-ffffffffffff`
    - name: method
      required: false
      value_in_examples: POST
      urlencode_in_examples: false
      default: POST
      description: HTTP Method to send to Splunk
    - name: content_type
      required: false
      value_in_examples: application/json
      urlencode_in_examples: false
      default: application/json
      description: Defines the Content-Type header to send to Splunk
    - name: timeout
      required: false
      value_in_examples: 10000
      urlencode_in_examples: false
      default: 10000
      description: The amount of time to wait on a Splunk transaction before timing out
    - name: keepalive
      required: false
      value_in_examples: 60000
      urlencode_in_examples: false
      default: 60000
      description: The amount of time to keep plugin connections with Splunk active
  extra: We recommend enabling the Splunk Logging plugin at a global level.

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

### Example Log in Splunk UI

![Splunk UI screen shot](https://konghq.com/wp-content/uploads/2018/09/SplunkLogSample.png)

### Installation

Recommended:

```
$ luarocks install kong-splunk-log
```

Other:

```
$ git clone https://github.com/Optum/kong-splunk-log.git /path/to/kong/plugins/kong-splunk-log
$ cd /path/to/kong/plugins/kong-splunk-log
$ luarocks make *.rockspec
```

### Configuration

The plugin requires an environment variable `SPLUNK_HOST`. This is how we define the `host=""` Splunk field in the example log picture embedded above in our README.

#### Example Plugin Configuration

![Splunk Config](https://konghq.com/wp-content/uploads/2018/09/SplunkConfig.png)

If not already set, it can be done so as follows:

```
$ export SPLUNK_HOST="gateway.company.com"
```

**One last step** is to make the environment variable accessible by an nginx worker. To do this, simply add this line to your _nginx.conf_

```
env SPLUNK_HOST;
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-splunk-log/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-splunk-log/blob/master/CONTRIBUTING.md) if you have any questions.
