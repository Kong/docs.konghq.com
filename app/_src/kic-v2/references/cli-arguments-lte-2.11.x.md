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
| `--admission-webhook-cert`               | `string`           | Admission server PEM certificate. value                                                                                                              |                                   |
| `--admission-webhook-cert-file`          | `string`           | Admission server PEM certificate file path; if both this and the cert value is unset a default is provided.                                         | `/admission-webhook/tls.crt`      |
| `--admission-webhook-key`                | `string`           | Admission server PEM private key value                                                                                                              |                                   |
| `--admission-webhook-key-file`           | `string`           | Admission server PEM private key file path; if both this and the key value is unset a default is provided.                                          | `/admission-webhook/tls.key`      |
| `--admission-webhook-listen`             | `string`           | The address to start admission controller on (`ip:port`).  Setting it to `off` disables the admission controller.                                     | `"off"`                           |
| `--anonymous-reports`                    | `string`           | Send anonymized usage data to help improve Kong.                                                                                                     | `true`                            |
| `--apiserver-burst`                      | `int`              | The Kubernetes API server burst queries limit, to temporarily exceed the `--apiserver-qps` limit.                                                     | `300`                             |
| `--apiserver-host`                       | `string`           | The Kubernetes API server URL. If not set, the controller will use cluster config discovery.                                                        |                                   |
| `--apiserver-qps`                        | `int`              | The Kubernetes API server queries per second limit.                                                                                                 | `100`                             |
| `--dump-config`                          | `boolean`          | Enable config dumps via web interface `host:10256/debug/config`.                                                                                       | `false`                           |
| `--dump-sensitive-config`                | `boolean`          | Include credentials and TLS secrets in configs exposed with `--dump-config`.                                                                           | `false`                           |
| `--election-id`                          | `string`           | Election id to use for status update.                                                                                                               | `"5b374a9e.konghq.com"`           |
| `--election-namespace`                   | `string`           | Namespace to use for election ConfigMap. Only necessary for development environments running outside a Kubernetes cluster.                          | |
| `--enable-controller-ingress-extensionsv1beta1` | `boolean` | Enable the extensions/v1beta1 Ingress controller.                                  | `true`                        |
| `--enable-controller-ingress-networkingv1`      | `boolean` | Enable the `networking.k8s.io/v1` Ingress controller.                                | `true`                         |
| `--enable-controller-ingress-networkingv1beta1` | `boolean` | Enable the `networking.k8s.io/v1beta1` Ingress controller.                           | `true`                        |
| `--enable-controller-knativeingress`            | `boolean` | Enable the KnativeIngress controller.                                                                 | `true`                         |
| `--enable-controller-kongclusterplugin`         | `boolean` | Enable the KongClusterPlugin controller.                                                              | `true`                         |
| `--enable-controller-kongconsumer`              | `boolean` | Enable the KongConsumer controller.                                                                   | `true`                         |
| `--enable-controller-kongingress`               | `boolean` | Enable the KongIngress controller.                                                                    | `true`                         |
| `--enable-controller-kongplugin`                | `boolean` | Enable the KongPlugin controller.                                                                     | `true`                         |
| `--enable-controller-service`                   | `boolean` | Enable the Service controller.                                                                        | `true`                         |
| `--enable-controller-tcpingress`                | `boolean` | Enable the TCPIngress controller.                                                                     | `true`                         |
| `--enable-controller-udpingress`                | `boolean` | Enable the UDPIngress controller.                                                                     | `true`                         |
| `--enable-reverse-sync`                  | `boolean`          | Send configuration to Kong even if the configuration checksum has not changed since previous update.                                                | `false`                           |

{% if_version gte:2.5.x %}
| `--feature-gates`                        | `strings`          | A set of key=value pairs that describe feature gates for alpha/beta/experimental features.                                                          | see [feature-gates][fg]           |
{% endif_version %}

{% if_version gte:2.6.x %}
| `--gateway-api-controller-name`          | `string`           | Controller name of the Kubernetes Gateway API. Gateway resources are reconciled only when their GatewayClass has the same value in `spec.controllerName`.           | `konghq.com/kic-gateway-controller` |
{% endif_version %}

| `--health-probe-bind-address`            | `string`           | The address the probe endpoint binds to.                                                                                                            | `":10254"`                        |
| `--help`                                 | `boolean`          | Help for this command.                                                                                                                              | `false`                           |
| `--ingress-class`                        | `string`           | Name of the ingress class to route through this controller.                                                                                         | `"kong"`                          |
| `--kong-admin-ca-cert`                   | `string`           | PEM-encoded CA certificate to verify Kong's Admin SSL certificate.                                                                                  |                                   |
| `--kong-admin-ca-cert-file`              | `string`           | Path to PEM-encoded CA certificate file to verify Kong's Admin SSL certificate.                                                                     |                                   |
| `--kong-admin-concurrency`               | `int`              | Max number of concurrent requests sent to Kong's Admin API.                                                                                         | `10`                              |
| `--kong-admin-filter-tag`                | `strings`          | The tag used to manage and filter entities in Kong. This flag can be specified multiple times to specify multiple tags.                             | `[managed-by-ingress-controller]` |
| `--kong-admin-header`                    | `strings`          | Add a header (key:value) to every Admin API call, this flag can be used multiple times to specify multiple headers.                                 |                                   |
| `--kong-admin-init-retries`              | `int`              | Number of attempts that will be made initially on controller startup to connect to the Kong Admin API.                                              | `60`                              |
| `--kong-admin-init-retry-delay`          | `duration`         | The time delay between every attempt (on controller startup) to connect to the Kong Admin API.                                                      |                                   |
| `--kong-admin-tls-server-name`           | `string`           | SNI name to use to verify the certificate presented by Kong in TLS.                                                                                 |                                   |
| `--kong-admin-tls-skip-verify`           | `boolean`          | Disable verification of TLS certificate of Kong's Admin endpoint.                                                                                   | `false`                           |
| `--kong-admin-token`                     | `string`           | The {{site.ee_product_name}} RBAC token used by the controller.                                                                                              |                                   |

