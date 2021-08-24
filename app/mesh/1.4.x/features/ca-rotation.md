---
title: Certificate Authority rotation
---

## Overview

Kong Mesh lets us secure communication between applications by using mTLS.
In some situations, like migration from builtin CA to Vault CA, we may want to switch from one mTLS backend to another.
Kong Mesh lets us smoothly switch the backend without dropping any requests.

In Kong Mesh, we can define many backends in `mtls` section in the Mesh.

{% navtabs %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin
    - name: ca-2
      type: provided
      conf:
        cert:
          secret: ca-2-cert
        key:
          secret: ca-2-key
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
  - name: ca-1
    type: builtin
  - name: ca-2
    type: provided
    conf:
      cert:
        secret: ca-2-cert
      key:
        secret: ca-2-key
```
{% endnavtab %}
{% endnavtabs %}

Whenever we define many backends, the data plane proxy is configured to support certificates signed by CA of every defined backend.
However, data plane proxy always has at most one identity certificate signed by CA specified in `enabledBackend`.

## Usage

Let's assume we already enabled mTLS with `builtin` backend named `ca-1`

{% navtabs %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
      - name: ca-1
        type: builtin
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
  - name: ca-1
    type: builtin
```
{% endnavtab %}
{% endnavtabs %}

The following steps show how to rotate certificates to a new `provided` backend named `ca-2`.
Every step may take from a couple of seconds up to a couple of minutes depending on the number of data plane proxies in the mesh.
Kong Mesh provides validators so we won't execute the next step too soon.

{% navtabs %}
{% navtab Kubernetes %}
1.  Define a new backend in the list of backends.

    ```yaml
    apiVersion: kuma.io/v1alpha1
    kind: Mesh
    metadata:
      name: default
    spec:
      mtls:
        enabledBackend: ca-1
        backends:
        - name: ca-1
          type: builtin
        - name: ca-2
          type: provided
          conf:
            cert:
              secret: ca-2-cert
            key:
              secret: ca-2-key
    ```

    After a short while, all data plane proxies should support both CA from `ca-1` and `ca-2`.
    At this point, all data plane proxies still have identity certificates signed by `ca-1`.

2.  Change enabled backend to the new backend

    ```yaml
    apiVersion: kuma.io/v1alpha1
    kind: Mesh
    metadata:
      name: default
    spec:
      mtls:
        enabledBackend: ca-2
        backends:
        - name: ca-1
          type: builtin
        - name: ca-2
          type: provided
          conf:
            cert:
              secret: ca-2-cert
            key:
              secret: ca-2-key
    ```

    After a short while, all data plane proxies should receive identity certificates signed by `ca-2`.
    At this point, all data plane proxies still support CA for both `ca-1` and `ca-2`

3.  Remove the old backend

    ```yaml
    apiVersion: kuma.io/v1alpha1
    kind: Mesh
    metadata:
      name: default
    spec:
      mtls:
        enabledBackend: ca-2
        backends:
        - name: ca-2
          type: provided
          conf:
            cert:
              secret: ca-2-cert
            key:
              secret: ca-2-key
    ```

    After a short while, all data plane proxies should only support certificates signed by CA from `ca-2`.
{% endnavtab %}
{% navtab Universal %}
1.  Define a new backend in the list of backends.

    ```yaml
    type: Mesh
    name: default
    mtls:
      enabledBackend: ca-1
      backends:
      - name: ca-1
        type: builtin
      - name: ca-2
        type: provided
        conf:
          cert:
            secret: ca-2-cert
          key:
            secret: ca-2-key
    ```

    After a short while, all data plane proxies should support both CA from `ca-1` and `ca-2`.
    At this point, all data plane proxies still have identity certificates signed by `ca-1`.

2.  Change enabled backend to the new backend

    ```yaml
    type: Mesh
    name: default
    mtls:
      enabledBackend: ca-2
      backends:
      - name: ca-1
        type: builtin
      - name: ca-2
        type: provided
        conf:
          cert:
            secret: ca-2-cert
          key:
            secret: ca-2-key
    ```

    After a short while, all data plane proxies should receive identity certificates signed by `ca-2`.
    At this point, all data plane proxies still support CA for both `ca-1` and `ca-2`

3.  Remove the old backend

    ```yaml
    type: Mesh
    name: default
    mtls:
      enabledBackend: ca-2
      backends:
      - name: ca-2
        type: provided
        conf:
          cert:
            secret: ca-2-cert
          key:
            secret: ca-2-key
    ```

    After a short while, all data plane proxies should only support certificates signed by CA from `ca-2`.
{% endnavtab %}
{% endnavtabs %}