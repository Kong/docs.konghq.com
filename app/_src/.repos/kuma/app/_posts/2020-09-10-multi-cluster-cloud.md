---
title: Multi-Cluster & Multi-Cloud Service Meshes With CNCF’s Kuma and Envoy
description: Learn how to create a multi-cluster and multi-cloud service mesh.
date: 2020-09-10
tags:
  - Community
---

When we first created Kuma – which means "bear" in Japanese – we dreamed of creating a service mesh that could run across every cluster, every cloud and every application. These are all requirements that large organizations must implement to support their application teams across a wide variety of architectures and platforms: VMs, Kubernetes, AWS, GCP and so on.

With Kuma – now a CNCF project and at the time of this writing, the only Envoy-based service mesh donated and accepted by the foundation – we have relentlessly executed on this vision with the community.

Starting from Kuma 0.6, which was released this summer with a new advanced multi-zone capability, Kuma now supports every cloud vendor, every architecture and every platform together in a multi-mesh control plane. When deployed in a multi-zone deployment, Kuma abstracts away both the synchronization of the service mesh policies across multiple zones and the service connectivity (and service discovery) across those zones. A zone can be a Kubernetes cluster, a data center, a cloud region, a VPC, a subnet and so on – we can slice and dice zones to our liking, and we can also mix Kubernetes and VM workloads into one distributed mesh deployment.

