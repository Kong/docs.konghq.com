<!-- Shared between Mesh installation topics: Ubuntu, Amazon Linux, RedHat, Debian, MacOS, CentOS -->
## 2. Run {{site.mesh_product_name}}
Once downloaded, you will find the contents of {{site.mesh_product_name}} in the `kong-mesh-{{page.kong_latest.version}}` folder. In this folder, you will find &mdash; among other files &mdash; the bin directory that stores all the executables for {{site.mesh_product_name}}.

Navigate to the `bin` folder:

```sh
$ cd kong-mesh-{{page.kong_latest.version}}/bin
```

<div class="alert alert-ee blue">
<strong>Note:</strong> Before running the {{site.mesh_product_name}}
control plane process in the next step &mdash; which is served by the <code>kuma-cp</code>
executable &mdash; you need to have a valid {{site.mesh_product_name}} license
in place.
</div>

Then, run the control plane with:

```sh
$ KUMA_LICENSE_PATH=/path/to/file/license.json kuma-cp run
```

Where `/path/to/file/license.json` is the path to a valid
{{site.mesh_product_name}} license file on the file system.

This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
deployment, but there are more advanced [deployment modes](https://kuma.io/docs/latest/documentation/deployments/)
like _multi-zone_.

We suggest adding the `kumactl` executable to your `PATH` so that it's always
available in every working directory. Alternatively, you can also create a link
in `/usr/local/bin/` by executing:

```sh
$ ln -s ./kumactl /usr/local/bin/kumactl
```

<div class="alert alert-ee blue">
<strong>Note:</strong> By default, this will run {{site.mesh_product_name}} with a memory
<a href="https://kuma.io/docs/latest/documentation/backends/">backend</a>, but you can use a persistent storage like PostgreSQL by updating the
<code>conf/kuma-cp.conf</code> file.
</div>
