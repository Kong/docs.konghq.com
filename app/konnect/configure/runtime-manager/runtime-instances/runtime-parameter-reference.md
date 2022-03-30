---
title: Runtime Configuration Parameters
no_version: true
---

## Advanced parameters for Kong Gateway

Refer to these parameters when using the **Advanced** runtime setup option.

The following parameters are the minimum settings required for a data plane instance.
For further customization, see the
[{{site.base_gateway}} configuration reference](/gateway/latest/reference/configuration).

 Parameter                            | Field in {{site.konnect_short_name}} | Description and Value
:-------------------------------------|:------------------------------|:----------------------
 [`role`](/gateway/latest/reference/configuration/#role) | n/a  | The role of the node, in this case `data_plane`.
 [`database`](/gateway/latest/reference/configuration/#database) | n/a | Specifies whether this node connects directly to a database. For a data plane, this setting is always `off`.
 [`cluster_mtls`](/gateway/latest/reference/configuration/#cluster_mtls) | n/a | Enables mTLS on connections between the control plane and the data plane. In this case, set to  `"pki"`.
 [`cluster_control_plane`](/gateway/latest/reference/configuration/#cluster_control_plane) | n/a | Sets the address of the {{site.konnect_short_name}} control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Control Plane Endpoint in Konnect:<br>`https://example.cp.khcp.konghq.com`<br>Configuration value:<br>`example.cp.khcp.konghq.com:443`
 [`cluster_server_name`](/gateway/latest/reference/configuration/#cluster_server_name) | n/a | The SNI (Server Name Indication extension) to use for data plane connections to the control plane through TLS. When not set, data plane will use `kong_clustering` as the SNI.
 [`cluster_telemetry_endpoint`](/gateway/latest/reference/configuration/#cluster_telemetry_endpoint) | n/a | The address that the data plane uses to send Vitals telemetry data to the control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Telemetry Endpoint in Konnect:<br>`https://example.tp.khcp.konghq.com`<br>Configuration value:<br>`example.tp.khcp.konghq.com:443`
 [`cluster_telemetry_server_name`](/gateway/latest/reference/configuration/#cluster_telemetry_server_name) | n/a | The SNI (Server Name Indication extension) to use for Vitals telemetry data.
 [`cluster_ca_cert`](/gateway/latest/reference/configuration/#cluster_ca_cert) | **Certificate** | The trusted CA certificate file, in PEM format, used to verify the `cluster_cert`.
 [`cluster_cert`](/gateway/latest/reference/configuration/#cluster_cert) | **Certificate** | The certificate used for mTLS between CP/DP nodes.
 [`cluster_cert_key`](/gateway/latest/reference/configuration/#cluster_cert_key) | **Private Key** | The private key used for mTLS between CP/DP nodes.