{% if_version lte:2.8.x %}
| `--kong-admin-url`                       | `string`           | The Kong Admin URL to connect to in the format "protocol://address:port".                                                                           | `"http://localhost:8001"`         |
{% endif_version %}

{% if_version gte:2.9.x %}
| `--kong-admin-url`                       | `strings`          | Comma-separated string list of Kong Admin URL(s) to connect to in the format "protocol://address:port".                                             | `["http://localhost:8001"]`       |
{% endif_version %}

{% if_version gte:2.9.x %}
| `--kong-admin-svc`                       | `strings`          | Kong Admin API Service namespaced name in "namespace/name" format, to use for Gateway discovery.                                                    | `""`                              |
| `--kong-admin-svc-port-names`            | `strings`          | Names of ports on Kong Admin API service to take into account when doing gateway discovery.                                                         | `["admin","admin-tls","kong-admin","kong-admin-tls"]` |
{% endif_version %}

{% if_version lte:2.8.x %}
| `--kong-custom-entities-secret`          | `string`           | A Secret containing custom entities for DB-less mode, in "namespace/name" format.                                                                   |                                   |
{% endif_version %}

| `--kong-workspace`                       | `string`           | {{site.ee_product_name}} workspace to configure. Leave this empty if not using Kong workspaces.                                                              |                                   |
| `--kubeconfig`                           | `string`           | Path to the kubeconfig file.                                                                                                                        |                                   |
| `--log-format`                           | `string`           | Format of logs of the controller. Allowed values are text and json.                                                                                 | `"text"`                          |
| `--log-level`                            | `string`           | Level of logging for the controller. Allowed values are trace, debug, info, warn, error, fatal and panic.                                           | `"info"`                          |
| `--metrics-bind-address`                 | `string`           | The address the metric endpoint binds to.                                                                                                           | `":10255"`                        |
| `--profiling`                            | `boolean`          | Enable profiling via web interface `host:10256/debug/pprof/`.                                                                                       | `false`                           |
| `--proxy-sync-seconds`                   | `float32`          | Define the rate (in seconds) in which configuration updates will be applied to the Kong Admin API.                                                  | `3`                               |
| `--proxy-timeout-seconds`                | `float32`          | Define the rate (in seconds) in which the timeout configuration will be applied to the Kong client.                                                 | `30`                              |
| `--publish-service`                      | `string`           | Service fronting Ingress resources in "namespace/name" format. The controller will update Ingress status information with this Service's endpoints. |                                   |
| `--publish-status-address`               | `strings`          | User-provided addresses in comma-separated string format, for use in lieu of "publish-service" when that Service lacks useful address information.  |                                   |

{% if_version gte:2.9.x %}
| `--publish-service-udp`                  | `string`           | Service fronting UDP routing resources in "namespace/name" format. The controller updates Ingress status information with this Service's endpoints. If omitted, the same Service is used for both TCP and UDP routes. |                                   |
| `--publish-status-address-udp`           | `strings`          | User-provided addresses in comma-separated string format, for use instead of `publish-service-udp` when that Service lacks useful address information. |                                   |
{% endif_version %}

{% if_version gte:2.4.x %}
| `--skip-ca-certificates`                 | `boolean`          | Disable CA certificate handling. When using multiple controllers for separate workspaces in the same Kong instance, all but one controller should have this set to `true`. | `false`     |
{% endif_version %}

| `--sync-period`                          | `duration`         | Relist and confirm cloud resources this often.                                                                                                       | `48h`                             |

{% if_version gte:2.4.x %}
| `--term-delay`                           | `duration`         | The time delay to sleep before SIGTERM or SIGINT shuts down the Ingress Controller.                                                              | `0s`                              |
{% endif_version %}

| `--update-status`                        | `boolean`          | Indicates if the ingress controller should update the status of resources (e.g. IP/Hostname for v1.Ingress, e.t.c.).                                 | `true`                            |
| `--watch-namespace`                      | `strings`          | Namespace(s) to watch for Kubernetes resources. Defaults to all namespaces. To watch multiple namespaces, use a comma-separated list of namespaces. | `all`                             |

[fg]: /kubernetes-ingress-controller/{{page.release}}/references/feature-gates
