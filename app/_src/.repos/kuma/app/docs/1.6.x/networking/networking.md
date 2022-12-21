---
title: Networking
---

Kuma - being an application that wants to improve the underlying connectivity between your services by making the underlying network more reliable - also comes with some networking requirements itself.

## kuma-cp ports

First and foremost, the `kuma-cp` application is a server that offers a number of services - some meant for internal consumption by `kuma-dp` data-planes, some meant for external consumption by the kumactl CLI, by the HTTP API, or by the GUI.

The number and type of exposed ports depends on the mode in which the control plane is run

### Standalone Control Plane

This is the default, single zone mode, in which all of the following ports are enabled in `kuma-cp`

* TCP
    * `5443`: The port for the admission webhook, only enabled in `Kubernetes`
    * `5676`: the Monitoring Assignment server that responds to discovery requests from monitoring tools, such as `Prometheus`, that are looking for a list of targets to scrape metrics from, e.g. a list of all dataplanes in the mesh.
    * `5678`: the server for the control-plane to data-planes communication (bootstrap configuration, xDS to retrieve their configuration, SDS to retrieve mTLS certificates).
    * `5680`: the HTTP server that returns the health status and metrics of the control-plane.
    * `5681`: the HTTP API server that is being used by `kumactl`, and that you can also use to retrieve Kuma's policies and - when running in `universal` - that you can use to apply new policies. It also exposes the Kuma GUI at `/gui`
    * `5682`: HTTPS version of the services available under `5681`
* UDP
    * `5653`: [the Kuma DNS server](/docs/{{ page.version }}/networking/dns-cp)

### Global Control Plane


When Kuma is run as a distributed service mesh, the Global control plane exposes the following ports:

* TCP
    * `5443`: The port for the admission webhook, only enabled in `Kubernetes`
    * `5680`: the HTTP server that returns the health status of the control-plane.
    * `5681`: the HTTP API server that is being used by `kumactl`, and that you can also use to retrieve Kuma's policies and - when running in `universal` - that you can use to apply new policies. Manipulating the dataplane resources is not possible. It also exposes the Kuma GUI at `/gui`
    * `5682`: HTTPS version of the services available under `5681`
    * `5685`: the Kuma Discovery Service port, leveraged in multi-zone deployment

### Zone Control Plane

When Kuma is run as a distributed service mesh, the Zone control plane exposes the following ports:

* TCP
    * `5443`: The port for the admission webhook, only enabled in `Kubernetes`
    * `5676`: the Monitoring Assignment server that responds to discovery requests from monitoring tools, such as `Prometheus`, that are looking for a list of targets to scrape metrics from, e.g. a list of all dataplanes in the mesh.
    * `5678`: the server for the control-plane to data-planes communication (bootstrap configuration, xDS to retrieve their configuration, SDS to retrieve mTLS certificates).
    * `5680`: the HTTP server that returns the health status of the control-plane.
    * `5681`: the HTTP API server that is being used by `kumactl`, and that you can also use to retrieve Kuma's policies and - when running in `universal` - you can only manage the dataplane resources.
    * `5682`: HTTPS version of the services available under `5681`
* UDP
    * `5653`: [the Kuma DNS server](/docs/{{ page.version }}/networking/dns-cp)

## kuma-dp ports

When we start a data-plane via `kuma-dp` we expect all the inbound and outbound service traffic to go through it. The inbound and outbound ports are defined in the dataplane specification when running in universal mode, while on Kubernetes the service-to-service traffic always runs on port `15001`.

In addition to the service traffic ports, the data-plane automatically also opens the `envoy` [administration interface](https://www.envoyproxy.io/docs/envoy/latest/operations/admin) listener on the `127.0.0.1:9901`.

Check the [dpp documentation](/docs/{{ page.version }}/explore/dpp/#envoy) for more on Envoy Admin port.
