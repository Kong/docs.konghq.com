---
title: About Control Plane Outage Management
badge: enterprise
content_type: Reference
---

Starting in version 3.2, {{site.base_gateway}} can be set up to support configuring new data planes in the event of a control plane outage. This document explains how data plane resilience works, who should use it, and additional considerations. For instructions on setting this up, read the [data plane resilience documentation](/gateway/latest/kong-enterprise/cp-outage-handling/).


## How data plane resilience works

When the cluster adds new data plane nodes, the control plane uses a configuration file to provision those nodes. If the control plane experiences an outage, the data plane can't be provisioned and it will silently fail until it can establish a connection with the control plane. After configuring {{site.base_gateway}} to manage the addition of new data plane nodes in the event of a control plane outage, new nodes won't silently fail after not establishing a connection with the control plane. Instead, they are configured by reading the configuration file that is located in the designated S3 compatible storage volume. 

By designating a dedicated backup node, any changes to the configuration file are pushed to the S3 compatible storage. Any new data plane nodes read the configuration file from the S3 compatible storage volume and consume the new configuration changes. 


## Data plane management during a control plane outage

A new data plane node added to the cluster when the control plane is unreachable exhibits the following behavior:  

1. The new data plane node determines that the control plane is unreachable. 
1. The new data plane node reads the configuration file from the S3 compatible storage volume, configures itself, caches the fetched configuration file, and begins proxying requests.
1. The new data plane node continuously tries to establish a connection with the control plane. 

The S3 compatible storage volume is only accessed when the data plane node is created. The configuration will never be pulled from the storage after creation. The data plane will fail if it depends on any other functionality from the control plane. 

{:.important}
> If the data plane and control plane are both configured to `export` a configuration, assuming that they are both configured with the right level of authentication, the data plane will write to the storage volume first, and then the control plane will overwrite the configuration. You should avoid this configuration.

## Security considerations

Storage volume write access is only granted to the backup node.
It is your responsibility to apply any encryption modules your storage provider recommends to encrypt the configuration in the storage volume. 


## Who should use this mode?

This mode should be used only for situations that require adherence to strict high-availability SLA's. For most cases this is not necessary. 


### {{site.base_gateway}} configuration parameters

Data plane resilience is managed in the `kong.conf` configuration file by the following parameters: 

```
cluster_fallback_config_import: on
cluster_fallback_config_storage: $AWS_STORAGE_ENDPOINT
cluster_fallback_config_export = off
```


| Parameter      | Description |
| ----------- | ----------- |
| `cluster_fallback_config_import`      | Fetch the fallback configuration from the URL passed in `cluster_fallback_config_storage` if the CP is unreachable. This should only be enabled on the data plane.     |
| `cluster_fallback_config_storage`   | This is the URL of the storage volume. The credentials for this storage volume should be passed as environment variables.       |
| `cluster_fallback_config_export` | This parameter enables uploading the configuration to the storage volume. This should only be enabled on the backup node.|
