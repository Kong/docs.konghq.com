---
# This file is for profiling an individual Kong extension.
# Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to _app/_hub/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com
# Remove inapplicable entries and superfluous comments as needed

name: Portal Application Registration
publisher: Kong Inc.
version: 1.5.x

categories: # (required) Uncomment all that apply.
  - authentication
  #- security
  #- traffic-control
  #- serverless
  #- analytics-monitoring
  #- transformations
  #- logging
  # - deployment
# Array format only; uncomment the one most-applicable category. Contact cooper@konghq.com to propose a new category, if necessary.

type: # (required) String, one of:
  plugin
desc: Self-service portal developer credentials against specific services.
description: |
  Applications allow registered developers on Kong Developer Portal to
  authenticate with OAuth against a Service on Kong. Admins can selectively
  admit access to Services using Kong Manager.

  When configuring the plugin, at least one of the following OAuth2 auth flows must be enabled:

  * Authorization Code
  * Client Credentials
  * Implicit Grant
  * Password Grant

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

# COMPATIBILITY
# In the following sections, list Kong versions as array items.
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be considered to have "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: # required
  #community_edition: # optional
    #compatible:
    #incompatible:
  enterprise_edition: # optional
    compatible:
    - 1.5.x
    #incompatible:

# EXAMPLE kong_version_compatibility blocks - these examples show how to indicate various compatibilities. Also see other extension files in _app/_hub/ for more examples
# EXAMPLE 1 - in this example, the extension is known to be compatible with recent versions of Kong and Kong Enterprise, and is not known to be incompatible with any versions
#kong_version_compatibility:
#  community_edition:
#    compatible:
#      - 0.12.x
#      - 0.13.x
#      - 0.14.x
#    incompatible:
#  enterprise_edition:
#    compatible:
#      - 0.32-x
#      - 0.33-x
#      - 0.34-x
#    incompatible:
#
# EXAMPLE 2 - in this example, the extension is known to be compatible only the most recent versions of Kong and Kong Enterprise, and is known to be incompatible with all older versions
#kong_version_compatibility:
#  community_edition:
#    compatible:
#      - 0.14.x
#      - 0.13.x
#    incompatible:
#      - 0.12.x
#      - 0.11.x
#      - 0.10.x
#      - 0.9.x
#      - 0.8.x
#      - 0.7.x
#      - 0.6.x
#      - 0.5.x
#      - 0.3.x
#      - 0.2.x
#  enterprise_edition:
#    compatible:
#      - 0.34-x
#      - 0.33-x
#      - 0.32-x
#    incompatible:
#      - 0.31-x
#      - 0.30-x
#      - 0.29-x

#########################
# PLUGIN-ONLY SETTINGS below this line
# If your extension is a plugin, ALL of the following lines must be completed.
# If NOT an plugin, delete all lines up to '# BEGIN MARKDOWN CONTENT'

params:
  name: application-registration
  api_id:
    # boolean - whether this plugin can be applied to an API [[this needs more]]
  service_id:
    # boolean - whether this plugin can be applied to a Service.
    # Affects generation of examples and config table.
  consumer_id:
    # boolean - whether this plugin can be applied to a Consumer.
    # Affects generation of examples and config table.
  route_id:
    # whether this plugin can be applied to a Route.
    # Affects generation of examples and config table.
  protocols:
    # List of protocols this plugin is compatible with.
    # Valid values: "http", "https", "tcp", "tls"
    # Example: ["http", "https"]
  dbless_compatible:
    # Degree of compatibility with DB-less mode. Three values allowed:
    # 'yes', 'no' or 'partially'
  dbless_explanation:
    # Optional free-text explanation, usually containing details about the degree of
    # compatibility with DB-less.

  config: # Configuration settings for your plugin
    - name: # setting name
      required: # string - setting required status
        # options are 'yes', 'no', or 'semi'
        # 'semi' means dependent on other settings
      default: # any type - the default value (non-required settings only)
      value_in_examples:
        # If the field is to appear in examples, this is the value to use.
        # A required field with no value_in_examples entry will resort to
        # the one in default.
      description:
        # Explain what this setting does.
        # Use YAML's pipe (|) notation for longer entries.
    - name: config.auth_header_name
      required: false
      default: "`authorization`"
      description: |
        The name of the header that is supposed to carry the access token.
        Default: `authorization`.
    - name: config.auto_approve
      required: no
      default: false
      value_in_examples:
      description:
        If enabled, all new Service Contracts requests are automatically approved. Otherwise, Dev Portal admins must manually approve requests.  
    - name: config.description
      required: no
      default:
      value_in_examples:
      description:
        Description displayed in information about a Service in the Developer Portal.
    - name: config.display_name
      required: yes
      default:
      value_in_examples:
      description:
        Display name used for a Service in the Developer Portal.
    - name: config.enable_authorization_code
      required: false
      default: "`false`"
      value_in_examples: true
      description: |
        An optional boolean value to enable the three-legged Authorization
        Code flow ([RFC 6742 Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)).
    - name: config.enable_client_credentials
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Client Credentials Grant
        flow ([RFC 6742 Section 4.4](https://tools.ietf.org/html/rfc6749#section-4.4)).
    - name: config.enable_implicit_grant
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Implicit Grant flow, which
        allows to provision a token as a result of the authorization
        process ([RFC 6742 Section 4.2](https://tools.ietf.org/html/rfc6749#section-4.2)).
    - name: config.enable_password_grant
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Resource Owner Password
        Credentials Grant flow ([RFC 6742 Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3)).
      - name: config.mandatory_scope
        required: no
        default: false
        value_in_examples:
        description:
          An optional boolean value telling the plugin to require at least
          one scope to be authorized by the end user.
      - name: config.provision_key
        required: yes
        default: autogenerated
        value_in_examples:
        description:
          The Provision Key is automatically generated on creation. No input
          is required. Used by the Resource Owner Password Credentials Grant
          (Password Grant) flow.
      - name: config.refresh_token_ttl
        required: yes
        default: 1209600
        value_in_examples:
        description:
          An optional integer value telling the plugin how many seconds a
          token/refresh token pair is valid for, and can be used to generate
          a new access token. Default value is two weeks. Set to `0` to
          keep the token/refresh token pair indefinitely valid.
      - name: config.scopes
        required: no
        default:
        value_in_examples:
        description:
          Describes an array of scope names that will be available to the
          end-user.
      - name: config.token_expiration
        required: no
        default: 7200
        value_in_examples:
        description:
          An optional integer value telling the plugin how many seconds a token
          should last, after which the client will need to refresh the token.
          Set to `0` to disable the expiration.

  #  - name: # add additional setting blocks as needed, each demarcated by -
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

## Example: testing 123
