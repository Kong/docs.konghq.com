---
title: Kong Mesh with OpenShift
no_search: true
---

## OpenShift

To install and run {{site.mesh_product_name}} on OpenShift, execute the
following steps:

* [1. Download {{site.mesh_product_name}}](#1-download-kong-mesh)
* [2. Configure the license](#2-configure-the-license)
* [3. Follow Kuma instructions](#3-follow-kuma-instructions)

### 1. Download {{site.mesh_product_name}}

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

* [CentOS](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-centos-amd64.tar.gz)
* [RedHat](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-rhel-amd64.tar.gz)
* [Debian](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-debian-amd64.tar.gz)
* [Ubuntu](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-ubuntu-amd64.tar.gz)
* [macOS](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-darwin-amd64.tar.gz)

Then, extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```

{% endnavtab %}
{% endnavtabs %}

### 2. Configure The License

Before running the {{site.mesh_product_name}} control plane process - which is served by the `kuma-cp` container - we need to make sure that we have a valid {{site.mesh_product_name}} license in place.

This can be done by installing the control plane with:

{% navtabs %}
{% navtab OpenShift 4.x %}

```sh
kumactl install control-plane --cni-enabled --license-path=license.json | oc apply -f -
```

Starting from version 4.1 OpenShift utilizes `nftables` instead of `iptables`. So using init container for redirecting traffic to the proxy is no longer works. Instead, we use `kuma-cni` which could be installed with `--cni-enabled` flag.

{% endnavtab %}
{% navtab OpenShift 3.11 %}

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
$ ./kumactl install control-plane --license-path=license.json | oc apply -f -
```

{% endnavtab %}
{% endnavtabs %}

Where `license.json` is the path to a valid {{site.mesh_product_name}} license file on the file system.

### 3. Follow Kuma Instructions

After downloading the {{site.mesh_product_name}} binaries, the remaining
installation instructions for Kuma are fully compatible with
{{site.mesh_product_name}}, except you will be running the
{{site.mesh_product_name}} binaries instead of the vanilla Kuma ones.

To continue the installation, start from the second installation step in
[the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/openshift/#_2-run-kuma) keeping in mind that we need to install the control plane with the appropriate license file as described on this page.
