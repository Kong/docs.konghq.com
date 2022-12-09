---
title: macOS
---

To install and run Kuma on macOS execute the following steps:

- [1. Download Kuma](#1-download-kuma)
- [2. Run Kuma](#2-run-kuma)
- [3. Use Kuma](#3-use-kuma)

Finally you can follow the [Quickstart](#4-quickstart) to take it from here and continue your Kuma journey.

### 1. Download Kuma

To run Kuma on macOS you can choose among different installation methods:

{% tabs macos-install useUrlFragment=false %}
{% tab macos-install Script %}

Run the following script to automatically detect the operating system and download Kuma:

<div class="language-sh">
<pre class="no-line-numbers"><code>curl -L https://kuma.io/installer.sh | VERSION={{ page.latest_version }} sh -</code></pre>
</div>

{% endtab %}
{% tab macos-install Direct Link %}

You can also download the distribution manually:

- [Download Kuma](https://download.konghq.com/mesh-alpine/kuma-1.1.6-darwin-amd64.tar.gz)

Then extract the archive with:

```sh
tar xvzf kuma-*.tar.gz
```

{% endtab %}
{% tab macos-install Homebrew (kumactl only) %}

If you only need the Kuma CLI `kumactl`, then you can also execute:

```sh
brew install kumactl
```

{% endtab %}
{% endtabs %}

### 2. Run Kuma

Once downloaded, you will find the contents of Kuma in the `kuma-1.1.6` folder. In this folder, you will find - among other files - the `bin` directory that stores all the executables for Kuma.

So we enter the `bin` folder by executing:

```sh
cd kuma-1.1.6/bin
```

Finally we can run Kuma in either **standalone** or **multi-zone** mode:

{% tabs macos-run useUrlFragment=false %}
{% tab macos-run Standalone %}

Standalone mode is perfect when running Kuma in a single cluster across one environment:

```sh
./kuma-cp run
```

To learn more, read about the [deployment modes available](/docs/{{ page.version }}/documentation/deployments/).

{% endtab %}
{% tab macos-run Multi-Zone %}

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
**Note**: By default this will run Kuma with a `memory` [backend](/docs/{{ page.version }}/documentation/backends), but you can use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.
{% endtip %}

### 3. Use Kuma

Kuma (`kuma-cp`) is now running! Now that Kuma has been installed you can access the control-plane via either the GUI, the HTTP API, or the CLI:

{% tabs macos-use useUrlFragment=false %}
{% tab macos-use GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma you can navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab macos-use HTTP API (Read & Write) %}

Kuma ships with a **read and write** HTTP API that you can use to perform operations on Kuma resources. By default the HTTP API listens on port `5681`.

To access Kuma you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab macos-use kumactl (Read & Write) %}

You can use the `kumactl` CLI to perform **read and write** operations on Kuma resources. The `kumactl` binary is a client to the Kuma HTTP API. For example:

```sh
kumactl get meshes
# NAME          mTLS      METRICS      LOGGING   TRACING
# default       off       off          off       off
```

or you can enable mTLS on the `default` Mesh with:

```sh
echo "type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
  - name: ca-1
    type: builtin" | kumactl apply -f -
```

You can configure `kumactl` to point to any remote `kuma-cp` instance by running:

```sh
kumactl config control-planes add --name=XYZ --address=http://{address-to-kuma}:5681
```

{% endtab %}
{% endtabs %}

You will notice that Kuma automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

### 4. Quickstart

Congratulations! You have successfully installed Kuma on macOS 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Universal](/docs/{{ page.version }}/quickstart/universal/) deployments.