![](https://2tjosk2rxzc21medji3nfn1g-wpengine.netdna-ssl.com/wp-content/uploads/2020/09/diagram-02-1536x779.jpg)

<center><i>
Kuma creates a service connectivity overlay across hybrid infrastructure to discover and connect services automatically, including hybrid Kubernetes + VM services.
</i></center>

This [multi-zone capability](https://kuma.io/docs/latest/deployments/multi-zone/) has been added in addition to the [multi-mesh support](https://kuma.io/docs/latest/policies/mesh/) that Kuma introduced since day one to create multiple isolated meshes on the same cluster (with dedicated mTLS CAs) in order to reduce team coordination, increase isolation and improve security rather than one large service mesh that everybody is sharing. Also, since multi-zone leverages the first-class K8s + VM support that shipped since the first version of Kuma, all teams and workloads in the organizations can benefit from service mesh and not just our greenfield initiatives.

A Kuma service mesh distributed across every cloud, cluster and workload that the teams are using can therefore be managed from one individual cluster of Kuma itself. Meanwhile, multiple service meshes can be virtually provisioned on one Kuma control plane (horizontally scalable) to simplify mesh management across the organization – very similar to how Kubernetes and its namespaces work.

![](https://2tjosk2rxzc21medji3nfn1g-wpengine.netdna-ssl.com/wp-content/uploads/2020/09/diagram-one-cluster-new@2x.png)

<center><i>
Kuma supports multiple virtual meshes on the same Kuma deployment, removing the requirement of having multiple service mesh clusters for each application and therefore lowering the ops costs significantly.
</i></center>

### Extending xDS With KDS

In Kuma, we can deploy a distributed service mesh running across multiple clusters, clouds or regions by leveraging the “multi-zone” deployment mode. The “multi-zone” deployment is a new way of running Kuma that has been introduced in v0.6+ in addition to the “standalone” deployment mode (one service mesh per zone).

In a multi-zone deployment, there are a few important features that Kuma provides:

1. There are two control plane modes: global and remote. This is quite unique in the service mesh landscape.
2. There is a new DNS “.mesh” zone for service discovery.
3. There is a new “Ingress” data plane proxy type that enables connectivity between zones within a Kuma mesh.

In a distributed deployment, the “global” control plane will be in charge of accepting Kuma resources to determine the behavior of the service mesh via either native Kubernetes CRDs or vanilla YAML in VM-based deployments. It will be in charge of propagating these resources to the “remote” control planes – one for each zone that we want to support.

The “remote” control planes are going to be exchanging Kuma resources with the “global” control plane over an extension of the Envoy xDS API that we called KDS (Kuma Discovery Service) over a gRPC protocol, and therefore, over HTTP/2. The “remote” control planes are also going to be accepting requests from the Envoy-based data plane proxies that belong to the same zone over traditional xDS.

![](https://2tjosk2rxzc21medji3nfn1g-wpengine.netdna-ssl.com/wp-content/uploads/2020/09/diagram-01-1536x1316.jpg)

<center><i>
The remote control planes also embed a DNS service discovery that can be used to discover services across different zones. The above architecture can be easily installed in just a few steps using either the Kuma CLI “kumactl” or HELM charts.
</i></center>

In Kuma, we abstract away the Envoy proxy process in a “kuma-dp” process so that the user never directly configures or starts “envoy”, therefore making the whole process of starting a data plane proxy much easier. Advanced users can still access the underlying “envoy” process if they want to.

By leveraging the native xDS API of Envoy to connect “kuma-dp” with “remote” control planes in every zone as well as leveraging KDS to connect the “remote” control planes to the global control plane, effectively we have gRPC communication enabled across the entire service mesh infrastructure stack in a consistent way.

The “global” and “remote” architecture has a few benefits:

1. We can scale each zone independently by scaling the “remote” control planes and achieve HA in case one zone experiences issues.
2. There is no single point of failure: even if the “global” control plane goes down, we can still register and deregister data plane proxies on the “remote” ones, and the most updated addresses of every service can still be propagated to other Envoy-based sidecars.
3. The “global” control plane allows us to automatically propagate the state across every zone, while at the same time making sure that the “remote” control planes are aware of each zone’s Kuma ingress in order to enable cross-zone connectivity.

The control plane separation governs how Kuma resources (like meshes and policies) are synchronized across the zones, but it requires two other components in order to enable discovery and connectivity at the data plane layer across our zones in an automated way: service discovery and the “ingress” data plane proxy mode.

### Cross-Zone Discovery and Connectivity

Like we described, a multi-zone deployment can be used to deploy a distributed service mesh across multiple clouds and clusters, as well as to enable seamless communication between services running in different zones, effectively providing cross-zone service discovery and connectivity.

Among other use cases, cross-zone connectivity is useful for:

- Enabling high availability across multiple Kubernetes clusters, regions and availability zones in both single and multi-cloud environments
- Enabling traffic shifting from one zone to another for disaster recovery
- Enabling a step-by-step transition of our applications from VMs to Kubernetes – or from physical data centers to the cloud – by leveraging traffic control policies to determine the conditions under which service traffic should be shifted from one zone to another.
  Kuma’s multi-zone deployment enables cross-zone connectivity by providing two important features:

1. A new “ingress” data plane proxy mode processes incoming traffic into a zone. There will be one Kuma ingress deployment per zone, that can be scaled horizontally as the traffic increases. The “ingress” data plane mode is being added in addition to the default proxying one and the “gateway” one (to support third-party API gateways). Because of the new “ingress” mode, Kuma doesn’t require a flat networking topology between zones and can support more complex infrastructure.
2. A built-in service discovery DNS server resolves the address of a service to either an IP address of a replica in the same zone or the address of an ingress proxy in another zone.
   Likewise with the “global” and “remote” control planes, the ingress and the DNS service discovery can also be installed in one click by following the [multi-zone instructions](https://kuma.io/docs/latest/deployments/multi-zone/) on Kuma.

When it comes to service discovery, Kuma creates a “.mesh” DNS entry on the built-in DNS resolver that can be used to resolve services across the same zone or in other zones, effectively “flattening” the discovery of services across a complex infrastructure. Kuma will – accordingly to the traffic routing policies that have been configured – determine if we should be consuming a replica of the service in the local zone or if we should resolve the request to the IP address of a Kuma ingress in another zone, which will then leverage SNI to determine what service has been requested and route the request accordingly.

![](https://2tjosk2rxzc21medji3nfn1g-wpengine.netdna-ssl.com/wp-content/uploads/2020/09/diagram-03.jpg)

<center><i>
In this example, we have three services (users, invoices and billing). Requests to “invoices.mesh” will be proxied to an IP address within the same zone, whereas requests to “billing.mesh” will be <b>automatically</b> proxied to an ingress of another zone.
</i></center>

Since SNI resolution is mandatory for cross-zone communication, the [mTLS policy](https://kuma.io/docs/latest/policies/mutual-tls/) must be enabled on the mesh. Also, since Kuma already knows where all the services are running, cross-zone discovery and connectivity happen automatically.

When a new service is registered into Kuma, a new “kuma.io/zone” tag is added to the data plane definition so that we can use the [attribute-based policy selectors](https://kuma.io/docs/latest/explore/dpp/#tags) to configure Kuma policies like [Traffic Route](https://kuma.io/docs/latest/policies/traffic-route/) to determine the behavior of cross-zone traffic (blue/green or canary across different zones, weighted traffic, as well as traffic shifting).

When consuming any “{service-name}.mesh” on default port 80 (even if the service is not listening on port 80), the DNS resolver – in addition to resolving the address of the service – will also automatically resolve the port of the destination service and inject it into the connection in order to keep the uptime of the overall connectivity even when a team decides to re-assign ports of a service that other teams may be using. This feature reduces the team coordination required to maintain a large number of services and connections in a Kuma mesh.

### Conclusion

Thanks to the new multi-zone capability that Kuma provides since v0.6+, we can now easily run a service mesh across multiple Kubernetes clusters, clouds and regions. Since Kuma natively supports both containerized and VM workloads, this functionality can also be used to create service connectivity across hybrid architectures.

By providing [one-click installation steps](https://kuma.io/docs/latest/documentation/deployments/) to automate the installation of new zones as well as features like global/remote control planes, built-in service discovery and a native Kuma ingress, Kuma abstracts away service connectivity by creating a network overlay that effectively flattens out how services can discover and consume each other across complex network topologies. This makes it a great fit for any enterprise or distributed environment.

To get up and running with Kuma, you can check out the [installation page](https://kuma.io/install) as well as the official [Slack channel](https://kuma.io/community).

Happy meshing! 🚀
