To install and run Kuma execute the following steps:

* [1. Download Kuma](#download-kuma)
* [2. Run Kuma](#run-kuma)
* [3. Use Kuma](#use-kuma)

Finally, you can follow the [Quickstart](#quickstart) to take it from here and continue your Kuma journey.

### Download Kuma

Run the following script to automatically detect the operating system and download Kuma:

<div class="language-sh">
<pre class="no-line-numbers"><code>curl -L https://kuma.io/installer.sh | VERSION={{ page.latest_version }} sh -</code></pre>
</div>

or you can <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-{{ page.os }}-{{ page.arch }}.tar.gz">download</a> the distribution manually.

Then extract the archive with: `tar xvzf kuma-{{ page.latest_version }}`.

{% tip %}
Make sure you have tar and gzip installed.
{% endtip %}


### Run Kuma
Once downloaded, you will find the contents of Kuma in the `kuma-{{ page.latest_version }}` folder. In this folder, you will find - among other files - the `bin` directory that stores all the executables for Kuma.

You can start the control-plane with: `kuma-{{ page.latest_version }}/bin/kuma-cp run`

This example will run Kuma in `standalone` mode for a "flat" deployment, but there are more advanced [deployment modes](/docs/{{ page.version }}/introduction/deployments) like "multi-zone".

We suggest adding the `kumactl` executable to your `PATH` so that it's always available in every working directory. Or - alternatively - you can also create link in `/usr/local/bin/` by executing:

```sh
ln -s kuma-{{ page.latest_version }}/bin/kumactl /usr/local/bin/kumactl
```

{% tip %}
**Note**: By default this will run Kuma with a `memory` [store](/docs/{{ page.version }}/documentation/configuration), but for production you have to use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.
{% endtip %}

### Use Kuma

Kuma (`kuma-cp`) is now running! Now that Kuma has been installed you can access the control-plane via either the GUI, the HTTP API, or the CLI:

{% tabs use-kuma useUrlFragment=false %}
{% tab use-kuma GUI (Read-Only) %}

Kuma ships with a **read-only** GUI that you can use to retrieve Kuma resources. By default the GUI listens on the API port and defaults to `:5681/gui`.

To access Kuma you can navigate to [`127.0.0.1:5681/gui`](http://127.0.0.1:5681/gui) to see the GUI.

{% endtab %}
{% tab use-kuma HTTP API (Read & Write) %}

Kuma ships with a **read and write** HTTP API that you can use to perform operations on Kuma resources. By default the HTTP API listens on port `5681`.

To access Kuma you can navigate to [`127.0.0.1:5681`](http://127.0.0.1:5681) to see the HTTP API.

{% endtab %}
{% tab use-kuma kumactl (Read & Write) %}

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

You can configure `kumactl` to point to any zone `kuma-cp` instance by running:

```sh
kumactl config control-planes add --name=XYZ --address=http://{address-to-kuma}:5681
```
{% endtab %}
{% endtabs %}

You will notice that Kuma automatically creates a [`Mesh`](/docs/{{ page.version }}/policies/mesh) entity with name `default`.

### Quickstart

Congratulations! You have successfully installed Kuma 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Universal](/docs/{{ page.version }}/quickstart/universal) deployments.
