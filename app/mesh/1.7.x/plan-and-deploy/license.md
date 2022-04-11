---
title: License
---

Kong Mesh requires a valid license before it can start the global `kuma-cp` process. When the license is not set, Kong Mesh automatically uses a **prebundled license** with the following limits:

* Number of data plane proxies (DPPs) allowed: 5
* Expiration date: 30 days


The prebundled license can be overwritten by explicitly setting a new one. You can obtain a Kong Mesh license by getting in touch with the [Kong team](https://konghq.com/request-demo-kong-mesh/).

A license file with a valid signature typically looks like the following example:

```json
{
  "license": {
    "version": 1,
    "signature": "...",
    "payload": {
      "customer": "company_inc",
      "license_creation_date": "2021-8-4",
      "product_subscription": "Kong Mesh",
      "dataplanes": "5",
      "license_expiration_date": "2023-11-09",
      "license_key": "..."
    }
  }
}
```

When installing Kong Mesh, the license file can be passed to `kuma-cp` with the 
[following instructions](#Configure-the-license). 

If running Kong Mesh in a multi-zone deployment, the file must be passed to the global `kuma-cp`.
In this mode, Kong Mesh automatically synchronizes the license to the remote 
`kuma-cp`, therefore this operation is only required on the global `kuma-cp`.

## Licensed metrics

The license encourages a pay-as-you-go model that delivers the best benefits to you, the end user, since the derived value of Kong Mesh is directly associated to the positive benefits of real service mesh usage.

These metrics are:

* Number of connected data plane proxies (DPPs), across every zone.
* An expiration date that determines the duration of the license.

In the context of the metric, a data plane proxy (DPP) is a standard data plane proxy that is deployed next to your services, either as a sidecar container or in a virtual machine. Gateway data plane proxies, zone ingresses, and zone egresses are not counted.

You can measure the number of data plane proxies needed in Kong Mesh by the 
number of services you want to include in your service meshes. Use the following formula:

```
Number of DPPs = Number of Pods + Number of VMs.
```

## License behaviours

With an expired license or invalid license the control-plane will fail to start.
If the license expires while the control-plane is running it will keep running but a restart of the instance will fail. 
The control-plane will issue a warning in the logs and the GUI when the license expires in less than 30 days.

With a valid issued license, a data plane proxy will always be able to join the service mesh, even if you go above the allowed limit to prevent service disruptions.
If the number of DPPs does go above the limit, you will see a warning in the GUI and in the control plane logs. 

With the prebundled license, if you go over the maximum allowed number of DPPs, the system will automatically refuse their connections.

## License API

You can inspect the license using the GUI or the API `/license` endpoint on the control plane. For example:

```
$ curl <IP of the control plane>:5681/license
{
 "allowedDataplaneProxies": 20,
 "activeDataplaneProxies": 2,
 "expirationDate": "2032-11-09T00:00:00Z",
 "demo": false
}
```

## Configure the license

A valid license file can be passed to Kong Mesh in a variety of ways.

### Kubernetes (kumactl)

When installing the Kong Mesh control plane with `kumactl install control-plane`, provide a `--license-path` argument with a full path to a valid license file. For example:

```sh
$ kumactl install control-plane --license-path=/path/to/license.json
```

### Kubernetes (Helm)

To install a valid license via Helm:

1. Create a secret named `kong-mesh-license` in the same namespace where Kong Mesh is being installed. For example:

  ```sh
  $ kubectl create namespace kong-mesh-system
  $ kubectl create secret generic kong-mesh-license -n kong-mesh-system --from-file=/path/to/license.json
  ```

  Where:
  * `kong-mesh-system` is the namespace where Kong Mesh control plane is installed
  * `/path/to/license.json` is the path to a valid license file. The filename should be `license.json` unless otherwise specified in `values.yaml`.

1. Modify the `values.yaml` file to point to the secret. For example:

  ```yaml
  kuma:
    controlPlane:
      secrets:
        - Env: "KMESH_LICENSE_INLINE"
          Secret: "kong-mesh-license"
          Key: "license.json"
  ```

### Universal

In Universal mode, configure a valid license by using the following environment variables:

* `KMESH_LICENSE_PATH` - value with the path to a valid license file.
* `KMESH_LICENSE_INLINE` - value with the actual contents of the license file.

## Multi-zone

In a multi-zone deployment of Kong Mesh, only the global control plane should be configured with a valid license. The global control plane automatically synchronizes the license to any remote control plane that is part of the cluster.

In a multi-zone deployment, the DPPs count includes the total aggregate of every data plane proxy in every zone. For example, with a limit of 5 DPPs and 2 zones, you can connect 3 DPPs in one zone and 2 in another, but not 5 DPPs for each zone.
