---
title: Migrate configuration into composite runtime groups
content_type: how-to
badge: enterprise
---

There are a few situations in which you might want to migrate existing configuration into a composite runtime group.

* Migrate standard runtime group configuration into a composite group. In this scenario, you are migrating config from {{site.konnect_short_name}} to a different group in {{site.konnect_short_name}}.
* Migrate self-managed {{site.base_gateway}} workspace configuration into a composite group in {{site.konnect_short_name}}. In this scenario, you are migrating from self-managed to cloud managed.

A composite runtime group **can't be configured directly**. It compiles configuration from its member runtime groups.

Therefore, when migrating, you will need at least two new groups: a composite runtime group and a standard runtime group.

## Prerequisites

* **Runtime group admin** permissions
* decK v1.12 or later [installed](/deck/latest/installation/)
* You have a Konnect access token and you have [made sure that decK can connect to your account](/konnect/runtime-manager/declarative-config/)

## Prepare runtime groups for migration

1. Create a composite runtime group:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups \
        -H "Authorization: Bearer <your_KPAT>" \
        --data name=CRG \
        --data cluster_type=CLUSTER_TYPE_COMPOSITE
    ```

1. Create a new standard runtime group:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups \
        -H "Authorization: Bearer <your_KPAT>" \
        --data name=SRG1 \
        --data cluster_type=CLUSTER_TYPE_HYBRID
    ```

1. Add the new group to the composite runtime group as a member:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/runtime-groups/<composite-group-ID>/composite-memberships/add \
        -H "Authorization: Bearer <your_KPAT>" \
        --json '{"members": [{"id": "062e2f2c-0f42-4938-91b4-f73f399260f5"}]}'
    ```

    {:.note}
    > **Note**: When adding a standard group to a composite, make sure it has no connected 
    runtime instances.

## Scenario: Migrate runtime group configuration into a composite group

If you want to migrate a standard runtime group into a composite, Kong recommends the following path:

1. Create a composite runtime group.
1. Create a new standard runtime group and add as a member to the composite group.
1. Dump the configuration from the old standard runtime group.
1. Apply configuration to new standard runtime group that is a member of the composite runtime group.
1. Start new runtime instances in composite runtime group and test routes.
1. Decommission the old standard runtime group.

We recommend this workflow because it gives you the opportunity to review shared entities and avoid conflicts. 
It also decouples any team, dev portal, or identity permissions from the group. This way, you won't accidentally 
grant access to the wrong resources to a new group of users.

Assuming you already have a composite runtime group and a member runtime group, you can export configuration from the old group and apply it to the new one.

1. Export the configuration of the old runtime group via `deck dump`:

    ```sh
    deck dump \
        -o old-group.yaml \
        --konnect-token <your_KPAT> \
        --konnect-runtime-group-name old-group
    ```

1. Sync the configuration to the new group:

    ```sh
    deck sync \
        -s old-group.yaml \
        --konnect-token <your_KPAT> \
        --konnect-runtime-group-name SRG1
    ```

    Note that you can't sync the configuration to the composite group `CRG`. Composite runtime groups don't have their own configuration. They use combined configuration from all of their member runtime groups.


## Scenario: Migrate workspaces to composite runtime groups

Use decK to migrate a self-managed {{site.base_gateway}} workspace into a composite runtime group.

1. Run [`deck dump`](/deck/latest/reference/deck_dump/) to export workspace configuration into a file:

    ```sh
    deck dump --workspace ws1 -o ws1.yaml
    ```

1. Open the file. Remove the following:

    * Any `_workspace` entries: There are no workspaces in {{site.konnect_short_name}}. For a similar
    concept, see [runtime groups](/konnect/runtime-manager/runtime-groups/).

    * Configuration for the Portal App Registration plugin: App registration is
    [supported in {{site.konnect_short_name}}](/konnect/dev-portal/applications/application-overview/),
    but not through a plugin, and decK does not manage it.

    * Any other [unsupported plugins](/konnect/compatibility/#plugin-compatibility)

1. Preview the import with the [`deck diff`](/deck/latest/reference/deck_diff/)
command, pointing to the runtime group that you want to target:

    ```sh
    deck diff --konnect-runtime-group-name SRG1 -s ws1.yaml
    ```

1. If you're satisfied with the preview, run [`deck sync`](/deck/latest/reference/deck_sync/):

    ```sh
    deck sync --konnect-runtime-group-name SRG1 -s ws1.yaml
    ```

    If you don't specify the `--konnect-runtime-group-name` flag, decK targets the
    `default` runtime group. If you have more than one runtime group in your
    organization, we recommend always setting this flag to avoid accidentally
    pushing configuration to the wrong group.

1. Log in to your [{{site.konnect_saas}}](http://cloud.konghq.com/login) account.

1. From the left navigation menu, open **Runtime Manager**, then open the runtime group
you just updated.

1. Look through the configuration details of any imported entities to make sure
they were migrated successfully.