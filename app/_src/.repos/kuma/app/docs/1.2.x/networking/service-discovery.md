---
title: Service Discovery
---

Here we are going to be exploring the communication between `kuma-dp` and `kuma-cp`, and the communication between multiple `kuma-dp` to handle our service traffic.

Every time a data-plane (served by `kuma-dp`) connects to the control-plane, it initiates a gRPC streaming connection to Kuma (served by `kuma-cp`) in order to retrieve the latest policiy configuration, and send diagnostic information to the control-plane.

In [standalone mode](/docs/{{ page.version }}/deployments/stand-alone/) the `kuma-dp` process will connect directly to the `kuma-cp` instances.

In a [multi-zone deployment](/docs/{{ page.version }}/deployments/multi-zone/) the `kuma-dp` processes will connect to the zone control plane, while the zone control planes will connect to the global control plane over an extension of the xDS API that we have built called "KDS" (Kuma Discovery Service). In multi-zone mode, the data plane proxies never connect to the global control plane but only to the zone ones.

{% tip %}
The connection between the data-planes and the control-plane is not on the execution path of the service requests, which means that if the data-plane temporarily loses connection to the control-plane the service traffic won't be affected.
{% endtip %}

While doing so, the data-planes also advertise the IP address of each service. The IP address is retrieved:

* On Kubernetes by looking at the address of the `Pod`.
* On Universal by looking at the inbound listeners that have been configured in the [`inbound` property](/docs/{{ page.version }}/documentation/dps-and-data-model/#dataplane-specification) of the data-plane specification.

The IP address that's being advertised by every data-plane to the control-plane is also being used to route service traffic from one `kuma-dp` to another `kuma-dp`. This means that Kuma knows at any given time what are all the IP addresses associated to every replica of every service. Another use-case where the IP address of the data-planes is being used is for metrics scraping by Prometheus.

Kuma already ships with its own [DNS service discovery](/docs/{{ page.version }}/networking/dns/) on both standalone and multi-zone modes. 

Connectivity among the `kuma-dp` instances can happen in two ways:

* In [standalone mode](/docs/{{ page.version }}/deployments/stand-alone/) `kuma-dp` processes communicate with each other in a flat networking topology. This means that every data-plane must be able to consume another data-plane by directly sending requests to its IP address. In this mode, every `kuma-dp` must be able to send requests to every other `kuma-dp` on the specific ports that govern service traffic, as described in the `kuma-dp` [ports section](#kuma-dp-ports).
* In [multi-zone mode](/docs/{{ page.version }}/deployments/multi-zone/) connectivity is being automatically resolved by Kuma to either a data-plane running in the same zone, or through the address of a [zone-ingress proxy](/docs/{{ page.version }}/documentation/dps-and-data-model/#zone-ingress) in another zone for cross-zone connectivity. This means that multi-zone connectivity can be used to connect services running in different clusters, platforms or clouds in an automated way. Kuma also creates a `.mesh` zone via its [native DNS resolver](/docs/{{ page.version }}/networking/dns/). The automatically created `kuma.io/zone` tag can be used with Kuma policies in order to determine how traffic flow across a multi-zone setup.

{% tip %}
By default cross-zone connectivity requires [mTLS](/docs/{{ page.version }}/policies/mutual-tls/) to be enabled on the [Mesh](/docs/{{ page.version }}/policies/mesh/) with the appropriate [Traffic Permission](/docs/{{ page.version }}/policies/traffic-permissions/) to enable the flow of traffic. Otherwise, unsecured traffic won't be permitted outside of each zone.
{% endtip %}
