---
title: CLI Arguments
---

Various settings and configurations of the controller can be tweaked
using CLI flags.

## Environment variables

Each flag defined in the table below can also be configured using
an environment variable. The name of the environment variable is `CONTROLLER_`
string followed by the name of flag in uppercase.

For example, `--ingress-class` can be configured using the following
environment variable:

```
CONTROLLER_INGRESS_CLASS=kong-foobar
```

It is recommended that all the configuration is done via environment variables
and not CLI flags.

## Flags

Following table describes all the flags that are available:

| Flag                                   | Type               | Description                                                                                                                                         | Default                           |
|----------------------------------------|--------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------|
| --admission-webhook-cert               | `string`           | admission server PEM certificate value                                                                                                              |                                   |
| --admission-webhook-cert-file          | `string`           | admission server PEM certificate file path; if both this and the cert value is unset a default is provided.                                         | `/admission-webhook/tls.crt`      |
| --admission-webhook-key                | `string`           | admission server PEM private key value                                                                                                              |                                   |
| --admission-webhook-key-file           | `string`           | admission server PEM private key file path; if both this and the key value is unset a default is provided.                                          | `/admission-webhook/tls.key`      |
| --admission-webhook-listen             | `string`           | The address to start admission controller on (ip:port).  Setting it to 'off' disables the admission controller.                                     | `"off"`                           |
| --anonymous-reports                    | `string`           | Send anonymized usage data to help improve Kong                                                                                                     | `true`                            |
| --apiserver-host                       | `string`           | The Kubernetes API server URL. If not set, the controller will use cluster config discovery.                                                        |                                   |
| --enable-controller-ingress-extensionsv1beta1 | `boolean` | Enable the extensions/v1beta1 Ingress controller.                                  | `true`                        |
| --enable-controller-ingress-networkingv1      | `boolean` | Enable the networking.k8s.io/v1 Ingress controller.                                | `true`                         |
| --enable-controller-ingress-networkingv1beta1 | `boolean` | Enable the networking.k8s.io/v1beta1 Ingress controller.                           | `true`                        |
| --enable-controller-knativeingress            | `boolean` | Enable the KnativeIngress controller.                                                                 | `true`                         |
| --enable-controller-kongclusterplugin         | `boolean` | Enable the KongClusterPlugin controller.                                                              | `true`                         |
| --enable-controller-kongconsumer              | `boolean` | Enable the KongConsumer controller.                                                                   | `true`                         |
| --enable-controller-kongingress               | `boolean` | Enable the KongIngress controller.                                                                    | `true`                         |
| --enable-controller-kongplugin                | `boolean` | Enable the KongPlugin controller.                                                                     | `true`                         |
| --enable-controller-service                   | `boolean` | Enable the Service controller.                                                                        | `true`                         |
| --enable-controller-tcpingress                | `boolean` | Enable the TCPIngress controller.                                                                     | `true`                         |
| --enable-controller-udpingress                | `boolean` | Enable the UDPIngress controller.                                                                     | `true`                         |
| --dump-config                          | `boolean`          | Enable config dumps via web interface host:10256/debug/config                                                                                       | `false`                           |
| --dump-sensitive-config                | `boolean`          | Include credentials and TLS secrets in configs exposed with --dump-config                                                                           | `false`                           |
| --election-id                          | `string`           | Election id to use for status update.                                                                                                               | `"5b374a9e.konghq.com"`           |
| --enable-reverse-sync                  | `boolean`          | Send configuration to Kong even if the configuration checksum has not changed since previous update.                                                | `false`                           |
| --health-probe-bind-address            | `string`           | The address the probe endpoint binds to.                                                                                                            | `":10254"`                        |
| --help                                 | `boolean`          | help for this command                                                                                                                               | `false`                           |
| --ingress-class                        | `string`           | Name of the ingress class to route through this controller.                                                                                         | `"kong"`                          |
| --kong-admin-ca-cert                   | `string`           | PEM-encoded CA certificate to verify Kong's Admin SSL certificate.                                                                                  |                                   |
| --kong-admin-ca-cert-file              | `string`           | Path to PEM-encoded CA certificate file to verify Kong's Admin SSL certificate.                                                                     |                                   |
| --kong-admin-concurrency               | `int`              | Max number of concurrent requests sent to Kong's Admin API.                                                                                         | `10`                              |
| --kong-admin-filter-tag                | `strings`          | The tag used to manage and filter entities in Kong. This flag can be specified multiple times to specify multiple tags.                             | `[managed-by-ingress-controller]` |
| --kong-admin-header                    | `strings`          | add a header (key:value) to every Admin API call, this flag can be used multiple times to specify multiple headers                                  |                                   |
| --kong-admin-tls-server-name           | `string`           | SNI name to use to verify the certificate presented by Kong in TLS.                                                                                 |                                   |
| --kong-admin-tls-skip-verify           | `boolean`          | Disable verification of TLS certificate of Kong's Admin endpoint.                                                                                   | `false`                           |
| --kong-admin-token                     | `string`           | The Kong Enterprise RBAC token used by the controller.                                                                                              |                                   |
| --kong-admin-url                       | `string`           | The Kong Admin URL to connect to in the format "protocol://address:port".                                                                           | `"http://localhost:8001"`         |
| --kong-custom-entities-secret          | `string`           | A Secret containing custom entities for DB-less mode, in "namespace/name" format                                                                    |                                   |
| --kong-workspace                       | `string`           | Kong Enterprise workspace to configure. Leave this empty if not using Kong workspaces.                                                              |                                   |
| --kubeconfig                           | `string`           | Path to the kubeconfig file.                                                                                                                        |                                   |
| --leader-elect                         | `boolean`          | Enable leader election for controller manager. Enabling this will ensure there is only one active controller manager.                               | `false`                           |
| --log-format                           | `string`           | Format of logs of the controller. Allowed values are text and json.                                                                                 | `"text"`                          |
| --log-level                            | `string`           | Level of logging for the controller. Allowed values are trace, debug, info, warn, error, fatal and panic.                                           | `"info"`                          |
| --metrics-bind-address                 | `string`           | The address the metric endpoint binds to.                                                                                                           | `":10255"`                        |
| --profiling                            | `boolean`          | Enable profiling via web interface host:10256/debug/pprof/                                                                                          | `false`                           |
| --proxy-sync-seconds                   | `float32`          | Define the rate (in seconds) in which configuration updates will be applied to the Kong Admin API.                                                  | `3`                               |
| --proxy-timeout-seconds                | `float32`          | Define the rate (in seconds) in which the timeout configuration will be applied to the Kong client.                                                 | `10`                              |
| --publish-service                      | `string`           | Service fronting Ingress resources in "namespace/name" format. The controller will update Ingress status information with this Service's endpoints. |                                   |
| --publish-status-address               | `strings`          | User-provided addresses in comma-separated string format, for use in lieu of "publish-service" when that Service lacks useful address information.  |                                   |
| --sync-period                          | `duration`         | Relist and confirm cloud resources this often                                                                                                       | `48h`                             |
| --update-status                        | `boolean`          | Indicates if the ingress controller should update the status of resources (e.g. IP/Hostname for v1.Ingress, e.t.c.)                                 | `true`                            |
| --watch-namespace                      | `strings`          | Namespace(s) to watch for Kubernetes resources. Defaults to all namespaces. To watch multiple namespaces, use a comma-separated list of namespaces. | `all`                             |
