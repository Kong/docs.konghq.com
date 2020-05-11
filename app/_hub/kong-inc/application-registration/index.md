---
name: Portal Application Registration
publisher: Kong Inc.
version: 1.0.x

desc: Allow portal developers to register applications against services
description: |
  Applications allow registered developers on Kong Developer Portal to
  authenticate with OAuth against a Service on Kong. Admins can
  selectively admit access to Services using Kong Manager.

enterprise: true
type: plugin
categories:
  - authentication

kong_version_compatibility:
  enterprise_edition:
    compatible:
    - 1.5.x

params:
  name: application-registration
  service_id: true
  consumer_id: false
  route_id: false
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: no
  config:
    - name: auth_header_name
      required: false
      default: "`authorization`"
      description: |
        The name of the header that is supposed to carry the access token.
    - name: auto_approve
      required: false
      default: "`false`"
      value_in_examples:
      description: |
        If enabled, all new Service Contracts requests are automatically
        approved. Otherwise, Dev Portal admins must manually approve requests.
    - name: description
      required: false
      default:
      value_in_examples:
      description: |
        Description displayed in information about a Service in the Developer Portal.
    - name: display_name
      required: true
      default:
      value_in_examples:
      description: |
        Display name used for a Service in the Developer Portal.
    - name: enable_authorization_code
      required: false
      default: "`false`"
      value_in_examples:
      description: |
        An optional boolean value to enable the three-legged Authorization
        Code flow ([RFC 6742 Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)).
    - name: enable_client_credentials
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Client Credentials Grant
        flow ([RFC 6742 Section 4.4](https://tools.ietf.org/html/rfc6749#section-4.4)).
    - name: enable_implicit_grant
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Implicit Grant flow, which
        allows to provision a token as a result of the authorization
        process ([RFC 6742 Section 4.2](https://tools.ietf.org/html/rfc6749#section-4.2)).
    - name: enable_password_grant
      required: false
      default: "`false`"
      description: |
        An optional boolean value to enable the Resource Owner Password
        Credentials Grant flow ([RFC 6742 Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3)).
    - name: mandatory_scope
      required: true
      default: "`false`"
      value_in_examples:
      description: |
        An optional boolean value telling the plugin to require at least
        one scope to be authorized by the end user.
    - name: provision_key
      required: true
      default:
      value_in_examples:
      description: |
        The Provision Key is automatically generated on creation. No input
        is required. Used by the Resource Owner Password Credentials Grant
        (Password Grant) flow.
    - name: refresh_token_ttl
      required: true
      default: 1209600
      value_in_examples: 1209600
      description: |
        An optional integer value telling the plugin how many seconds a
        token/refresh token pair is valid for, and can be used to generate
        a new access token. Default value is two weeks. Set to `0` to
        keep the token/refresh token pair indefinitely valid.
    - name: scopes
      required: semi
      default:
      value_in_examples:
      description: |
        Describes an array of scope names that will be available to the
        end user.
    - name: token_expiration
      required: false
      default: 7200
      value_in_examples: 7200
      description: |
        An optional integer value telling the plugin how many seconds a token
        should last, after which the client will need to refresh the token.
        Set to `0` to disable the expiration.
  extra: |
    When configuring the plugin, at least one of the following OAuth2
    auth flows must be enabled:
    - Authorization Code
    - Client Credentials
    - Implicit Grant
    - Password Grant

---
