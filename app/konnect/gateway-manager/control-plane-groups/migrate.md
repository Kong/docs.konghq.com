---
title: Migrate configuration into control plane groups
content_type: how-to
badge: enterprise
---

There are a few situations in which you might want to migrate existing configuration into a control plane group.

* Migrate standard control plane configuration into a control plane group. In this scenario, you are migrating config from {{site.konnect_short_name}} to a different control plane in {{site.konnect_short_name}}.
* Migrate self-managed {{site.base_gateway}} workspace configuration into a control plane group in {{site.konnect_short_name}}. In this scenario, you are migrating from self-managed to cloud managed.

A control plane group **can't be configured directly**. It compiles configuration from its member control planes.

Therefore, when migrating, you will need at least two new groups: a control plane group and a standard control plane.

## Prerequisites

* **Control plane admin** permissions
* decK v1.40.0 or later [installed](/deck/latest/installation/)
* You have a Konnect access token and you have [made sure that decK can connect to your account](/konnect/gateway-manager/declarative-config/)

## Prepare control planes for migration

1. Create a control plane group:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/control-planes \
        -H "Authorization: Bearer <your_KPAT>" \
        --data name=CPG \
        --data cluster_type=CLUSTER_TYPE_CONTROL_PLANE_GROUP
    ```

1. Create a new standard control plane:

    ```sh
    curl -i -X POST https://<region>.api.konghq.com/v2/control-planes \
        -H "Authorization: Bearer <your_KPAT>" \
        --data name=CP1 \
        --data cluster_type=CLUSTER_TYPE_HYBRID
    ```

1. Add the new control plane to the group as a member:

    ```sh
    curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/group-memberships/add \
        -H "Authorization: Bearer <your_KPAT>" \
        --json '{"members": [{"id": "062e2f2c-0f42-4938-91b4-f73f399260f5"}]}'
    ```

    {:.note}
    > **Note**: When adding a standard control plane to a group, make sure it has no connected 
    data plane nodes.

## Scenario: Migrate a control plane configuration into a control plane group

If you want to migrate a standard control plane into a group, Kong recommends the following path:

1. Create a control plane group.
1. Create a new standard control plane and add as a member to the control plane group.
1. Dump the configuration from the old standard control plane.
1. Apply configuration to new standard control plane that is a member of the control plane group.
1. Start new data plane nodes in control plane group and test routes.
1. Decommission the old standard control plane.

We recommend this workflow because it gives you the opportunity to review shared entities and avoid conflicts. 
It also decouples any team, dev portal, or identity permissions from the standard control plane. This way, you won't accidentally 
grant access to the wrong resources to a new group of users.

Assuming you already have a control plane group and a member control plane, you can export the configuration from the old control plane and apply it to the new one.

1. Export the configuration of the old control plane via `deck gateway dump`:

    ```sh
    deck gateway dump \
        -o old-group.yaml \
        --konnect-token <your_KPAT> \
        --konnect-control-plane-name old-group
    ```

1. Sync the configuration to the new group:

    ```sh
    deck gateway sync old-group.yaml \
        --konnect-token <your_KPAT> \
        --konnect-control-plane-name CP1
    ```

    Note that you can't sync the configuration to the control plane group `CPG`. 
    Control plane groups don't have their own configuration. 
    They inherit combined configuration from all of their member control planes.


## Scenario: Migrate workspaces to control plane groups

Use decK to migrate a self-managed {{site.base_gateway}} workspace into a control plane group.

1. Run [`deck gateway dump`](/deck/latest/reference/deck_gateway_dump/) to export workspace configuration into a file:

    ```sh
    deck gateway dump --workspace ws1 -o ws1.yaml
    ```

1. Open the file. Remove the following:

    * Any `_workspace` entries: There are no workspaces in {{site.konnect_short_name}}. For a similar
    concept, see [control planes](/konnect/gateway-manager/control-plane-groups/).

    * Configuration for the Portal App Registration plugin: App registration is
    [supported in {{site.konnect_short_name}}](/konnect/dev-portal/applications/application-overview/),
    but not through a plugin, and decK does not manage it.

    * Any other [unsupported plugins](/konnect/compatibility/#plugin-compatibility)

1. Preview the import with the [`deck gateway diff`](/deck/latest/reference/deck_gateway_diff/)
command, pointing to the control plane that you want to target:

    ```sh
    deck gateway diff ws1.yaml --konnect-control-plane-name CP1
    ```

1. If you're satisfied with the preview, run [`deck gateway sync`](/deck/latest/reference/deck_gateway_sync/):

    ```sh
    deck gateway sync ws1.yaml --konnect-control-plane-name CP1
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
