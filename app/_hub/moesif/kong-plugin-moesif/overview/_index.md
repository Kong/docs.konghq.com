---
nav_title: Overview
---

This plugin allows you to understand [customer API usage](https://www.moesif.com/features/api-analytics?utm_medium=docs&utm_campaign=partners&utm_source=kong&language=kong-api-gateway) and monetize your APIs with [usage-based billing](https://www.moesif.com/solutions/metered-api-billing?utm_medium=docs&utm_campaign=partners&utm_source=kong&language=kong-api-gateway)
by logging API traffic to [Moesif API Monetization and Analytics](https://www.moesif.com?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong). Moesif enables you to:

* [Analyze customer API usage](https://www.moesif.com/features/api-analytics?utm_medium=docs&utm_campaign=partners&utm_source=kong)
* [Get alerted of issues](https://www.moesif.com/features/api-monitoring?utm_medium=docs&utm_campaign=partners&utm_source=kong)
* [Monetize APIs with usage-based billing](https://www.moesif.com/solutions/metered-api-billing?utm_medium=docs&utm_campaign=partners&utm_source=kong)
* [Enforce quotas and contract terms](https://www.moesif.com/features/api-governance-rules?utm_medium=docs&utm_campaign=partners&utm_source=kong)
* [Guide users](https://www.moesif.com/features/user-behavioral-emails?utm_medium=docs&utm_campaign=partners&utm_source=kong)

This plugin supports automatic analysis of high-volume REST, GraphQL, XML/SOAP, and other APIs without adding latency.

## How it works

This plugin logs API traffic to
[Moesif API Analytics and Monetization](https://www.moesif.com/?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong). 
It batches data and leverages an [asynchronous design](https://www.moesif.com/enterprise/api-analytics-infrastructure?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong) to ensure no latency is added to your API.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif)

Moesif natively supports REST, GraphQL, Web3, SOAP, JSON-RPC, and more. Moesif is SOC 2 Type 2 compliant and has features like [client-side encryption](https://www.moesif.com/enterprise/security-compliance?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong) so data stays private to your organization.

## How to install

> If you are using Kong's [Kubernetes ingress controller](https://github.com/Kong/kubernetes-ingress-controller), the installation is slightly different. Review the [docs for the {{site.kic_product_name}}](https://www.moesif.com/docs/server-integration/kong-ingress-controller/?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong).

The `.rock` file is a self-contained package that can be installed locally or from a remote server.

If the LuaRocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

### Install the Moesif plugin

```shell
luarocks install --server=http://luarocks.org/manifests/moesif kong-plugin-moesif
```

### Update your loaded plugins list
In your `kong.conf`, append `moesif` to the `plugins` field (or `custom_plugins` if old version of Kong). Make sure the field is not commented out.

```yaml
plugins = bundled,moesif         # Comma-separated list of plugins this node
                                 # should load. By default, only plugins
                                 # bundled in official distributions are
                                 # loaded via the `bundled` keyword.
```

If you don't have a `kong.conf`, create one from the default using the following command: 
`cp /etc/kong/kong.conf.default /etc/kong/kong.conf`

### Restart Kong

After LuaRocks is installed, restart Kong before enabling the plugin

```shell
kong restart
```

### Enable the Moesif plugin

```shell
curl -i -X POST --url http://localhost:8001/plugins/ --data "name=moesif" --data "config.application_id=YOUR_APPLICATION_ID";
```

### Restart Kong again

If you don't see any logs in Moesif, you may need to restart Kong again. 

```shell
kong restart
```

## Updating plugin configuration

[View upgrade steps in the Moesif docs](https://www.moesif.com/docs/server-integration/kong-api-gateway/#updating-plugin-configuration?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong). 

## Identifying users

This plugin automatically identifies API users so you can associate a user's API traffic to user data and other app analytics.
The default algorithm covers most authorization designs and works as follows, in this order of precedence:

1. If the `config.user_id_header` option is set, read the value from the specified HTTP header key `config.user_id_header`.
2. Else, if Kong has a value defined for `x-consumer-custom-id`, `x-consumer-username`, or `x-consumer-id` (in that order), use that value.
3. Else, if an authorization token is present in `config.authorization_header_name`, parse the user ID from the token as follows:
   * If header contains `Bearer`, base64 decode the string and use the value defined by `config.authorization_user_id_field` (default value is `sub`).
   * If header contains `Basic`, base64 decode the string and use the username portion (before the `:` character).

For advanced configurations, you can define a custom header containing the user id via `config.user_id_header` or override the options `config.authorization_header_name` and `config.authorization_user_id_field`.

## Identifying companies

You can associate API users to companies for tracking account-level usage similar to user-level usage. This can be done in one of the following ways, by order of precedence:
1. Define `config.company_id_header`. Moesif will use the value present in that header. 
2. Use the Moesif [update user API](https://www.moesif.com/docs/api#update-a-user) to set a `company_id` for a user. Moesif will associate the API calls automatically.
3. Else if an authorization token is present in `config.authorization_header_name`, parse the company ID from the token as follows:
   * If header contains `Bearer`, base64 decode the string and use the value defined by `config.authorization_company_id_field` (default value is `null`).

[More info on identifying customers](https://www.moesif.com/docs/getting-started/identify-customers/?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong)

## Troubleshooting

[View troubleshooting Moesif docs](https://www.moesif.com/docs/server-integration/kong-api-gateway/#troubleshooting?language=kong-api-gateway&utm_medium=docs&utm_campaign=partners&utm_source=kong) for troubleshooting steps. 
