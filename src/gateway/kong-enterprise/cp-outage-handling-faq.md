---
title: Control Plane Outage Management FAQ
badge: enterprise
content_type: Reference
---

Starting in {{site.base_gateway}} version 3.1, {{site.base_gateway}} can be configured to support configuring new data planes in the event of a control plane outage. This document serves as an informational set of guidelines for that feature. For instructions on setting this up, read the [How to Manage New Data Planes during Control Plane Outages](/gateway/latest/kong-enterprise/cp-outage-handling) doc.


## How it works

When the cluster adds new data plane nodes, the contol plane uses a configuration file to provision those nodes. If the control plane experiences an outage, the data plane is unable to be provisioned, and will silently fail until they can establish a connection with the control plane. After configuring {{site.base_gateway}} to manage the addition of new data plane nodes in the event of a control plane outage new nodes will no longer silently fail after not being able to establish a connection with the control plane and are configured by reading the configuration file that is located in the designated S3 compatible storage volume. 

By designating a dedicated backup node, any changes to the configuration file are pushed to the S3 compatible storage. Any new data plane nodes read the configuration file from the S3 compatible storage volume and consume the new configuration changes. 


## Data plane management during control plane outage

A new data plane node that is added to the cluster when the control plane is unreachable exhibits the following behaviour:  

* The new data plane node determines that the control plane is unreachable. 
* The new data plane node reads the configuration file from the S3 compatible storage volume, configures itself, caches the fetched configuration file, and begins proxying requests.
* The new data plane node continuously tries to establish a connection with the control plane. 

The S3 compatible storage volume is only accessed at data plane node creation time. The configuration will never be pulled from the storage after creation. If the new data plane node depends on any other functionality from the control plane, it will fail. 



## Security considerations

Storage volume write access is only granted to the backup node.
It is your responsibility to apply any encryption modules your storage provider recommends to encrypt the configuration in the storage volume. 


## Who should use this mode?

This mode should be used only for situations that require adhearance to strict high-availability SLA's. For most cases this is not neccesary. 
