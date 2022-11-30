---
title: Set Up and Use a Vault in Konnect
content_type: how-to
---


The following example shows you how to replace certificates used in {{site.base_gateway}}
runtime instances with a reference. You can do the same thing with any [supported fields](/gateway/latest/kong-enterprise/secrets-management/). This is the most basic form of secrets management. 


## Set up a vault

First, define your environment variables.

Open the **Vaults** page in {{site.konnect_short_name}}:
1. From the navigation menu, open {% konnect_icon runtimes %} **Runtime Manager**.
1. Select a runtime group.
1. From the expanded runtime group menu, open **Vaults**.

Set up a new vault. For this example, we're going to use the environment variable vault. 
1. Click **Add vault**.
1. Choose a vault type. 
1. Enter an environment variable prefix. This will be the prefix that the vault
uses to recognize relevant values on the data plane.

    For this example, you can use `MY_SECRET`.

1. Set a prefix that you want to use in references.

    For this example, use `my-secret`.

1. Optionally, add a description for the vault, and tag it.

    Setting tags is optional, but recommended. If you want to manage
    your vault configuration declaratively, tagging your vaults and managing subsets of configuration
    with tags lets you protect your vaults from accidental change or deletion.
    See the [declarative configuration guide for vaults](/deck/latest/guides/vaults/#best-practices)
    for more information and best practices.

1. Save the vault configuration.

## Define a reference

Now that you have your environment variables set up, you can define references for them.
This next step has to be configured on the runtime instance.

For each runtime instance that needs to use this vault,
define an environment variable key and assign a secret to it. 

```bash
export MY_SECRET_CERT="<cert data>" \
export MY_SECRET_KEY="<key data>"
```

Restart the runtime instance to load the values.

Next, set up references to these environment variables in URL format so {{site.base_gateway}} can recognize these secrets.

In this case, the references would look like this:

```bash
{vault://env/my-secret-cert}
{vault://env/my-secret-key}
```


* `vault` is a scheme that indicates that the value is a secret.
* `env` defines the backend because you're storing the secret in an [environment variable](/gateway/latest/kong-enterprise/secrets-management/backends/env).
* `my-secret-key` and `my-secret-cert` correspond to the previously defined environment variables.


## Use the reference in configuration

Now, you can reference the secrets in proxy configuration.

Set up a cert and key using these references:
1. From your runtime group side menu, open **Certificates**.
1. Click **Add certificate**.
1. In the **Cert** field, paste `{vault://env/my-secret-cert}`.
1. In the **Key** field, paste `{vault://env/my-secret-key}`.
1. Save to see your certificate added to the list.

The {{site.konnect_short_name}} control plane can now access the certificates
on the runtime instances using the references you provided.

You can also store secrets in a secure vault backend.
For a list of supported vault backend implementations, see the
[Backends Overview](https://github.com/gateway/latest/kong-enterprise/secrets-management/backends).
