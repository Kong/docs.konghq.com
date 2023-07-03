Applications allow registered developers on Kong Developer Portal to
authenticate against a Gateway service. Dev Portal admins can
selectively admit access to services using the
Application Registration plugin.

{:.note}
> **Note**: This plugin is for application registration in _self-managed_ 
> {{site.base_gateway}} instances.
> <br>
> <br>
> In {{site.konnect_short_name}}, the functionality is built in, so you 
> don't need this plugin. See the following documentation:
* [Learn about app registration in {{site.konnect_short_name}}](/konnect/dev-portal/applications/application-overview/)
* [Enable app registration](/konnect/dev-portal/applications/enable-app-reg/)

The Application Registration plugin is used in tandem with supported {{site.base_gateway}} authorization
plugins, depending on your configured Dev
Portal authorization provider. Either {{site.base_gateway}} (`kong-oauth2`) or a third-party OAuth provider
(`external-oauth2`) can be the system of record (SoR) for application credentials. For more
information, see
[Configure an Authorization Provider Strategy](/gateway/latest/kong-enterprise/dev-portal/applications/auth-provider-strategy/).

To learn how to set up key authentication, see [Enable Key Authentication for Application Registration](/gateway/latest/kong-enterprise/dev-portal/applications/enable-key-auth-plugin/).

Supported authorization plugins for use with application registration:

| {{site.base_gateway}} Plugin | Portal authorization strategy |
|:------|:-----------------------------------------------------|
| [OAuth2](/hub/kong-inc/oauth2/) | `kong-oauth2` |
| [Key Auth](/hub/kong-inc/key-auth/)| `kong-oauth2` |
| [OIDC](/hub/kong-inc/openid-connect/)| `external-oauth2` |

If you plan to use the external OAuth option with OIDC, review the
[supported OAuth workflows](/gateway/latest/kong-enterprise/dev-portal/authentication/3rd-party-oauth/).

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

**Note:** Exposing the [Issuer URL](/gateway/latest/kong-enterprise/dev-portal/applications/enable-application-registration#show-url-issuer) is essential
for the
[Authorization Code Flow](/gateway/latest/kong-enterprise/dev-portal/authentication/3rd-party-oauth/#ac-flow) configured for third-party identity providers.

Update your current configuration by running a PATCH command. Replace `{plugin_id}` with the `id` of your plugin.

```
curl -X PATCH http://<DNSorIP>:8001/plugins/{plugin_id} \
  --data "config.show_issuer=true"
```
