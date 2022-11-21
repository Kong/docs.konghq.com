---
title: How to Manage New Data Planes during Control Plane Outages
badge: enterprise
content_type: how-to
---

Starting in {{site.base_gateway}} version 3.1, {{site.base_gateway}} can be configured to support configuring new data planes in the event of a control plane outage. This feature works by designating a backup node, and allowing it read/write access to a data store. This backup node will automatically push valid {{site.base_gateway}} configurations to the data store. In the event of a control plane outtage, if a new node is created, it will pull the latest {{site.base_gateway}} configuration from the data store, configure itself, and start proxying requests. 

This option is only recommended for customers who are have to adhere to strict availability SLAs, because it requires a larger maintence load. 


## Prerequisites

* A {{site.base_gateway}} [hybrid mode](https://docs.konghq.com/gateway/latest/production/deployment-topologies/hybrid-mode/) cluster.
* Access to an S3 compatible storage volume. 

## Configure the backup node

In this setup you will need to designate one backup node. The backup node must have read/write access to the S3 compatible storage volume. This node is responsible for communicating the state of the {{site.base_gateway}} `kong.conf` configuration file from the control plane to the storage volume. The backup node will need **write** access to the storage volume. A backup node is not capable of proxying traffic. A single backup node is sufficient for all deployments.

### Storeage parameters

Storage credentials can be passed as [environment variables](src/gateway/latest/production/environment-variables). 

Configure the storage volume parameters, ensuring that the key for the backup node can **write** to the volume: 

```bash
    export  AWS_REGION: '$AWS_REGION'
    export  AWS_DEFAULT_REGION: '$AWS_DEFAULT_REGION'
    export  AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
    export  AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
```

### {{site.base_gateway}} configuration parameters

In the `kong.conf` configuration file, set the following parameters:

```
cluster_fallback_config: on
cluster_fallback_config_storage: $AWS_STORAGE_ENDPOINT
cluster_fallback_config_exporter = on
```
Only the backup node should have `cluster_fallback_config_exporter` set to `on`. 


## Configure data plane nodes

After configuring the backup node, every other node in the cluster should be given **read** privileges to the storage volume. 


### Storeage parameters

Storage credentials can be passed as [environment variables](src/gateway/latest/production/environment-variables). 

Configure the storage volume parameters, ensuring that the key for the backup node can **read** to the volume: 

```bash
    export  AWS_REGION: '$AWS_REGION'
    export  AWS_DEFAULT_REGION: '$AWS_DEFAULT_REGION'
    export  AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
    export  AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
```

### {{site.base_gateway}} configuration parameters

In the `kong.conf` configuration file, set the following parameters:

```
cluster_fallback_config: on
cluster_fallback_config_storage: $AWS_STORAGE_ENDPOINT
cluster_fallback_config_exporter = off
```

## Configuration Parameters
In this case `cluster_fallback_config_exporter` is set to `off` because only the backup node needs to export configuration files to the storage volume. 

| Parameter      | Description |
| ----------- | ----------- |
| `cluster_fallback_config`      | Fetch fallback configuration from the URL passed in `cluster_fallback_config_storage`. This should only be enabled on the data plane.    |
| `cluster_fallback_config_storage`   | This is the URL of the storage volume. The credentials for this storage volume should be passed as environment variables.       |
| `cluster_fallback_config_exporter` | This parameter enables uploading the configuration to the storage volume. This should only be enabled on the backup node.|


## More Information

* [Control Plane Outage Management FAQ](/gateway/latest/kong-enterprise/cp-outage-handling-faq)
* [Hybrid Mode](/gateway/latest/production/deployment-topologies/hybrid-mode/)