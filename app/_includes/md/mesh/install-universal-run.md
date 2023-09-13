<!-- Shared between Mesh installation topics: Ubuntu, Amazon Linux, RedHat, Debian, MacOS, CentOS -->
## 2. Run {{site.mesh_product_name}}

Once downloaded, you will find the contents of {{site.mesh_product_name}} in the `kong-mesh-{{include.kong_version}}` folder. In this folder, you will find &mdash; among other files &mdash; the bin directory that stores all the executables for {{site.mesh_product_name}}.

Navigate to the `bin` folder:

```sh
cd kong-mesh-{{include.version}}/bin
```

Then, run the control plane with:

```sh
KMESH_LICENSE_PATH=/path/to/file/license.json kuma-cp run
```

Where `/path/to/file/license.json` is the path to a valid
{{site.mesh_product_name}} license file on the file system.

This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
deployment, but there are more advanced [deployment modes][deployments]
like _multi-zone_.

We suggest adding the `kumactl` executable to your `PATH` so that it's always
available in every working directory. Alternatively, you can also create a link
in `/usr/local/bin/` by executing:

```sh
ln -s ./kumactl /usr/local/bin/kumactl
```

This runs {{site.mesh_product_name}} with a [memory backend][backends],
but you can use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.

<!-- links -->
{% if_version gte:2.0.x %}
[deployments]: /mesh/{{page.kong_version}}/production/deployment/
[backends]: /mesh/{{page.kong_version}}/documentation/configuration/
{% endif_version %}

{% if_version lte:1.9.x %}
[deployments]: https://kuma.io/docs/1.8.x/introduction/deployments/
[backends]: https://kuma.io/docs/1.8.x/documentation/configuration/
{% endif_version %}
