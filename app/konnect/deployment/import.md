---
title: Import Kong Gateway Entities into Konnect Cloud
no_version: true
---

You can attach any edition of self-managed {{site.base_gateway}} to
{{site.konnect_saas}} as a data plane, and use Konnect as your control plane.

Use [decK](/deck/) to import Kong Gateway entity configuration into a runtime
group in your {{site.konnect_short_name}} organization.

Afterward, you must manually move over:
* Dev Portal files, developer accounts, and applications
* Convert RBAC roles and permissions into {{site.konnect_short_name}} teams
* Certificates
* Custom plugins

You cannot import [unsupported plugins](/konnect/configure/servicehub/manage-plugins/#plugin-limitations).

## Prerequisites
* {{site.konnect_saas}} [account credentials](/konnect/getting-started/access-account/).
* [**Organization Admin**](/konnect/org-management/teams-and-roles) permissions.
* decK v1.12 or later [installed](/deck/latest/installation/).

## Import entity configuration

Use deck to import entity configurations into a runtime group.

1. Make sure that decK can connect to your {{site.konnect_short_name}} account:

    ```sh
    deck ping \
      --konnect-email {YOUR_EMAIL} \
      --konnect-password {YOUR_PASSWORD}
    ```

    You can also use decK with {{site.konnect_short_name}} more securely by storing
    your password in a file, then either calling it with
    `--konnect-password-file {FILENAME}.txt`, or adding it to your decK configuration
    under the `konnect-password` option along with your email:

    ```yaml
    konnect-password: {YOUR_PASSWORD}
    konnect-email: {YOUR_EMAIL}
    ```

    The following steps all use a `deck.yaml` file to store the
    {{site.konnect_short_name}} credentials instead of flags.

1. Export configuration from {{site.base_gateway}} with [`deck dump`](/deck/latest/reference/deck_dump):

    ```bash
    deck dump --output-file konnect.yaml
    ```

    This command outputs {{site.base_gateway}}'s object configuration into the
    specified file.

1. Preview the import with the [`deck diff`](/deck/latest/reference/deck_diff)
command, pointing to the runtime group that you want to target:

    ```sh
    deck diff \
      --state konnect.yaml \
      --konnect-runtime-group default
    ```

1. If you're satisfied with the preview, run [`deck sync`](/deck/latest/reference/deck_sync):

    ```sh
    deck sync \
      --state konnect.yaml \
      --konnect-runtime-group default
    ```

    If you don't specify the `--konnect-runtime-group` flag, decK targets the
    `default` runtime group. If you have more than one runtime group in your
    organization, we recommend always setting this flag to avoid accidentally
    pushing configuration to the wrong group.

1. Log in to your [{{site.konnect_saas}}](http://cloud.konghq.com/login) account.

1. From the left navigation menu, open **Runtimes**, then open the runtime group
you just updated.

1. Look through the configuration details of any imported entities to make sure
they were migrated successfully.

## Migrate data planes

You can keep any data plane nodes that are:
* Running {{site.base_gateway}} (not the open-source package)
* Are at least version 2.3 or higher

Turn any self-managed nodes into cloud data plane nodes by registering them
through the Runtime Manager and adjusting their configurations, or power down
the old instances and create new data plane nodes through {{site.konnect_saas}}.

1. Follow the [runtime setup guide](/konnect/runtime-manager/#kong-gateway) for
your preferred deployment type.

2. Once you have created or converted the data plane nodes, `kong stop` your
old Gateway runtimes, then shut them down.

3. If any of the old nodes have connected PostgreSQL or Cassandra instances,
you can shut them down now.

## Post-migration tasks

See the following docs to set up any additional things you may need:

* **Dev Portal files:** You can migrate API specs and markdown documents using the
{{site.konnect_saas}} GUI. See [Dev Portal Service Documentation](/konnect/dev-portal/service-documentation).

* **Dev Portal applications and developers:** If you have developers or
applications registered through the Portal, those developers need to create new
accounts in {{site.konnect_saas}} and register their applications in the new
location.
    * [Developer registration](/konnect/dev-portal/access-and-approval/dev-reg)
    * [Enable application registration](/konnect/dev-portal/applications/enable-app-reg):
    App registration in {{site.konnect_saas}} works through a different
    mechanism than in self-managed {{site.base_gateway}}. Enable app
    registration on each service that requires it.
    * [Publish Services to the Dev Portal](/konnect/dev-portal/publish):
    The Dev Portal is automatically enabled on a {{site.konnect_saas}} org
    (Plus or Enterprise tier). Publish your services to the Dev Portal.
* [**Prepare custom plugins for migration**](/konnect/configure/servicehub/manage-plugins/#custom-plugins):
Custom plugins are supported in {{site.konnect_saas}}, but with limitations. As
long as your plugins fit the criteria, or if you can adjust them to do so,
contact Kong Support to get the plugin manually added to your account.
* [**Review and set up teams and roles**](/konnect/org-management/teams-and-roles):
{{site.konnect_saas}} groups and roles don't map directly to
{{site.base_gateway}} teams and roles. Set up teams to mirror your
{{site.base_gateway}} groups, then invite users to your {{iste.konnect_saas}}
org and assign them to a team on invite.
