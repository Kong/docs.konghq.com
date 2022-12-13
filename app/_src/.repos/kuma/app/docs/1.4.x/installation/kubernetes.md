---
title: Kubernetes
---

To install and run Kuma on Kubernetes execute the following steps:

- [1. Download Kuma](#1-download-kuma)
- [2. Run Kuma](#2-run-kuma)
- [3. Use Kuma](#3-use-kuma)

Finally you can follow the [Quickstart](#4-quickstart) to take it from here and continue your Kuma journey.

{% tip %}
Kuma also provides [Helm charts](/docs/{{ page.version }}/installation/helm/) that we can use instead of this distribution.
{% endtip %}

### 1. Download Kuma

To run Kuma on Kubernetes, you need to download a compatible version of Kuma for the machine from which you will be executing the commands.

{% tabs kubernetes-install useUrlFragment=false %}
{% tab kubernetes-install Script %}

You can run the following script to automatically detect the operating system and download Kuma:

<div class="language-sh">
<pre class="no-line-numbers"><code>curl -L https://kuma.io/installer.sh | VERSION={{ page.latest_version }} sh -</code></pre>
</div>

{% endtab %}
{% tab kubernetes-install Direct Link %}

You can also download the distribution manually. Download a distribution for the **client host** from where you will be executing the commands to access Kubernetes:

- [CentOS](https://download.konghq.com/mesh-alpine/kuma-1.4.1-centos-amd64.tar.gz)
- [RedHat](https://download.konghq.com/mesh-alpine/kuma-1.4.1-rhel-amd64.tar.gz)
- [Debian](https://download.konghq.com/mesh-alpine/kuma-1.4.1-debian-amd64.tar.gz)
- [Ubuntu](https://download.konghq.com/mesh-alpine/kuma-1.4.1-ubuntu-amd64.tar.gz)
- [macOS](https://download.konghq.com/mesh-alpine/kuma-1.4.1-darwin-amd64.tar.gz) or run `brew install kumactl`

and extract the archive with:

```sh
tar xvzf kuma-*.tar.gz
```

{% endtab %}
{% endtabs %}

### 2. Run Kuma

Once downloaded, you will find the contents of Kuma in the `kuma-1.4.1` folder. In this folder, you will find - among other files - the `bin` directory that stores the executables for Kuma, including the CLI client [`kumactl`](/docs/{{ page.version }}/documentation/cli/#kumactl).

{% tip %}
**Note**: On Kubernetes - of all the Kuma binaries in the `bin` folder - we only need `kumactl`.
{% endtip %}

So we enter the `bin` folder by executing:

```sh
cd kuma-1.4.1/bin
```

Finally we can install and run Kuma in either **standalone** or **multi-zone** mode:

{% tabs kubernetes-run useUrlFragment=false %}
{% tab kubernetes-run Standalone %}

Standalone mode is perfect when running Kuma in a single cluster across one environment:

```sh
./kumactl install control-plane | kubectl apply -f -
```

To learn more, read about the [deployment modes available](/docs/{{ page.version }}/documentation/deployments/).

{% endtab %}
{% tab kubernetes-run Multi-Zone %}

Multi-zone mode is perfect when running one deployment of Kuma that spans across multiple Kubernetes clusters, clouds and VM environments under the same Kuma deployment.

This mode also supports hybrid Kubernetes + VMs deployments.

To learn more, read the [multi-zone installation instructions](/docs/{{ page.version }}/documentation/deployments/).

{% endtab %}
{% endtabs %}

We suggest adding the `kumactl` executable to your `PATH` so that it's always available in every working directory. Or - alternatively - you can also create link in `/usr/local/bin/` by executing:

```sh
ln -s $PWD/kumactl /usr/local/bin/kumactl
```

{% tip %}
It may take a while for Kubernetes to start the Kuma resources, you can check the status by executing:

```sh
kubectl get pod -n kuma-system
```

{% endtip %}

### 3. Use Kuma

Kuma (`kuma-cp`) will be installed in the newly created `kuma-system` namespace! Now that Kuma has been installed, you can access the control-plane via either the GUI, `kubectl`, the HTTP API, or the CLI:

{% tabs kubernetes-use useUrlFragment=false %}
{% tab kubernetes-use GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab kubernetes-use kubectl (Read & Write) %}

You can use Kuma with `kubectl` to perform **read and write** operations on Kuma resources. For example:

```sh
kubectl get meshes
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
      type: builtin" | kubectl apply -f -
```

{% endtab %}
{% tab kubernetes-use HTTP API (Read-Only) %}

Kuma ships with a **read-only** HTTP API that you can use to retrieve Kuma resources.

By default the HTTP API listens on port `5681`. To access Kuma we need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
```

And then you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab kubernetes-use kumactl (Read-Only) %}

You can use the `kumactl` CLI to perform **read-only** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API, you will need to first port-forward the API service with:

```sh
kubectl port-forward svc/kuma-control-plane -n kuma-system 5681:5681
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

### 4. Quickstart

Congratulations! You have successfully installed Kuma on Kubernetes 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Kubernetes](/docs/{{ page.version }}/quickstart/kubernetes/) deployments.
