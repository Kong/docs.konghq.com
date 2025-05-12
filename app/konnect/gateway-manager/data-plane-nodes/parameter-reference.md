---
title: Data Plane Node Configuration Parameters
content_type: reference
---

## Advanced parameters for {{site.base_gateway}}

The following parameters are the minimum settings required for a data plane node.
For further customization, see the
[{{site.base_gateway}} configuration reference](/gateway/latest/reference/configuration).

 Parameter                            | Field in {{site.konnect_short_name}} | Description and Value
:-------------------------------------|:------------------------------|:----------------------
 [`role`](/gateway/latest/reference/configuration/#role) | n/a  | The role of the node, in this case `data_plane`.
 [`database`](/gateway/latest/reference/configuration/#database) | n/a | Specifies whether this node connects directly to a database. For a data plane, this setting is always `off`.
 [`cluster_mtls`](/gateway/latest/reference/configuration/#cluster_mtls) | n/a | Enables mTLS on connections between the control plane and the data plane. In this case, set to  `"pki"`.
 [`cluster_control_plane`](/gateway/latest/reference/configuration/#cluster_control_plane) | n/a | Sets the address of the {{site.konnect_short_name}} control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Control plane endpoint in {{site.konnect_short_name}}:<br>`https://example.cp.khcp.konghq.com`<br>configuration value:<br>`example.cp.khcp.konghq.com:443`
 [`cluster_server_name`](/gateway/latest/reference/configuration/#cluster_server_name) | n/a | The SNI (Server Name Indication extension) to use for data plane connections to the control plane through TLS. When not set, data plane will use `kong_clustering` as the SNI.
 [`cluster_telemetry_endpoint`](/gateway/latest/reference/configuration/#cluster_telemetry_endpoint) | n/a | The address that the data plane uses to send Analytics telemetry data to the control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Telemetry endpoint in {{site.konnect_short_name}}:<br>`https://example.tp.khcp.konghq.com`<br>Configuration value:<br>`example.tp.khcp.konghq.com:443`
 [`cluster_telemetry_server_name`](/gateway/latest/reference/configuration/#cluster_telemetry_server_name) | n/a | The SNI (Server Name Indication extension) to use for Analytics telemetry data.
 [`cluster_cert`](/gateway/latest/reference/configuration/#cluster_cert) | **Certificate** | The certificate used for mTLS between CP/DP nodes.
 [`cluster_cert_key`](/gateway/latest/reference/configuration/#cluster_cert_key) | **Private Key** | The private key used for mTLS between CP/DP nodes.
 [`lua_ssl_trusted_certificate`](/gateway/latest/reference/configuration/#lua_ssl_trusted_certificate) | n/a | Either a comma-separated list of paths to certificate authority (CA) files in PEM format, or `system`. We recommend using the value `system` to let {{site.konnect_short_name}} search for the default provided by each distribution.
 [`konnect_mode`](/gateway/latest/reference/configuration/#konnect_mode) | n/a | Set to `on` for any data plane node connected to {{site.konnect_short_name}}.
 [`vitals`](/gateway/latest/reference/configuration/#vitals) | n/a | Legacy vitals analytics reporting mechanism. Set to `off` for all Kong Gateway versions >= 3.0. Set to `on` for Kong Gateway 2.8.x to collect vitals data and send it to the control plane for Analytics dashboards and metrics.
