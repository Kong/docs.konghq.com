---
name: Portal Application Registration
publisher: Kong Inc.
version: 2.0.x

desc: Allow portal developers to register applications against Services
description: |
  Applications allow registered developers on Kong Developer Portal to
  authenticate against a Gateway Service. Dev Portal admins can
  selectively admit access to Services using the
  [Application Registration](/enterprise/latest/developer-portal/administration/application-registration/enable-application-registration) plugin.

  The Application Registration plugin is used in tandem with supported Kong Gateway authorization
  plugins, depending on your configured Dev
  Portal authorization provider. Either Kong Gateway (`kong-oauth2`) or a third-party OAuth provider
  (`external-oauth2`) can be the system of record (SoR) for application credentials. For more
  information, see
  [Configure an Authorization Provider Strategy](/enterprise/latest/developer-portal/administration/application-registration/auth-provider-strategy).

  To learn how to set up key authentication, see [Enable Key Authentication for Application Registration](/enterprise/latest/developer-portal/administration/application-registration/enable-key-auth-plugin/). 

  Supported authorization plugins for use with application registration:

  | Kong Gateway Plugin | Portal authorization strategy                                 |
  |:------|:--------------------------------------------------------------------|
  | [OAuth2](/hub/kong-inc/oauth2) | `kong-oauth2` |
  | [Key Auth](/hub/kong-inc/key-auth/)| `kong-oauth2` |
  | [OIDC](/hub/kong-inc/openid-connect)| `external-oauth2` |

  If you plan to use the external OAuth option with OIDC, review the
  [supported OAuth workflows](/enterprise/latest/developer-portal/administration/application-registration/3rd-party-oauth).

enterprise: true
plus: true
type: plugin
categories:
  - authentication

kong_version_compatibility:
  enterprise_edition:
    compatible:
    - 2.4.x
    - 2.3.x
    - 2.2.x
    - 2.1.x

params:
  name: application-registration
  service_id: true
  consumer_id: false
  route_id: false
  konnect_examples: false
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: no
  config:
    - name: auto_approve
      required: true
      default: "`false`"
      value_in_examples: false
      datatype: boolean
      description: |
        If enabled, all new Service Contracts requests are automatically
        approved. See [Enable automatic registration approval](#enable-automatic-registration-approval). Otherwise, Dev Portal admins must manually approve requests.
    - name: description
      required: false
      default:
      value_in_examples: <my_service_description>
      datatype: string
      description: |
        Unique description displayed in information about a Service in the Developer Portal.
    - name: display_name
      required: true
      default:
      value_in_examples: <my_service_display_name>
      datatype: string
      description: |
        Unique display name used for a Service in the Developer Portal.
    - name: show_issuer
      required: true
      default: "`false`"
      value_in_examples: false
      datatype: boolean
      description: |
        Displays the **Issuer URL** in the **Service Details** dialog.
---

## Examples

Replace `<DNSorIP>` with your host name or IP address, `{service}` with
your Service name, and `<my_service_display_name>` with the
`display_name` of your Service for examples in this section.

### Enable automatic registration approval

Enable `auto_approve` so that application registration requests are
automatically approved.

```
curl -X POST http://<DNSorIP>:8001/services/{service} \
    --data "name=application-registration"  \
    --data "config.display_name=<my_service_display_name>" \
    --data "config.auto_approve=true
```

Update your current configuration by running a PATCH command. Replace `{plugin_id}` with the `id` of your plugin.

```
curl -X PATCH http://<DNSorIP>:8001/plugins/{plugin_id} \
  --data "config.auto_approve=true"
```
### Enable show issuer URL

Enable `show_issuer` to expose the **Issuer URL** in the **Service Details** dialog.

**Note:** Exposing the [Issuer URL](/enterprise/latest/developer-portal/administration/application-registration/enable-application-registration#show-url-issuer) is essential
for the
[Authorization Code Flow](/enterprise/latest/developer-portal/administration/application-registration/3rd-party-oauth/#ac-flow) configured for third-party identity providers.

Update your current configuration by running a PATCH command. Replace `{plugin_id}` with the `id` of your plugin.

```
curl -X PATCH http://<DNSorIP>:8001/plugins/{plugin_id} \
  --data "config.show_issuer=true"
```
