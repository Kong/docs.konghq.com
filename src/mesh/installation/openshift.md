---
title: Kong Mesh with OpenShift
---

To install and run {{site.mesh_product_name}} on OpenShift:

1. [Download {{site.mesh_product_name}}](#1-download-kong-mesh)
1. [Run {{site.mesh_product_name}}](#2-run-kong-mesh)
1. [Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here
and continue your {{site.mesh_product_name}} journey.

## Prerequisites

You have a license for {{site.mesh_product_name}}.

## 1. Download {{site.mesh_product_name}}

To run {{site.mesh_product_name}} on OpenShift, you need to download a
compatible version of {{site.mesh_product_name}} for the machine from which
you will be executing the commands.

{% navtabs %}
{% navtab Script %}

You can run the following script to automatically detect the operating system
and download {{site.mesh_product_name}}:

```sh
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```

{% endnavtab %}
{% navtab Manually %}

You can also download the distribution manually. Download a distribution for
the **client host** from where you will be executing the commands to access
Kubernetes:

* [CentOS]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.kong_latest.version}}-centos-amd64.tar.gz)
* [Red Hat]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.kong_latest.version}}-rhel-amd64.tar.gz)
* [Debian]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.kong_latest.version}}-debian-amd64.tar.gz)
* [Ubuntu]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.kong_latest.version}}-ubuntu-amd64.tar.gz)
* [macOS]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.kong_latest.version}}-darwin-amd64.tar.gz)

Then, extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```

{% endnavtab %}
{% endnavtabs %}


## 2. Run {{site.mesh_product_name}}

Navigate to the `bin` folder:

```sh
$ cd kong-mesh-{{page.kong_latest.version}}/bin
```

We suggest adding the `kumactl` executable to your `PATH` so that it's always
available in every working directory. Alternatively, you can also create a link
in `/usr/local/bin/` by executing:

```sh
$ ln -s ./kumactl /usr/local/bin/kumactl
```

Then, run the control plane on OpenShift with:

{% navtabs %}
{% navtab OpenShift 4.x %}

```sh
kumactl install control-plane --cni-enabled --license-path=/path/to/license.json | oc apply -f -
```

Starting from version 4.1, OpenShift uses `nftables` instead of `iptables`. So,
using init container for redirecting traffic to the proxy no longer works.
Instead, we use `kuma-cni`, which can be installed with the `--cni-enabled` flag.

{% endnavtab %}
{% navtab OpenShift 3.11 %}

By default, `MutatingAdmissionWebhook` and `ValidatingAdmissionWebhook` are
disabled on OpenShift 3.11.

To make them work, add the following `pluginConfig` into
`/etc/origin/master/master-config.yaml` on the master node:

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

After updating `master-config.yaml`, restart the cluster and install
`control-plane`:

```sh
$ ./kumactl install control-plane --license-path=/path/to/license.json | oc apply -f -
```

{% endnavtab %}
{% endnavtabs %}

Where `/path/to/license.json` is the path to a valid {{site.mesh_product_name}}
license file on the file system.

This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
deployment, but there are more advanced [deployment modes](https://kuma.io/docs/latest/introduction/deployments/)
like _multi-zone_.

It may take a while for OpenShift to start the
{{site.mesh_product_name}} resources. You can check the status by running:

```sh
$ oc get pod -n kong-mesh-system
```

## 3. Verify the Installation

Now you can access the control plane with the GUI, `oc`, the HTTP API, or the CLI:

{% navtabs %}
{% navtab GUI (Read-Only) %}
{{site.mesh_product_name}} ships with a **read-only** GUI that you can use to
retrieve {{site.mesh_product_name}} resources. By default, the GUI listens on
the API port `5681` and defaults to `:5681/gui`.

To access {{site.mesh_product_name}}, port-forward the API service with:

```sh
$ oc port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681:5681
```

Navigate to `127.0.0.1:5681/gui` to see the GUI.

{% endnavtab %}
{% navtab oc (Read & Write) %}
You can use {{site.mesh_product_name}} with `oc` to perform
**read and write** operations on {{site.mesh_product_name}} resources. For
example:

```sh
$ oc get meshes

NAME          AGE
default       1m
```

Or, you can enable mTLS on the `default` Mesh with:

```sh
$ echo "apiVersion: kuma.io/v1alpha1
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

{% endnavtab %}
{% navtab HTTP API (Read-Only) %}

{{site.mesh_product_name}} ships with a **read-only** HTTP API that you use
to retrieve {{site.mesh_product_name}} resources. By default,
the HTTP API listens on port `5681`.

To access {{site.mesh_product_name}}, port-forward the API service with:

```sh
$ oc port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681:5681
```

Now you can navigate to `127.0.0.1:5681` to see the HTTP API.

{% endnavtab %}
{% navtab kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on
{{site.mesh_product_name}} resources. The `kumactl` binary is a client to
the {{site.mesh_product_name}} HTTP API. To use it, first port-forward the API
service with:

```sh
$ oc port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681:5681
```

Then run `kumactl`. For example:

```sh
$ kumactl get meshes

NAME          mTLS      METRICS      LOGGING   TRACING
default       off       off          off       off
```

You can configure `kumactl` to point to any remote `kuma-cp` instance by running:

```
$ kumactl config control-planes add --name=XYZ --address=http://{address-to-kong-mesh}:5681
```

{% endnavtab %}
{% endnavtabs %}

Notice that {{site.mesh_product_name}} automatically creates a `Mesh`
entity with the name `default`.

{{site.mesh_product_name}} explicitly specifies a UID
for the `kuma-dp` sidecar to avoid capturing traffic from
`kuma-dp` itself. You must grant a `nonroot` 
[Security Context Constraint](https://docs.openshift.com/container-platform/latest/authentication/managing-security-context-constraints.html)
to the application namespace:

```sh
$ oc adm policy add-scc-to-group nonroot system:serviceaccounts:<app-namespace>
```

If the namespace is not configured properly, you will see the following error
on the `Deployment` or `DeploymentConfig`:

```sh
'pods "kuma-demo-backend-v0-cd6b68b54-" is forbidden: unable to validate against any security context constraint:
[spec.containers[1].securityContext.securityContext.runAsUser: Invalid value: 5678: must be in the ranges: [1000540000, 1000549999]]'
```

## 4. Quickstart

Congratulations! You have successfully installed {{site.mesh_product_name}}.

Before running the Kuma Demo in the Quickstart guide,
run the following command:

```sh
$ oc adm policy add-scc-to-group anyuid system:serviceaccounts:kuma-demo
```

One of the components in the demo requires root access, therefore it uses the
`anyuid` instead of the `nonroot` permission.

The Kuma quickstart documentation
is fully compatible with {{site.mesh_product_name}}, except that you are
running {{site.mesh_product_name}} containers instead of Kuma containers.

To start using {{site.mesh_product_name}}, see the
[quickstart guide for Kubernetes deployments](https://kuma.io/docs/latest/quickstart/kubernetes/).
