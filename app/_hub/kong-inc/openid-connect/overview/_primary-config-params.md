---
title: Important config parameters
nav_title: Important config parameters
---

This plugin includes many configuration parameters that allow finely grained customization.
The following steps will help you get started setting up the plugin:

1. Configure: `config.issuer`.

    This parameter tells the plugin where to find discovery information, and it is
    the only required parameter. You should set the value `realm` or `iss` on this
    parameter if you don't have a discovery endpoint.

    {:.note}
    > **Note**: This does not have
    to match the URL of the `iss` claim in the access tokens being validated. To set
    URLs supported in the `iss` claim, use `config.issuers_allowed`.

2. Decide what authentication grants to use with this plugin and configure
    the `config.auth_methods` field accordingly.

    In order to restrict the scope of potential attacks, the parameter should only 
    contain the grants that you want to use. 

3. In many cases, you also need to specify `config.client_id`, and if your identity provider
    requires authentication, such as on a token endpoint, you will need to specify the client
    authentication credentials too, for example `config.client_secret`.

4. If you are using a public identity provider, such as Google, you should limit
    the audience with `config.audience_required` to contain only your `config.client_id`.
    You may also need to adjust `config.audience_claim` in case your identity provider
    uses a non-standard claim (other than `aud` as specified in JWT standard). This is
    important because some identity providers, such as Google, share public keys
    with different clients.

5. If you are using Kong in DB-less mode with a declarative configuration and 
    session cookie authentication, you should set `config.session_secret`.
    Leaving this parameter unset will result in every Nginx worker across your
    nodes encrypting and signing the cookies with their own secrets.

In summary, start with the following parameters:

1. `config.issuer`
2. `config.auth_methods`
3. `config.client_id` (and in many cases the client authentication credentials)
4. `config.audience_required` (if using a public identity provider)
5. `config.session_secret` (if using Kong in DB-less mode)

Then, further customize the plugin configuration based on the [flow or grant](/hub/kong-inc/openid-connect/#how-to-guides-and-demos)
that you want to use.

For all available configuration parameters, see the 
[OpenID Connect configuration reference](/hub/kong-inc/openid-connect/configuration/).