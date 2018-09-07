---
# This file is for profiling an individual Kong extension.
# Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to _app/_catalog/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com
# Remove inapplicable entries and superfluous comments as needed

name: Kong Service Virtualization # (required) The name of your extension.
  # Use capitals and spaces as needed.

categories: # (required) Uncomment all that apply.
  #- authentication
  #- security
  - traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
# Array format only; uncomment one or more applicable categories.
# If you would like to add a category, you may do so here.

type: plugin # (required) String or Array of strings if multiple fit.
# options:
  # plugin          | extensions of the core platform
  # api-integration | extensions of the Kong Admin API
  # dev-mod         | enhancements of the Long dev portal
# for multiple, list like so: [api-integration,dev-mod]

desc: Mock virtual API request and response pairs through Kong Gateway # (required) 1-liner description; max 80 chars
description: |
  This plugin will enable mocking virtual API request and response pairs through Kong Gateway.

# (required) extended description.
# Use YAML piple notation for extended entries.

support_url: https://github.com/Optum/kong-service-virtualization/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/Optum/kong-service-virtualization
  # (Optional) If your extension is open source, provide a link to your code.

license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service: |
  #(Optional) Text describing your terms of service.

#terms_of_service_url:
  # (Optional) Link to your online TOS.

# COMPATIBILITY
# In the following sections, list Kong versions as array items
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be noted as "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
      - 0.13.x
    incompatible:
      - 0.12.x
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
    incompatible:
      - 0.31-x
      - 0.30-x
      - 0.29-x


#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: kong-service-virtualization # name of the plugin in Kong
  api_id: true
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id: true
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id: false
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id: true
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.

  config:
    - name: virtual_tests
      required: true
      value_in_examples: [{"name":"TestCase1","requestHttpMethod":"POST","requestHash":"0296217561490155228da9c17fc555cf9db82d159732f3206638c25f04a285c4","responseHttpStatus":"200","responseContentType":"application/json","response":"eyJtZXNzYWdlIjogIkEgQmlnIFN1Y2Nlc3MhIn0="},{"name":"TestCase2","requestHttpMethod":"GET","requestHash":"e2c319e4ef41706e2c0c1b266c62cad607a014c59597ba662bef6d10a0b64a32","responseHttpStatus":"200","responseContentType":"application/json","response":"eyJtZXNzYWdlIjogIkFub3RoZXIgU3VjY2VzcyEifQ=="}]
      urlencode_in_examples: false
      default:
      description: A JSON array as string representation of the plugin's configurable fields.
  extra: |
      `name` JSON represents a human readable test case name

      `requestHttpMethod` JSON represents the HTTP method associated to the virtual request

      `requestHash` JSON represents the Sha256 of the HTTP Body or QUERY Parameters of your request

      `responseHttpStatus` JSON represents the HTTP response to send consumers after successful virtual match

      `responseContentType` JSON represents the Content-Type of the HTTP response after successful virtual request match

      `response` JSON represents the Base64 encoded virtual response to send after successful virtual request match
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

### Overview
This plugin will enable mocking virtual API request and response pairs through Kong Gateway.

### Explanation

`kong-service-virtualization` schema `virtual_tests` arguments:

```
[
     {
           "name": "TestCase1",           
           "requestHttpMethod": "POST",
           "requestHash": "0296217561490155228da9c17fc555cf9db82d159732f3206638c25f04a285c4",
           "responseHttpStatus": "200",
           "responseContentType": "application/json",
           "response": "eyJtZXNzYWdlIjogIkEgQmlnIFN1Y2Nlc3MhIn0="
    },
    {         
           "name": "TestCase2",           
           "requestHttpMethod": "GET",
           "requestHash": "e2c319e4ef41706e2c0c1b266c62cad607a014c59597ba662bef6d10a0b64a32",
           "responseHttpStatus": "200",
           "responseContentType": "application/json",
           "response": "eyJtZXNzYWdlIjogIkFub3RoZXIgU3VjY2VzcyEifQ=="
    }
]
```

Where `TestCase1` and `TestCase2` are the names of the virtual test cases and must be passed in as a header value:

`X-VirtualRequest: TestCase1`

or

`X-VirtualRequest: TestCase2`

The `requestHash` arg is a Sha256(HTTP Request as query parameters or HTTP Body).
The `response` arg is a Base64 encoded format of the response HTTP Body.

So the above plugin equates to these psuedo requests:

```
https://gateway.company.com/virtualtest

POST:
{
   "virtual": "test"
}
Response : {"message": "A Big Success!"} as base64 encoded in plugin

GET:
hello=world&service=virtualized
Response : {"message": "Another Success!"} as base4 encoded in plugin

```

In the event you do not successfully match on request you will receive a Sha256 comparison for you own personal debugging:

```
Status Code: 404 Not Found
Content-Length: 207
Content-Type: application/json; charset=utf-8

{"message":"No virtual request match found, your request yeilded: 46c4b4caf0cc3a5a589cbc4e0f3cd0492985d5b889f19ebc11e5a5bd6454d20f expected 0296217561490155228da9c17fc555cf9db82d159732f3206638c25f04a285c4"}
```

If the test case specified in the header does not match anything found stored within the plugin your error would be like so:
Passing `X-VirtualRequest: TestCase3` in header yields:

```
Status Code: 404 Not Found
Content-Length: 49
Content-Type: application/json; charset=utf-8

{"message":"No matching virtual request found!"}
```

### Installation
Recommended:

```
$ luarocks install kong-service-virtualization
```

Optional:

```
$ git clone https://github.com/Optum/kong-service-virtualization
$ cd /path/to/kong/plugins/kong-service-virtualization
$ luarocks make *.rockspec
```

### Maintainers
[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-service-virtualization/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-service-virtualization/blob/master/CONTRIBUTING.md) if you have any questions.
