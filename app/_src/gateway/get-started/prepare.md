---
title: Configure Services and Routes
---

Before getting started with using {{site.base_gateway}}, verify that it was
installed correctly, and that you’re ready to administer it.

## Before you begin

Before you start this section, make sure that:

* {{site.base_gateway}} is installed and running.
* Kong Admin API ports are listening on the
appropriate port/IP/DNS settings.
* If using declarative configuration to configure {{site.base_gateway}},
[decK](/deck/latest/installation) is installed.

In this guide, an instance of {{site.base_gateway}} is referenced using
`localhost`. If you are not using `localhost`, make sure to replace `localhost` with the hostname
of your control plane instance.

## Verify the {{site.base_gateway}} configuration

Ensure that you can send requests to the gateway's Admin API using either cURL
or HTTPie.

View the current configuration by issuing the following command in a terminal
window:

```bash
curl -i -X GET http://localhost:8001
```

## (Optional) Verify Control Plane and Data Plane connection

If you're running {{site.base_gateway}} in [hybrid mode](/gateway/{{page.release}}/production/deployment-topologies/hybrid-mode/), 
you need to perform all tasks in this guide from the control plane. You can check
that all of your configurations are being pushed from the control plane to your
data planes using the Cluster Status CLI.

Run the following from a control plane:

```bash
curl -i -X GET http://localhost:8001/clustering/data-planes
```

The output shows all of the connected data plane instances in the cluster:

```json
{
    "data": [
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-2",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.3",
            "last_seen": 1580623199,
            "status": "connected"
        },
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-1",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.4",
            "last_seen": 1580623200,
            "status": "connected"
        }
    ],
    "next": null
}
```

## Summary and next steps

In this section, you learned about the methods of administering
{{site.base_gateway}} and how to access its configuration. Next, go on to
learn about [exposing your services with {{site.base_gateway}}](/gateway/{{page.release}}/get-started//expose-services/).
