---
title: Virtual Outbound
---

This policy lets you customize hostnames and ports for communicating with data plane proxies.

Possible use cases are:

1) Preserving hostnames when migrating to service mesh.
2) Providing multiple hostnames for reaching the same service, for example when renaming or for usability.
3) Providing specific routes, for example to reach a specific pod in a service with StatefulSets on Kubernetes, or to add a URL to reach a specific version of a service.
4) Expose multiple inbounds on different ports.

Limitations:

- Complex virtual outbounds do not work for cross-zone traffic. This is because only service tags are propagated across zones.
- When duplicate `(hostname, port)` combinations are detected, the virtual outbound with the highest priority takes over. For more information, see [the documentation on how Kuma chooses the right policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply). All duplicate instances are logged.

`conf.host` and `conf.port` are processed as [go text templates](https://pkg.go.dev/text/template) with a key-value pair derived from `conf.parameters`.

`conf.selectors` are used to specify which proxies this policy applies to.

For example a proxy with this definition:

```yaml
type: Dataplane
mesh: default
name: backend-1
networking:
  address: 192.168.0.2
inbound:
  - port: 9000
    servicePort: 6379
    tags:
      kuma.io/service: backend
      version: v1
      port: 1800
```

and a virtual outbound with this definition:

{% raw %}
```yaml
type: VirtualOutbound
mesh: default
name: test
selectors:
  - match:
      kuma.io/service: "*"
conf:
  host: "{{.v}}.{{.service}}.mesh"
  port: "{{.port}}"
  parameters:
    - name: service
      tagKey: "kuma.io/service"
    - name: port
      tagKey: port
    - name: v
      tagKey: version
```
{% endraw %}

produce the hostname: `v1.backend.mesh` with port: `1800`.

Additional requirements:

- [Transparent proxy](/docs/{{ page.version }}/networking/transparent-proxying).
- Either [data plane proxy DNS](/docs/{{ page.version }}/networking/dns), or else the value of `conf.host` must end with the value of `dns_server.domain` (default value `.mesh`).
- `name` must be alphanumeric. (Used as a go template key).
- Each value of `name` must be unique.
- `kuma.io/service` must be specified even if it's unused in the template. (Prevents defining hostnames that spans services).

The default value of `tagKey` is the value of `name`.

For each virtual outbound, the Kuma control plane processes all data plane proxies that match the selector.
It then applies the templates for `conf.host` and `conf.port` and assigns a virtual IP address for each hostname.

## Examples

The following examples show how to use virtual outbounds for different use cases.

### Same as the default DNS

{% tabs default-dns useUrlFragment=false %}
{% tab default-dns Kubernetes %}
{% raw %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: VirtualOutbound
mesh: default
metadata:
    name: default
spec:
    selectors:
      - match:
          kuma.io/service: "*"
    conf:
      host: "{{.service}}.mesh"
      port: "80"
      parameters:
        - name: service
          tagKey: "kuma.io/service"
```
{% endraw %}
{% endtab %}
{% tab default-dns Universal %}
{% raw %}
```yaml
type: VirtualOutbound
mesh: default
name: default
selectors:
  - match:
      kuma.io/service: "*"
conf:
  host: "{{.service}}.mesh"
  port: "80"
  parameters:
    - name: service
      tagKey: "kuma.io/service"
```
{% endraw %}
{% endtab %}
{% endtabs %}

### One hostname per version

{% tabs one-hostname-per-version useUrlFragment=false %}
{% tab one-hostname-per-version Kubernetes %}
{% raw %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: VirtualOutbound
mesh: default
metadata:
  name: versioned
spec:
    selectors:
      - match:
          kuma.io/service: "*"
    conf:
      host: "{{.service}}.{{.version}}.mesh"
      port: "80"
      parameters:
        - name: service
          tagKey: "kuma.io/service"
        - name: version
          tagKey: "kuma.io/version"
```
{% endraw %}
{% endtab %}
{% tab one-hostname-per-version Universal %}
{% raw %}
```yaml
type: VirtualOutbound
mesh: default
name: versioned
spec:
    selectors:
      - match:
          kuma.io/service: "*"
    conf:
      host: "{{.service}}.{{.version}}.mesh"
      port: "80"
      parameters:
        - name: service
          tagKey: "kuma.io/service"
        - name: version
          tagKey: "kuma.io/version"
```
{% endraw %}
{% endtab %}
{% endtabs %}

### Custom tag to define the hostname and port

{% tabs custom-tag useUrlFragment=false %}
{% tab custom-tag Kubernetes %}
{% raw %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: VirtualOutbound
mesh: default
metadata:
  name: host-port
spec:
    selectors:
      - match:
          kuma.io/service: "*"
    conf:
      host: "{{.hostname}}"
      port: "{{.port}}"
      parameters:
        - name: hostname
          tagKey: "my.mesh/hostname"
        - name: port
          tagKey: "my.mesh/port"
```
{% endraw %}
{% endtab %}
{% tab custom-tag Universal %}
{% raw %}
```yaml
type: VirtualOutbound
mesh: default
name: host-port
selectors:
  - match:
      kuma.io/service: "*"
conf:
  host: "{{.hostname}}"
  port: "{{.port}}"
  parameters:
    - name: hostname
      tagKey: "my.mesh/hostname"
    - name: port
      tagKey: "my.mesh/port"
    - name: service
```
{% endraw %}
{% endtab %}
{% endtabs %}

### One hostname per instance

Enables reaching specific data plane proxies for a service.
Useful for running distributed databases such as Kafka or Zookeeper.

{% tabs one-hostname-per-instance useUrlFragment=false %}
{% tab one-hostname-per-instance Kubernetes %}
{% raw %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: VirtualOutbound
mesh: default
metadata:
  name: instance
spec:
  selectors:
    - match:
        kuma.io/service: "*"
        statefulset.kubernetes.io/pod-name: "*"
  conf:
    host: "{{.svc}}.{{.inst}}.mesh"
    port: "8080"
    parameters:
      - name: "svc"
        tagKey: "kuma.io/service"
      - name: "inst"
        tagKey: "statefulset.kubernetes.io/pod-name"
```
{% endraw %}
{% endtab %}
{% tab one-hostname-per-instance Universal %}
{% raw %}
```yaml
type: VirtualOutbound
mesh: default
name: default
selectors:
  - match:
      kuma.io/service: "*"
      kuma.io/instance: "*"
conf:
  host: "inst-{{.instance}}.{{.service}}.mesh"
  port: "8080"
  parameters:
    - name: service
      tagKey: "kuma.io/service"
    - name: instance
      tagKey: "kuma.io/instance"
```
{% endraw %}
{% endtab %}
{% endtabs %}
