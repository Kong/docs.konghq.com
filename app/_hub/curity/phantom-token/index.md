---
name: Curity Phantom Token
publisher: Curity
categories:
  - authentication
type: plugin
desc: Leverage the Phantom Token Pattern with the Curity Identity Server and Kong Gateway.
description: |

  This Curity developed plugin implements the [Phantom Token Pattern](https://curity.io/resources/learn/phantom-token-pattern/) and allows the Kong Gateway to introspect an opaque access token issued by the Curity Identity Server and in exchange receive a JWT. 

  High level flow:

  1. A client obtains an opaque (reference) token from the Curity Identity Server using any supported OAuth flow
  2. The opaque token is passed in the `Authorization` header in the request to an API via Kong
  3. This Phantom Token plugin will introspect the opaque token and get a JWT in the introspection result
  4. The plugin performs coarse-grained access control by checking that configured scopes are present in the JWT
  5. If coarse-grained authorization check passes the plugin will forward the JWT in the `Authorization` header to the upstream API

support_url: https://curity.io/resources/learn/integration-kong-open-source/
source_url: https://github.com/curityio/kong-phantom-token-plugin
license_type: Apache-2.0
license_url: https://github.com/curityio/kong-phantom-token-plugin/blob/main/LICENSE

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.4.x

params: # Metadata about your plugin
  name: phantom-token # Name of the plugin in Kong (may differ from name: above)
  service_id: true
  consumer_id: false
  route_id: false
  protocols: ["http", "https"]
  dbless_compatible: yes
  dbless_explanation:
  yaml_examples:
  k8s_examples:
  examples:

  config: # Configuration settings for your plugin
    - name: introspection_endpoint # setting name
      required: yes # string - setting required status
        # options are 'yes', 'no', or 'semi'
        # 'semi' means dependent on other settings
      default:  # any type - the default value (non-required settings only)
      datatype: string # specify the type of the value: e.g., string, array, boolean, etc.
      value_in_examples: https://idsvr.example.com/oauth/v2/oauth-introspect
        # If the field is to appear in examples, this is the value to use.
        # A required field with no value_in_examples entry will resort to
        # the one in default.
        # If providing an array, use the following format: [ "value1", "value2" ].
      description: The introspection endpoint of the Curity Identity Server.
        # Explain what this setting does.
        # Use YAML's pipe (|) notation for longer entries.

    - name: client_id 
      required: yes 
      default: 
      datatype: string 
      value_in_examples: gateway-client
      description: The id of the oauth client configured in the Curity Identity Server that has the Introspection capability enabled.

    - name: client_secret
      required: yes 
      default: 
      datatype: string 
      value_in_examples: Pa55w0rd!
      description: The secret of the oauth client configured in the Curity Identity Server that has the Introspection capability enabled.

    - name: token_cache_seconds 
      required: yes 
      default: 0 
      datatype: number 
      value_in_examples: 3600
      description: The time in seconds the JWT will be available in the Kong cache.

    - name: scope
      required: no         
      default:  
      datatype: string 
      value_in_examples: openid record
      description: Optional scope(s) needed in the introspected JWT in order for the phantom token plugin to allow the requested API to be called.

    - name: verify_ssl 
      required: yes 
      default: true 
      datatype: boolean 
      value_in_examples: false
      description: If the plugin should perform SSL validation when connecting to the Introspection endpoint. Might be helpful to set to `false` for testing purposes when using self-signed certificate that are not trusted.

  extra:
    # This is for additional remarks about your configuration.
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

## Installing and configuring the Curity Identity Server

The Curity Identity Server can be deployed and configured in several different ways. The [Getting Started Guides](https://curity.io/resources/getting-started/) provides a step-by-step approach to deployment and configuration for several different scenarios.

## Configuring the plugin

This plugin is available in the [Kong Phantom Token Plugin](https://github.com/curityio/kong-phantom-token-plugin) GitHub repository.

The [Integrating with Kong Open Source](https://curity.io/resources/learn/integration-kong-open-source/) article details the configuration of the plugin as well as options for testing.

Please [submit issues](https://github.com/curityio/kong-phantom-token-plugin/issues) as needed.
