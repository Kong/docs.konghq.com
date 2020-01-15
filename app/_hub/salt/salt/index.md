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
  it does not sit in line of the production traffic.
  The plugin needs to see unencrypted traffic (after SSL termination)
  to enable the Salt Security service to perform analysis.

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
      - 0.34-x
      - 0.33-x

#########################

params: 
  name: salt
  api_id: false
  service_id: true
  consumer_id: false
  route_id: true

  config: 
    - name: salt_domain
      required: 'yes'
      default: 
      value_in_examples:
      description: Point to salt domain
    - name: salt_backend_port
      required: 'yes'
      default: 443
      value_in_examples:
      description: Salt beckend port
    - name: salt_token
      required: 'yes'
      default: 
      value_in_examples:
      description: Salt provided token

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# If you include headers, your headers MUST start at Level 2 (parsing to
# h2 tag in HTML). Heading Level 2 is represented by ## notation
# preceding the header text. Subsequent headings,
# if you choose to use them, must be properly nested (eg. heading level 2 may
# be followed by another heading level 2, or by heading level 3, but must NOT be
# followed by heading level 4)
###############################################################################
# BEGIN MARKDOWN CONTENT
---

## Salt Security Kong plugin

### Installation

Salt security is easy to deploy as a Kong module.

#### Install the plugin: [Follow this link if you need help](https://docs.konghq.com/1.0.x/plugin-development/distribution/#installing-the-plugin)

Once the .rock file has been obtained from your Salt Security distributor it can be installed using the luarocks package manager.

```shell
$ luarocks install kong-plugin-salt-agent-0.1.0-1.all.rock
```

#### Plugin configuration

Register Salt Security backend as a Kong service:

```shell
$ curl -X POST http://<kong-domain>:<kong-port>/services/<your-kong-service-id>/plugins/ \
  --data "name=salt-agent" \
  --data "config.salt_domain=<salt_domain>" \
  --data "config.salt_backend_port=<salt_backend_port>" \
  --data "config.salt_token=<salt_token>"
```

```text
1. [salt_domain] - Salt domain address
2. [salt_backend_port] - salt backend port (defaults to 443 if config.salt_backend_port not provided)
3. [salt_token] - company token
```

> Notice: installation might be different between kong versions
