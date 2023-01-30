---
name: Kong Splunk Log
publisher: Optum

categories:
  - logging

type: plugin

desc: Log API transactions to Splunk using the Splunk HTTP collector

description: |
  Kong provides many great logging tools out of the box - this is a modified version of the Kong HTTP logging plugin that has been refactored and tailored to work with Splunk.

support_url: https://github.com/Optum/kong-splunk-log/issues

source_code: https://github.com/Optum/kong-splunk-log

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
      - 0.13.x

  enterprise_edition:
    compatible:
      - 0.34-x
      - 0.33-x
      - 0.32-x

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

```bash
$ luarocks install kong-splunk-log
```

Other:

```bash
$ git clone https://github.com/Optum/kong-splunk-log.git /path/to/kong/plugins/kong-splunk-log
$ cd /path/to/kong/plugins/kong-splunk-log
$ luarocks make *.rockspec
```

### Configuration

The plugin requires an environment variable `SPLUNK_HOST`. This is how we define the `host=""` Splunk field in the example log picture embedded above in our README.

#### Example Plugin Configuration

![Splunk Config](https://konghq.com/wp-content/uploads/2018/09/SplunkConfig.png)

If not already set, it can be done so as follows:

```bash
$ export SPLUNK_HOST="gateway.company.com"
```

**One last step** is to make the environment variable accessible by an nginx worker. To do this, simply add this line to your _nginx.conf_

```
env SPLUNK_HOST;
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916){:target="_blank"}{:rel="noopener noreferrer"}  
[rsbrisci](https://github.com/rsbrisci){:target="_blank"}{:rel="noopener noreferrer"}  

Feel free to [open issues](https://github.com/Optum/kong-splunk-log/issues){:target="_blank"}{:rel="noopener noreferrer"}, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-splunk-log/blob/master/CONTRIBUTING.md){:target="_blank"}{:rel="noopener noreferrer"} if you have any questions.
