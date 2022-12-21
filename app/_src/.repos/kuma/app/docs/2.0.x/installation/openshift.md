---
title: OpenShift
---

To install and run {{site.mesh_product_name}} on OpenShift execute the following steps:

- [1. Download {{site.mesh_product_name}}](#1-download-kuma)
- [2. Run {{site.mesh_product_name}}](#2-run-kuma)
- [3. Use {{site.mesh_product_name}}](#3-use-kuma)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

### 1. Download {{site.mesh_product_name}}

{% include snippets/install_kumactl.md %}

### 2. Run {{site.mesh_product_name}}

We can install and run {{site.mesh_product_name}}:

{% tabs openshift-run useUrlFragment=false %}
{% tab openshift-run OpenShift 4.x %}

```sh
./kumactl install control-plane --cni-enabled | oc apply -f -
```

Starting from version 4.1 OpenShift utilizes `nftables` instead of `iptables`. So using init container for redirecting traffic to the proxy no longer works. Instead, we use the `--cni-enabled` flag to install the [`kuma-cni`](/docs/{{ page.version }}/networking/cni).
{% endtab %}

{% tab openshift-run OpenShift 3.11 %}

By default `MutatingAdmissionWebhook` and `ValidatingAdmissionWebhook` are disabled on OpenShift 3.11.
In order to make it work add the following `pluginConfig` into `/etc/origin/master/master-config.yaml` on the master node:

```yaml
admissionConfig:
  pluginConfig:
    MutatingAdmissionWebhook:
      configuration:
        apiVersion: apiserver.config.k8s.io/v1alpha1
        kubeConfigFile: /dev/null
        kind: WebhookAdmission
    ValidatingAdmissionWebhook:
      configuration:
        apiVersion: apiserver.config.k8s.io/v1alpha1
        kubeConfigFile: /dev/null
        kind: WebhookAdmission
```

After updating `master-config.yaml` restart the cluster and install `control-plane`:

```sh
./kumactl install control-plane | oc apply -f -
```

{% endtab %}
{% endtabs %}

This example will run {{site.mesh_product_name}} in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/introduction/deployments) like "multi-zone".

{% tip %}
It may take a while for OpenShift to start the {{site.mesh_product_name}} resources, you can check the status by executing:

```sh
oc get pod -n {{site.default_namespace}}
```

{% endtip %}

### 3. Use {{site.mesh_product_name}}

{{site.mesh_product_name}} (`kuma-cp`) will be installed in the newly created `{{site.default_namespace}}` namespace! Now that {{site.mesh_product_name}} has been installed, you can access the control-plane via either the GUI, `oc`, the HTTP API, or the CLI:

{% tabs openshift-use useUrlFragment=false %}
{% tab openshift-use GUI (Read-Only) %}

{{site.mesh_product_name}} ships with a **read-only** GUI that you can use to retrieve {{site.mesh_product_name}} resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access {{site.mesh_product_name}} we need to first port-forward the API service with:

```sh
oc port-forward svc/kuma-control-plane -n {{site.default_namespace}} 5681:5681
```

And then navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab openshift-use oc (Read & Write) %}

You can use {{site.mesh_product_name}} with `oc` to perform **read and write** operations on {{site.mesh_product_name}} resources. For example:

```sh
oc get meshes
# NAME          AGE
# default       1m
```

or you can enable mTLS on the `default` Mesh with:

```sh
echo "apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin" | oc apply -f -
```

{% endtab %}
{% tab openshift-use HTTP API (Read-Only) %}

{{site.mesh_product_name}} ships with a **read-only** HTTP API that you can use to retrieve {{site.mesh_product_name}} resources.

By default the HTTP API listens on port `5681`. To access {{site.mesh_product_name}} we need to first port-forward the API service with:

```sh
oc port-forward svc/kuma-control-plane -n {{site.default_namespace}} 5681:5681
```

And then you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab openshift-use kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on {{site.mesh_product_name}} resources. The `kumactl` binary is a client to the {{site.mesh_product_name}} HTTP API, you will need to first port-forward the API service with:

```sh
oc port-forward svc/kuma-control-plane -n {{site.default_namespace}} 5681:5681
```

and then run `kumactl`, for example:

```sh
kumactl get meshes
# NAME          mTLS      METRICS      LOGGING   TRACING
# default       off       off          off       off
```

You can configure `kumactl` to point to any zone `kuma-cp` instance by running:

```sh
kumactl config control-planes add --name=XYZ --address=http://{address-to-kuma}:5681
```

{% endtab %}
{% endtabs %}

You will notice that {{site.mesh_product_name}} automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

{% tip %}
{{site.mesh_product_name}} explicitly specifies UID for `kuma-dp` sidecar to avoid capturing traffic from `kuma-dp` itself. For that reason, `nonroot` [Security Context Constraint](https://docs.openshift.com/container-platform/latest/authentication/managing-security-context-constraints.html) has to be granted to the application namespace:

```sh
oc adm policy add-scc-to-group nonroot system:serviceaccounts:<app-namespace>
```

If namespace is not configured properly, we will see following error on the `Deployment` or `DeploymentConfig`

```
'pods "kuma-demo-backend-v0-cd6b68b54-" is forbidden: unable to validate against any security context constraint: [spec.containers[1].securityContext.securityContext.runAsUser: Invalid value: 5678: must be in the ranges: [1000540000, 1000549999]]'
```

{% endtip %}

### 4. Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}} on OpenShift 🚀.

In order to start using {{site.mesh_product_name}}, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes/) deployments.

{% tip %}
Before running {{site.mesh_product_name}} Demo in the Quickstart, remember to run the following command

```sh
oc adm policy add-scc-to-group anyuid system:serviceaccounts:kuma-demo
```

In case of {{site.mesh_product_name}} Demo, one of the component requires root access therefore we use `anyuid` instead of `nonroot` permission.
{% endtip %}
