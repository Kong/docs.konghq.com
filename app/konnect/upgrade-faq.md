---
title: Frequently asked questions - Control Plane Upgrades
---



### Are {{site.konnect_short_name}} control plane and associated database migrations or upgrades done by Kong Inc

The {{site.base_gateway}} control plane and its dependencies are fully managed by Konnect. As new versions of {{site.base_gateway}} are released, Konnect supports them as long as they are under our [active support schedule](/gateway/latest/support-policy/#version-support-for-kong-gateway-enterprise/).


### Will {{site.konnect_short_name}} control plane upgrades always show incompatible message on runtime manager page if the data planes are not the same version as the  {{site.konnect_short_name}} control plane?

An old configuration may still be 100% compatible with older data planes and therefore not show any error messages in the {{site.konnect_short_name}} UI. If there are compatibility issues detected when pushing the payload down to the data plane then this will be reflected in the UI.

### Will new features be available if {{site.konnect_short_name}} control plane detects incompatible data planes?

New features will not be available for use or consumption on incompatible data planes. You will see new features available in the {{site.konnect_short_name}} UI regardless of the data plane that is connected to the control plane in {{site.konnect_short_name}}. However, when an update payload is pushed to an incompatible data plane, the update will be automatically rejected by the data plane. 

This is managed by a version compatibility layer that checks the payload before the update gets sent to the data plane. If there are concerns with the payload, metadata is added to the node. That metadata is what will display incompatibility warnings or errors in the {{site.konnect_short_name}} UI. 

For example: If an extra parameter is available with a new version of a plugin, but the data plane doesn't support it, if that parameter is not configured, or is assigned the default value, then no warning or incompatibility metadata will be applied to the node in {{site.konnect_short_name}}, and no warnings or errors will appear.

###  Can customers continue to use older version of a configurations as {{site.konnect_short_name}} control plane auto-upgrades?

Yes all decK dumps, or YAML configurations, will continue to work in {{site.konnect_short_name}} after they are synced.

### Are there any disruptions if customers choose not to upgrade their data planes?

There is **NO** disruption at all if customer choose **NOT** to upgrade their data planes, as long as the version of the data plane is under our [{{site.base_gateway}} active support timeline](/gateway/latest/support-policy/#version-support-for-kong-gateway-enterprise/). 