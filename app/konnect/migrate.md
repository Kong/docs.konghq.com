---
title: Migrate from Kong Gateway to Konnect Cloud
no_version: true
---

You can migrate any edition of self-managed {{site.base_gateway}} to
{{site.konnect_saas}}.

Use [decK](/deck/) to convert and migrate the configuration for most
{{site.base_gateway}} objects, as well as Dev Portal specs and documents.

Afterward, you must manually migrate:
* Dev Portal developer accounts and applications
* RBAC roles and permissions
* Certificates
* Custom plugins

You cannot migrate [unsupported plugins](/konnect/manage-plugins/#plugin-limitations).

## Prerequisites
* {{site.konnect_saas}} [account credentials](/konnect/access-account/).
* [**Organization Admin**](/konnect/org-management/users-and-roles) permissions.
* decK v1.7.0 or later [installed](/deck/latest/installation/).

## Migrate object configuration

Migrate object configurations with decK.

### Export and convert Kong Gateway object configuration

1. Export configuration from {{site.base_gateway}} with [`deck dump`](/deck/latest/reference/deck_dump):

    ```bash
    deck dump --output-file kong.yaml
    ```

    This command outputs {{site.base_gateway}}'s object configuration into the
    specified file.

2. Convert the file into {{site.konnect_saas}} format with [`deck convert`](/deck/latest/reference/deck_convert):

    ```bash
    deck convert \
      --from kong-gateway \
      --to konnect \
      --input-file kong.yaml \
      --output-file konnect.yaml
    ```

    This command uses the configuration you exported from
    {{site.base_gateway}} and transforms it into {{site.konnect_saas}}
    configuration.

3. Carefully look over the exported file. Note that not all elements may be
exported, such as certificates and incompatible plugins. decK does not print
a warning if this occurs.

### Import the configuration into Konnect Cloud

1. Preview the import with the [`deck konnect diff`](/deck/latest/reference/deck_konnect_diff) command:

    ```sh
    deck konnect diff \
      --konnect-email {YOUR_EMAIL} \
      --konnect-password {YOUR_PASSWORD} \
      --state konnect.yaml
    ```

    {:.note}
    > **Note:** You can also use decK with {{site.konnect_saas}} more securely
    by storing your password in a file, then either calling it with
    `--konnect-password-file pass.txt`, or adding it to your decK configuration
    under the `konnect-password` option. See the
    [`deck konnect`](/deck/latest/reference/deck_konnect) reference for more
    information about the flag.

2. If you're satisfied with the preview, run [`deck konnect sync`](/deck/latest/reference/deck_konnect_sync):

    ```sh
    deck konnect sync \
      --konnect-email {YOUR_EMAIL} \
      --konnect-password {YOUR_PASSWORD} \
      --state konnect.yaml
    ```

3. Log in to your [{{site.konnect_saas}}](http://konnect.konghq.com/login) account.

4. From the left navigation menu, select **Services** to open ServiceHub.

5. Look through your Service catalog to check that all of your Services and
related entities were migrated successfully.

6. From the left navigation menu, select **Shared Config**, and check that your
Consumers were migrated.

## Upload Dev Portal content

You can migrate specs and markdown documents using decK or the
{{site.konnect_saas}} GUI.

### Migrate specs and documents using the GUI

If you prefer to use the GUI, see [Dev Portal Service Documentation](/konnect/servicehub/dev-portal/service-documentation).

### Migrate specs and documents using decK

If you have any Dev Portal documents you want to associate with your services,
you can do so in the `konnect.yaml` configuration file.

Each Service can have one markdown description file associated with it, and
each Service version can have one spec in YAML or JSON format.

1. In the `konnect.yaml` file, create a `document` section in the
`service_package` you want to edit and include a path to the document:

    ```yaml
    service_packages:
    - name: MyService
      document:
        path: {PATH_TO_FILE}/description.md
        published: true
    ```

    {:.important}
    > You **must** set `published: true`, otherwise the file will not be
    uploaded to {{site.konnect_saas}}. This parameter **does not** control
    whether the Service itself is published to the Dev Portal.
    > <br><br>
    > The same principle applies to Service version specs.

2. To upload a spec, create a `document` section in the Service `version` and
include a path to the spec:

    ```yaml
    service_packages:
    - name: MyService
      document:
        path: {PATH_TO_FILE}/description.md
        published: true
      versions:
      - version: "1"
        document:
          path: {PATH_TO_FILE}/vitalsSpec.yaml
          published: true
      ```

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

* **Dev Portal applications and developers:** If you have developers or
applications registered through the Portal, those developers need to create new
accounts in {{site.konnect_saas}} and register their applications in the new
location.
    * [Developer registration](/konnect/dev-portal/access-and-approval/dev-reg)
    * [Enable application registration](/konnect/dev-portal/applications/enable-app-reg):
    App registration in {{site.konnect_saas}} works through a different
    mechanism than in self-managed {{site.base_gateway}}. Enable app
    registration on each service that requires it.
    * [Publish Services to the Dev Portal](/konnect/servicehub/dev-portal/publish):
    The Dev Portal is automatically enabled on a {{site.konnect_saas}} org
    (Plus or Enterprise tier). Publish your services to the Dev Portal.
* [**Prepare custom plugins for migration**](/konnect/manage-plugins/#custom-plugins):
Custom plugins are supported in {{site.konnect_saas}}, but with limitations. As
long as your plugins fit the criteria, or if you can adjust them to do so,
contact Kong Support to get the plugin manually added to your account.
* [**Review roles and permissions**](/konnect/org-management/users-and-roles/):
{{site.konnect_saas}} roles and permissions don't map directly to
{{site.base_gateway}} RBAC. You also can't create custom roles, or adjust
permissions on the existing roles. Instead, invite users to your
{{iste.konnect_saas}} org and assign one of the available roles to them on
invite.
