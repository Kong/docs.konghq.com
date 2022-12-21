---
title: Dependencies
---

{{site.mesh_product_name}} (`kuma-cp`) is one single executable written in GoLang that can be installed anywhere, hence why it's both universal and simple to deploy. 

* Running on **Kubernetes**: No external dependencies required, since it leverages the underlying K8s API server to store its configuration. {{site.mesh_product_name}} automatically injects the sidecar data plane proxies.

* Running on **Universal**: {{site.mesh_product_name}} requires a PostgreSQL database as a dependency in order to store its configuration. PostgreSQL is a very popular and easy database. You can run {{site.mesh_product_name}} with any managed PostgreSQL offering as well, like AWS RDS or Aurora. Out of sight, out of mind!

Out of the box, {{site.mesh_product_name}} ships with a bundled [Envoy](https://www.envoyproxy.io/) data plane proxy ready to use for our services, so that you don't have to worry about putting all the pieces together.

{% tip %}
{{site.mesh_product_name}} ships with an executable `kuma-dp` that executes the bundled `envoy` executable to create the data plane proxy. For details, see the [Overview](/docs/{{ page.version }}/introduction).
{% endtip %}

[Install {{site.mesh_product_name}}](/install/) and follow the instructions to get up and running in a few steps.
