---
title: OpenShift
---

To install and run Kuma on OpenShift execute the following steps:

- [1. Download Kuma](#1-download-kuma)
- [2. Run Kuma](#2-run-kuma)
- [3. Use Kuma](#3-use-kuma)

Finally you can follow the [Quickstart](#4-quickstart) to take it from here and continue your Kuma journey.

### 1. Download Kuma

To run Kuma on OpenShift, you need to download a compatible version of Kuma for the machine from which you will be executing the commands.

{% tabs openshift-install useUrlFragment=false %}
{% tab openshift-install Script %}

You can run the following script to automatically detect the operating system and download Kuma:

<div class="language-sh">
<pre class="no-line-numbers"><code>curl -L https://kuma.io/installer.sh | VERSION={{ page.latest_version }} sh -</code></pre>
</div>

{% endtab %}
{% tab openshift-install Direct Link %}

You can also download the distribution manually. Download a distribution for the **client host** from where you will be executing the commands to access OpenShift:

- [CentOS](https://download.konghq.com/mesh-alpine/kuma-1.4.1-centos-amd64.tar.gz)
- [RedHat](https://download.konghq.com/mesh-alpine/kuma-1.4.1-rhel-amd64.tar.gz)
- [Debian](https://download.konghq.com/mesh-alpine/kuma-1.4.1-debian-amd64.tar.gz)
- [Ubuntu](https://download.konghq.com/mesh-alpine/kuma-1.4.1-ubuntu-amd64.tar.gz)
- [macOS](https://download.konghq.com/mesh-alpine/kuma-1.4.1-darwin-amd64.tar.gz) or `brew install kumactl`

and extract the archive with:

```sh
tar xvzf kuma-*.tar.gz
```

{% endtab %}
{% endtabs %}

### 2. Run Kuma

Once downloaded, you will find the contents of Kuma in the `kuma-1.4.1` folder. In this folder, you will find - among other files - the `bin` directory that stores the executables for Kuma, including the CLI client [`kumactl`](/docs/{{ page.version }}/documentation/cli/#kumactl).

{% tip %}
**Note**: On OpenShift - of all the Kuma binaries in the `bin` folder - we only need `kumactl`.
{% endtip %}

So we enter the `bin` folder by executing:

```sh
cd kuma-1.4.1/bin
```

We suggest adding the `kumactl` executable to your `PATH` so that it's always available in every working directory. Or - alternatively - you can also create link in `/usr/local/bin/` by executing:

```sh
ln -s $PWD/kumactl /usr/local/bin/kumactl
```

Finally we can install and run Kuma in either **standalone** or **multi-zone** mode:

{% tabs openshift-run useUrlFragment=false %}
{% tab openshift-run OpenShift 4.x (Standalone) %}

Standalone mode is perfect when running Kuma in a single cluster across one environment:

```sh
./kumactl install control-plane --cni-enabled | oc apply -f -
```

Starting from version 4.1 OpenShift utilizes `nftables` instead of `iptables`. So using init container for redirecting traffic to the proxy is no longer works. Instead, we use `kuma-cni` which could be installed with `--cni-enabled` flag.
{% endtab %}

{% tab openshift-run OpenShift 3.11 (Standalone) %}

Standalone mode is perfect when running Kuma in a single cluster across one environment.

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

{% tab openshift-run Multi-Zone %}

Multi-zone mode is perfect when running one deployment of Kuma that spans across multiple Kubernetes clusters, clouds and VM environments under the same Kuma deployment.

This mode also supports hybrid Kubernetes + VMs deployments.

To learn more, read the [multi-zone installation instructions](/docs/{{ page.version }}/documentation/deployments/).

{% endtab %}
{% endtabs %}

{% tip %}
It may take a while for OpenShift to start the Kuma resources, you can check the status by executing:

```sh
oc get pod -n kuma-system
```

{% endtip %}

### 3. Use Kuma

Kuma (`kuma-cp`) will be installed in the newly created `kuma-system` namespace! Now that Kuma has been installed, you can access the control-plane via either the GUI, `oc`, the HTTP API, or the CLI:

{% tabs openshift-use useUrlFragment=false %}
{% tab openshift-use GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab openshift-use oc (Read & Write) %}

You can use Kuma with `oc` to perform **read and write** operations on Kuma resources. For example:

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

Kuma ships with a **read-only** HTTP API that you can use to retrieve Kuma resources.

By default the HTTP API listens on port `5681`. To access Kuma we need to first port-forward the API service with:

```sh
oc port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab openshift-use kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API, you will need to first port-forward the API service with:

```sh
oc port-forward svc/kuma-control-plane -n kuma-system 5681:5681
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

You will notice that Kuma automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

{% tip %}
Kuma explicitly specifies UID for `kuma-dp` sidecar to avoid capturing traffic from `kuma-dp` itself. For that reason, `nonroot` [Security Context Constraint](https://docs.openshift.com/container-platform/latest/authentication/managing-security-context-constraints.html) has to be granted to the application namespace:

```sh
oc adm policy add-scc-to-group nonroot system:serviceaccounts:<app-namespace>
```

If namespace is not configured properly, we will see following error on the `Deployment` or `DeploymentConfig`

```
'pods "kuma-demo-backend-v0-cd6b68b54-" is forbidden: unable to validate against any security context constraint: [spec.containers[1].securityContext.securityContext.runAsUser: Invalid value: 5678: must be in the ranges: [1000540000, 1000549999]]'
```

{% endtip %}

### 4. Quickstart

Congratulations! You have successfully installed Kuma on OpenShift 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes/) deployments.

{% tip %}
Before running Kuma Demo in the Quickstart, remember to run the following command

```sh
oc adm policy add-scc-to-group anyuid system:serviceaccounts:kuma-demo
```

In case of Kuma Demo, one of the component requires root access therefore we use `anyuid` instead of `nonroot` permission.
{% endtip %}
