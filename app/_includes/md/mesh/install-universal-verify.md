<!-- Shared between Mesh installation topics: Ubuntu, Amazon Linux, RedHat, Debian, MacOS, CentOS -->
## 3. Verify the Installation

Now that {{site.mesh_product_name}} has been installed, you can access the
control plane using either the GUI, the HTTP API, or the CLI:

{% navtabs %}
{% navtab GUI (Read-Only) %}
{{site.mesh_product_name}} ships with a **read-only** GUI that you can use to
retrieve {{site.mesh_product_name}} resources. By default, the GUI listens on
the API port `5681`.

To access {{site.mesh_product_name}}, navigate to `127.0.0.1:5681/gui` to see
the GUI.

{% endnavtab %}
{% navtab HTTP API (Read & Write) %}

{{site.mesh_product_name}} ships with a **read and write** HTTP API that you can
use to perform operations on {{site.mesh_product_name}} resources. By default,
the HTTP API listens on port `5681`.

To access {{site.mesh_product_name}}, navigate to `127.0.0.1:5681` to see
the HTTP API.

{% endnavtab %}
{% navtab kumactl (Read & Write) %}

You can use the `kumactl` CLI to perform **read and write** operations on
{{site.mesh_product_name}} resources. The `kumactl` binary is a client to
the {{site.mesh_product_name}} HTTP API. For example:

```sh
$ kumactl get meshes
NAME          mTLS      METRICS      LOGGING   TRACING
default       off       off          off       off
```
Or, you can enable mTLS on the `default` Mesh with:

```sh
$ echo "type: Mesh
  name: default
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: builtin" | kumactl apply -f -
```
You can configure `kumactl` to point to any remote `kuma-cp` instance by running:

```sh
$ kumactl config control-planes add \
--name=XYZ \
--address=http://{address-to-mesh}:5681
```

{% endnavtab %}
{% endnavtabs %}

You will notice that {{site.mesh_product_name}} automatically creates a `Mesh`
entity with the name `default`.
