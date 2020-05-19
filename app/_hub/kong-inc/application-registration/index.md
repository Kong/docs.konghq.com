---
name: Portal Application Registration
publisher: Kong Inc.
version: 1.0.x

desc: Allow portal developers to register applications against services
description: |
  Applications allow registered developers on Kong Developer Portal to
  authenticate with OAuth against a Service on Kong. Admins can
  selectively admit access to Services using this
  [Application Registration](/enterprise/1.5.x/developer-portal/administration/application-registration) plugin.

  <div class="alert alert-red">WARNING: This functionality is released as a <a href="/enterprise/latest/introduction/key-concepts/#beta">BETA</a> feature and
  should not be deployed in a production environment.
  </div>

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
      required: true
      default: "`false`"
      value_in_examples: false
      description: |
        If enabled, all new Service Contracts requests are automatically
        approved. Otherwise, Dev Portal admins must manually approve requests.
    - name: description
      required: false
      default:
      value_in_examples:
      description: |
        Unique description displayed in information about a Service in the Developer Portal.
    - name: display_name
      required: true
      default:
      value_in_examples: <my_service_display_name>
      description: |
        Unique display name used for a Service in the Developer Portal.
    - name: enable_authorization_code
      required: true
      default: "`false`"
      value_in_examples:
      description: |
        An optional boolean value to enable the three-legged Authorization
        Code flow ([RFC 6742 Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)). At least one flow must be enabled for the plugin.
    - name: enable_client_credentials
      required: true
      default: "`false`"
      value_in_examples: true
      description: |
        An optional boolean value to enable the Client Credentials Grant
        flow ([RFC 6742 Section 4.4](https://tools.ietf.org/html/rfc6749#section-4.4)). At least one flow must be enabled for the plugin.
    - name: enable_implicit_grant
      required: true
      default: "`false`"
      description: |
        An optional boolean value to enable the Implicit Grant flow, which
        allows to provision a token as a result of the authorization
        process ([RFC 6742 Section 4.2](https://tools.ietf.org/html/rfc6749#section-4.2)). At least one flow must be enabled for the plugin.
    - name: enable_password_grant
      required: true
      default: "`false`"
      description: |
        An optional boolean value to enable the Resource Owner Password
        Credentials Grant flow ([RFC 6742 Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3)). At least one flow must be enabled for the plugin.
    - name: mandatory_scope
      required: true
      default: "`false`"
      value_in_examples: false
      description: |
        An optional boolean value telling the plugin to require at least
        one scope to be authorized by the end user. See [Set mandatory scopes](/hub/kong-inc/application-registration/#Set-mandatory-scopes).
    - name: provision_key
      required: false
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
        token/refresh token pair is valid for. The refresh token can be used to
        generate a new access token. Default value is 1209600 seconds (two
        weeks). Set to `0` to keep the token/refresh token pair indefinitely valid. See [Set tokens to never expire](/hub/kong-inc/application-registration/#Set-tokens-to-never-expire).
    - name: scopes
      required: semi
      default:
      value_in_examples:
      description: |
        A string array of scope names that will be available to the
        end user. See [Set mandatory scopes](/hub/kong-inc/application-registration/#Set-mandatory-scopes).
    - name: token_expiration
      required: true
      default: 7200
      value_in_examples: 7200
      description: |
        An optional integer value telling the plugin how many seconds an access
        token should last, after which the client will need to refresh the
        token. Default value is two hours. Set to `0` to disable the expiration.
        See [Set tokens to never expire](/hub/kong-inc/application-registration/#Set-tokens-to-never-expire).
  extra: |
    **Important:** When configuring the plugin, at least one of the following
     OAuth2 auth flows must be enabled:
    - Authorization Code
    - Client Credentials
    - Implicit Grant
    - Password Grant

---

## Examples

Replace `<DNSorIP>` with your host name or IP address, `{service}` with
your Service name, and `<my_service_display_name>` with the
`display_name` of your Service for all examples in this section.

### Enable the plugin with Client Credentials

Command:

```
curl -X POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.enable_client_credentials=true"
```

Result:

```
{
   "created_at":1589485602,
   "config":{
      "refresh_token_ttl":1209600,
      "auto_approve":false,
      "provision_key":"D7gc8R1vGD5lkod2wUrSRdpBPpte73kF",
      "mandatory_scope":false,
      "scopes":null,
      "enable_implicit_grant":false,
      "display_name":"my_service_display_name",
      "enable_client_credentials":true,
      "description":null,
      "enable_password_grant":false,
      "enable_authorization_code":false,
      "token_expiration":7200,
      "auth_header_name":"authorization"
   },
   "id":"7696f657-00f9-462e-9d63-96d27140d2f8",
   "service":{
      "id":"c2a45fd2-e753-46a0-955d-2ac7b4a18ce0"
   },
   "name":"application-registration",
   "protocols":[
      "grpc",
      "grpcs",
      "http",
      "https"
   ],
   "enabled":true,
   "run_on":null,
   "consumer":null,
   "route":null,
   "tags":null
}
```

Note that the `provision_key` was autogenerated.

### Enable the plugin with Authorization Code

```
curl -X POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.enable_authorization_code=true"
```

### Enable the plugin with Password Grant

```
curl -X POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.enable_password_grant=true"
```

### Enable the plugin with Implicit Grant

```
curl -X POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.enable_implicit_grant=true"
```

### Set tokens to never expire

```
curl -X  POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.enable_authorization_code=true"
    --data "config.refresh_token_ttl=0" \
    --data "config.token_expiration=0"
```

### Set mandatory scopes

Replace `<read>` and `<write>` with the name of your scopes.

```
curl -X  POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.enable_authorization_code=true" \
    --data "config.mandatory_scope=true" \
    --data "config.scopes[]=<read>"
```

Multiple scopes:

```
  ...
    --data "config.scopes[]=<read> <write>"
```
The scopes string array is space delimited.

### Enable automatic registration approval

Update your current configuration by running a PATCH command. Replace `{plugin_id}` with the `id` of your plugin.

```
curl -X PATCH http://<DNSorIP>:8001/plugins/{plugin_id} \
  --data "config.auto_approve=true"
```
