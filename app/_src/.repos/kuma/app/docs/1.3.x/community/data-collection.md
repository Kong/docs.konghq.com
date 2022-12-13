---
title: Kuma data collection
---

Kuma collects some data about your deployment by default. The collected data is sent to Kong servers for storage and aggregation. You can disable data collection when you install the control plane.

## Disable data collection on Kubernetes

1.  Set the following environment variable:

    ```
    KUMA_REPORTS_ENABLED=false
    ```

1.  Specify the environment variable when you install the control plane. See the [configuration docs](/docs/{{ page.version }}/documentation/configuration/) for details.

Or you can set the `reports.enabled` field to `true` in the config YAML file.

## What data is collected

| Data field | Definition | 
|---|---|
| version  | The installed version of Kuma you're running | 
| product  | Static value "Kuma" | 
| unique_id  | Control plane hostname + randon UUID, generated each time control plane instance is restarted | 
| backend  | Where your config is stored. One of in memory, etcd, Postgres | 
| mode    | One of standalone or multizone |
| hostname | The hostname of each Kuma control plane you deploy |
| signal | One of `start` or `ping`. `start` sent when control plane starts, then `ping` once per hour | 
| cluster_id | Unique identifier for entire Kuma cluster. Value is the same for all control planes in the cluster |
| dps_total | The total number of data plane proxies across all meshes | 
| meshes_total | The total number of meshes deployed | 
| zones_total | The total number of zones deployed | 
| internal_services | Tne total number of services running inside your meshes | 
| external_services | The total number of external services configured for your meshes |
| services_ total | The total number of services in your mesh network | 
