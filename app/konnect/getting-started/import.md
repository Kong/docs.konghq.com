---
title: Import Kong Gateway Entities into Konnect
content_type: how-to
---

If you are an existing {{site.base_gateway}} user looking to use {{site.konnect_short_name}}
as your cloud-hosted control plane, you can use [decK](/deck/) to import your
{{site.base_gateway}} entity configuration into a control plane in your
{{site.konnect_short_name}} organization.

You can also use this method to migrate between {{site.konnect_short_name}} organizations.

Afterward, you must manually move over:
* Dev Portal files, developer accounts, and applications
* Application registrations
* Convert roles and permissions into {{site.konnect_short_name}} teams
* Certificates
* Custom plugins

You cannot import [unsupported plugins](/konnect/servicehub/plugins/#plugin-limitations).

## Prerequisites
* {{site.konnect_saas}} [account credentials](/konnect/getting-started/access-account/).
* decK v1.12 or later [installed](/deck/latest/installation/).

## Generate a Personal Access Token

To use decK to import entity configurations, we recommend that you use a personal access token (PAT).

{% include_cached /md/personal-access-token.md %}

## Import entity configuration

Use decK to import entity configurations into a control plane.

When you provide any {{site.konnect_short_name}} flags, decK targets the `cloud.konghq.com` environment by default.

1. Make sure that decK can connect to your {{site.konnect_short_name}} account:

    ```sh
    deck ping \
      --konnect-control-plane-name default \
      --konnect-token {YOUR_PERSONAL_ACCESS_TOKEN}
    ```

    If the connection is successful, the terminal displays the full name of the
    user associated with the account:

    ```sh
    Successfully Konnected to the Example-Name organization!
    ```

    You can also use decK with {{site.konnect_short_name}} more securely by storing
    your personal access token in a file, then either calling it with
    `--konnect-token-file /path/{FILENAME}.txt`, or adding it to your decK configuration
    file under the `konnect-token` option:

    ```yaml
    konnect-token: {YOUR_PERSONAL_ACCESS_TOKEN}
    ```

    The default location for this file is `$HOME/.deck.yaml`. You can target a
    different configuration file with the `--config /path/{FILENAME}.yaml` flag,
    if needed.

    The following steps all use a `.deck.yaml` file to store the
    {{site.konnect_short_name}} credentials instead of flags.

1. Run [`deck dump`](/deck/latest/reference/deck_dump/) to export configuration into a file:

    ```sh
    deck dump
    ```

    This command outputs {{site.base_gateway}}'s object configuration into
    `kong.yaml` by default. You can also set `--output-file /path/{FILENAME}.yaml`
    to set a custom filename or location.

1. Open the file. If you have any of the following in your configuration, remove it:

    * Any `_workspace` entries: There are no workspaces in {{site.konnect_short_name}}. For a similar
    concept, see [control planes](/konnect/gateway-manager/control-plane-groups/).

    * Configuration for the Portal App Registration plugin: App registration is
    [supported in {{site.konnect_short_name}}](/konnect/dev-portal/applications/application-overview/),
    but not through a plugin, and decK does not manage it.

    * Any other unsupported plugins:
        * OAuth2 Authentication
        * Apache OpenWhisk
        * Vault Auth
        * Key Authentication Encrypted

1. Preview the import with the [`deck diff`](/deck/latest/reference/deck_diff/)
command, pointing to the control plane that you want to target:

    ```sh
    deck diff --konnect-control-plane-name default
    ```

    If you're not using the default `kong.yaml` file, specify the filename and
    path with `--state /path/{FILENAME}.yaml`.

1. If you're satisfied with the preview, run [`deck sync`](/deck/latest/reference/deck_sync/):

    ```sh
    deck sync --konnect-control-plane-name default
    ```

    If you don't specify the `--konnect-control-plane-name` flag, decK targets the
    `default` control plane. If you have more than one control plane in your
    organization, we recommend always setting this flag to avoid accidentally
    pushing configuration to the wrong control plane.

1. Log in to your [{{site.konnect_saas}}](http://cloud.konghq.com/login) account.

1. From the left navigation menu, open **Gateway Manager**, then open the control plane
you just updated.

1. Look through the configuration details of any imported entities to make sure
they were migrated successfully.

## Migrate data planes

You can keep any data plane nodes that are:
* Running {{site.base_gateway}} (Enterprise, include _free_ mode)
* Are at least version 2.5 or higher

Turn any self-managed nodes into cloud data plane nodes by registering them
through the Gateway Manager and adjusting their configurations, or power down
the old nodes and create new data plane nodes through {{site.konnect_saas}}.

1. Follow the [data plane node setup guide](/konnect/gateway-manager/#data-plane-nodes) for
your preferred deployment type.

2. Once you have created or converted the data plane nodes, `kong stop` your
old Gateway data plane nodes, then shut them down.

3. If any of the old nodes have connected database instances,
you can shut them down now.

## Post-migration tasks

See the following docs to set up any additional things you may need:

* **Dev Portal files:** You can migrate API specs and markdown service descriptions
into API Products using the {{site.konnect_saas}} GUI. Each API product accepts
one markdown description file, and each API product version accepts one API spec.
See [Dev Portal Service Documentation](/konnect/api-products/service-documentation/).

* **Dev Portal applications and developers:** If you have developers or
applications registered through the Portal, those developers need to create new
accounts in {{site.konnect_saas}} and register their applications in the new
location.
    * [Create Dev Portal accounts](/konnect/dev-portal/dev-reg/)
    * [Enable application registration](/konnect/dev-portal/applications/enable-app-reg/):
    App registration in {{site.konnect_saas}} works through a different
    mechanism than in self-managed {{site.base_gateway}}. Enable app
    registration on each service that requires it.
    * [Publish services to the Dev Portal](/konnect/api-products/service-documentation/#publishing):
    The Dev Portal is automatically enabled on a {{site.konnect_saas}} org
    (Plus or Enterprise tier). Publish your services to the Dev Portal.
* [**Prepare custom plugins for migration**](/konnect/gateway-manager/plugins/#custom-plugins):
Custom plugins are supported in {{site.konnect_saas}}, but with limitations. As
long as your plugins fit the criteria, or if you can adjust them to do so,
contact Kong Support to get the plugin manually added to your account.
* [**Review and set up teams and roles**](/konnect/org-management/teams-and-roles/):
{{site.konnect_saas}} groups and roles don't map directly to
{{site.base_gateway}} teams and roles. Set up teams to mirror your
{{site.base_gateway}} groups, then invite users to your {{iste.konnect_saas}}
org and assign them to a team on invite.
