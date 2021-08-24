---
title: Certificate Authority rotation
---

## Overview

{{site.mesh_product_name}} lets you provide secure communication between applications with mTLS. You can change the mTLS backend with 
Certificate Authority rotation, to support a scenario such as migrating from the builtin CA to a Vault CA.

You can define many backends in the `mtls` section of the Mesh configuration. The data plane proxy is configured to support 
certificates signed by the CA of each defined backend. However, the proxy uses only one certificate, specified by the `enabledBackend` 
tag. For example:

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

## Usage

Start with mTLS enabled and a `builtin` backend named `ca-1`:

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

Then, follow the steps to rotate certificates to a new `provided` backend named `ca-2`.
Each step can take some time, but {{site.mesh_product_name}} provides validators to prevent you from 
continuing too soon.

{% navtabs %}
{% navtab Kubernetes %}
1.  Add a new backend to the list of backends:

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

    After the configuration finishes, all data plane proxies support CAs from `ca-1` and `ca-2`.
    But the data plane proxy certificates are still signed by the CA from `ca-1`.

2.  Change `enabledBackend` to the new backend:

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

    After the configuration finishes, the data plane proxy certicates are signed by the CA from `ca-2`.
    The data plane proxies still support CAs from `ca-1` and `ca-2`.

3.  Remove the old backend:

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

    After the configuration finishes, the data plane proxy certicates should still be signed by the CA from `ca-2`.
    But the data plane proxies no longer support the CA from `ca-1`.

{% endnavtab %}
{% navtab Universal %}
1.  Add a new backend to the list of backends:

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

    After the configuration finishes, all data plane proxies support CAs from `ca-1` and `ca-2`.
    But the data plane proxy certificates are still signed by the CA from `ca-1`.

2.  Change `enabledBackend` to the new backend:

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

    After the configuration finishes, the data plane proxy certicates are signed by the CA from `ca-2`.
    The data plane proxies still support CAs from `ca-1` and `ca-2`.

3.  Remove the old backend:

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

    After the configuration finishes, the data plane proxy certicates should still be signed by the CA from `ca-2`.
    But the data plane proxies no longer support the CA from `ca-1`.
{% endnavtab %}
{% endnavtabs %}