---
title: Architecture
---

In this guide you'll learn how your Kubernetes resources are synchronized against Konnect.

## Overview

{{site.kgo_product_name}} 1.4.0 introduced support for managing Konnect entities.
It is designed to allow users drive their {{site.konnect_short_name}} configuration through Kubernetes [CRDs][k8s_crds].

[k8s_crds]: https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/

{:.note}
> **Note:** Konnect entities management is an opt-in feature. You must
> enable it by setting `GATEWAY_OPERATOR_ENABLE_CONTROLLER_KONNECT` environment variable to `true`.

At a high level {{site.kgo_product_name}}, watches for changes in the Kubernetes cluster and synchronizes them against {{site.konnect_product_name}}.

Below diagram illustrates high level overview, how {{site.konnect_short_name}} configuration is synchronized from Kubernetes resources to {{site.konnect_short_name}}:

<!--vale off-->
{% mermaid %}
flowchart BT

    subgraph Kong Konnect
        direction LR

        KonnectAPI(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-width:32px; display:block; margin:0 auto;" class="no-image-expand"/>Konnect APIs)
    end

    subgraph Kubernetes cluster
        direction LR

        KGO(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-width:32px; display:block; margin:0 auto;" class="no-image-expand"/>Kong Gateway Operator)
        K8sAPIServer(<img src="/assets/images/icons/third-party/kubernetes-logo.png" style="max-width:32px; display:block; margin:0 auto;" class="no-image-expand"/> API server)
    end

    KGO -.-> |configuration synchronization| KonnectAPI
    K8sAPIServer -.-> |events| KGO
{% endmermaid %}
<!--vale on-->

## How it works

{{site.kgo_product_name}} watches for changes in the Kubernetes cluster and synchronizes them against {{site.konnect_short_name}}.

The synchronization is performed in a loop, where the operator reconciles the state of the cluster with the state of {{site.konnect_short_name}}.

The algorithm is as follows:

- When a Kubernetes resource is created:
  - The operator checks if it has references and whether they are valid, if not it assigns a failure condition to the resource.
  - If the resource has references and they are valid, the operator calls the Konnect API's create method.
    - If the creation was unsuccessful, the operator assigns a failure condition to the resource.
    - If the creation was successful, the operator assigns the resource's ID, OrgID, ServerURL and status conditions.
  - The operator enqueues the resource for update after the configured sync period passes.

- When a Kubernetes resource is updated:
  - The operator checks if the resource's spec, annotations or labels have changed.
  - If the spec, annotations or labels have changed:
    - The operator calls the Konnect API's update method.
      - If the update was unsuccessful, the operator assigns a failure condition to the resource.
      - If the update was successful, the operator waits for the configured sync period to pass.
  - If the spec, annotations or labels have not changed:
    - If sync period has not passed, the operator enqueues the resource for update.
    - If sync period has passed, the operator calls the Konnect API's update method.
      - If the update was unsuccessful, the operator assigns a failure condition to the resource.
      - If the update was successful, the operator enqueues the resource for update.

- When a Kubernetes resource is deleted:
  - The operator calls the Konnect API's delete method.
    - If the deletion was unsuccessful, the operator assigns a failure condition to the resource.
    - If the deletion was successful, the operator removes the resource from the cluster.

Below diagram illustrates the algorithm:

<!--vale off-->
{% mermaid %}
flowchart TB

classDef decision fill:#d0e1fb
classDef start fill:#545454,stroke:none,color:#fff

    k8sResourceCreated(Kubernetes resource created)
    k8sResourceUpdated(Kubernetes resource updated)
    rLoopStart[Operator reconciliation start]
    failure[Assign object's status conditions to indicate failure]
    resourceSpecChanged{Resource spec, annotations or labels changed?}
    waitForSync["Wait until sync period passes (default 1m)
    (Prevent API rate limiting)"]
    createSuccess[Assign object's ID, OrgID, ServerURL and status conditions]
    hasReferences{If object has references, are they all valid?}
    isAlreadyCreated{Object already created?}
    syncPeriodPassed[Sync period passed]
    updateKonnectEntity[Call Konnect API's update]
    wasUpdateSuccessful{Was update successful?}
    wasCreateSuccessful{Was create successful?}
    callCreate[Call Konnect API's create]

    k8sResourceCreated --> rLoopStart
    rLoopStart --> isAlreadyCreated
    isAlreadyCreated -->|Yes| waitForSync
    isAlreadyCreated -->|No| hasReferences
    hasReferences -->|Yes| callCreate
    hasReferences -->|No| failure
    callCreate --> wasCreateSuccessful
    wasCreateSuccessful -->|Yes| createSuccess
    wasCreateSuccessful -->|No| failure
    k8sResourceUpdated --> resourceSpecChanged
    resourceSpecChanged -->|Yes| updateKonnectEntity
    resourceSpecChanged -->|No| waitForSync
    createSuccess --> waitForSync
    waitForSync --> syncPeriodPassed
    syncPeriodPassed --> updateKonnectEntity
    updateKonnectEntity --> wasUpdateSuccessful
    wasUpdateSuccessful -->|Yes| waitForSync
    wasUpdateSuccessful -->|No| failure
    failure -->rLoopStart

class hasReferences,wasCreateSuccessful,wasUpdateSuccessful decision
class k8sResourceCreated,k8sResourceUpdated start
{% endmermaid %}
<!--vale on-->

## Kubernetes resources

Each Kubernetes resource that is mapped to a {{site.konnect_short_name}} entity has several fields that indicate its status in {{site.konnect_short_name}}.

### Konnect native objects

Objects that are native to {{site.konnect_short_name}} - they exist only in {{site.konnect_short_name}} - have the following `status` fields:

- `id` is the unique identifier of the Konnect entity as assigned by Konnect API. If it's unset (empty string), it means the Konnect entity hasn't been created yet.
- `serverURL` is the URL of the Konnect server in which the entity exists.
- `organizationID` is ID of Konnect Org that this entity has been created in.

You can observe these fields by running:

```bash
kubectl get <resource> <resource-name> -o yaml | yq '.status'
```

You should see the following output:

```yaml
conditions:
  ...
id: 7dcf6756-b2e7-4067-a19b-111111111111
organizationID: 5ca26716-02f7-4430-9117-111111111111
serverURL: https://eu.api.konghq.com
```

These objects are defined under `konnect.konghq.com` API group.

### Objects configuring {{site.base_gateway}}

Some objects can be used to configure {{site.base_gateway}} and are not native to {{site.konnect_short_name}}.
These are for example `KongConsumer`, `KongService`, `KongRoute` and `KongPlugin`. They are defined under `configuration.konghq.com` API group.

They can also be used in other contexts like for instance: be used for reconciliation with {{site.kic_product_name}}.

These objects have their {{site.konnect_short_name}} status related fields nested under `konnect` field. These fields are:

- `controlPlaneID` is the ID of the Control Plane this entity is associated with.
- `id` is the unique identifier of the Konnect entity as assigned by Konnect API. If it's unset (empty string), it means the Konnect entity hasn't been created yet.
- `serverURL` is the URL of the Konnect server in which the entity exists.
- `organizationID` is ID of Konnect Org that this entity has been created in.

You can observe these fields by running:

```bash
kubectl get <resource> <resource-name> -o yaml | yq '.status.konnect'
```

You should see the following output:

```yaml
controlPlaneID: 7dcf6756-b2e7-4067-a19b-111111111111
id: 7dcf6756-b2e7-4067-a19b-111111111111
organizationID: 5ca26716-02f7-4430-9117-111111111111
serverURL: https://eu.api.konghq.com
```
