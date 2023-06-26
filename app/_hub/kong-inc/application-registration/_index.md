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
