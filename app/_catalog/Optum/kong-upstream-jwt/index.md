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

name: Kong Upstream JWT # (required) The name of your extension.
  # Use capitals and spaces as needed.
id: kong-upstream-jwt # a slug-formatted string to represent your extension
  # Use only lowercase letters, numerals, and hyphens (-).

categories: # (required) Uncomment all that apply.
  # - authentication
  - security
  #- traffic-control
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

desc: Add a signed JWT into the header of proxied requests # (required) 1-liner description; max 80 chars
description: |
  This plugin will add a signed JWT into the HTTP Header `JWT` of proxied requests through the Kong gateway. The purpose of this, is to provide means of _Authentication_, _Authorization_ and _Non-Repudiation_ to API providers (APIs for which Kong is a gateway).

  API Providers need a means of cryptographically validating that requests they receive were proxied by Kong and not tampered with during transmission from Kong -> API Provider. This token accomplishes both as follows:

  1. **Authentication** & **Authorization** - Provided by means of JWT signature validation. The API Provider will validate the signature on the JWT token (which is generating using Kong's RSA x509 private key), using Kong's public key. This public key can be maintained in a keystore, or sent with the token - provided API providers validate the signature chain against their truststore.

  2. **Non-Repudiation** - SHA256 is used to hash the body of the HTTP request body, and the resulting digest is included in the `payloadhash` element of the JWT body. API Providers will take the SHA256 hash of the HTTP Request Body, and compare the digest to that found in the JWT. If they are identical, the request remained intact during transmission.

# (required) extended description.
# Use YAML piple notation for extended entries.

support_url: https://github.com/Optum/kong-upstream-jwt/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/Optum/kong-upstream-jwt/
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


#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params: # metadata about your plugin
  name: kong-upstream-jwt # name of the plugin in Kong
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

extra: |
  Installing this plugin globally will ensure security across all proxies for service providers who implement the JWT validation correctly.
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

Recommended:

```
$ luarocks install kong-upstream-jwt
```

Other:

```
$ git clone https://github.com/Optum/kong-upstream-jwt.git /path/to/kong/plugins/kong-upstream-jwt
$ cd /path/to/kong/plugins/kong-upstream-jwt
$ luarocks make *.rockspec
```

### Configuration

The plugin requires that Kong's private key be accessible in order to sign the JWT. [We also include the x509 cert in the `x5c` JWT Header for use by API providers to validate the JWT](https://tools.ietf.org/html/rfc7515#section-4.1.6). We access these via Kong's overriding environment variables `KONG_SSL_CERT_KEY` for the private key as well as `KONG_SSL_CERT_DER` for the public key. The first contains the path to your .key file, the second specifies the path to your public key in DER format .cer file.

If not already set, these can be done so as follows:

```
$ export KONG_SSL_CERT_KEY="/path/to/kong/ssl/privatekey.key"
$ export KONG_SSL_CERT_DER="/path/to/kong/ssl/kongpublickey.cer"
```

**One last step** is to make the environment variables accessible by an nginx worker. To do this, simply add these line to your _nginx.conf_

```
env KONG_SSL_CERT_KEY;
env KONG_SSL_CERT_DER;
```

### Maintainers

[jeremyjpj0916](https://github.com/jeremyjpj0916)  
[rsbrisci](https://github.com/rsbrisci)  

Feel free to [open issues](https://github.com/Optum/kong-upstream-jwt/issues), or refer to our [Contribution Guidelines](https://github.com/Optum/kong-upstream-jwt/blob/master/CONTRIBUTING.md) if you have any questions.
