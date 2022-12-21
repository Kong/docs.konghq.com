---
title: How Kuma chooses the right policy to apply
---

At any single moment, there might be multiple policies (of the same type) that match a connection between `sources` and `destinations` `Dataplane`s.

E.g., there might be a catch-all policy that sets the baseline for your organization

```yaml
type: TrafficLog
mesh: default
name: catch-all-policy
sources:
  - match:
      kuma.io/service: '*'
destinations:
  - match:
      kuma.io/service: '*'
conf:
  backend: logstash
```

Additionally, there might be a more focused use case-specific policy, e.g.

```yaml
type: TrafficLog
mesh: default
name: web-to-backend-policy
sources:
  - match:
      kuma.io/service: web
      cloud: aws
      region: us
destinations:
  - match:
      kuma.io/service: backend
conf:
  backend: splunk
```

What does `Kuma` do when it encounters multiple matching policies?

## General rules

Kuma always picks the most specific policy

1. A policy that matches by a **greater number of tags**

   ```yaml
   - match:
       kuma.io/service: '*'
       cloud:   aws
       region:  us
   ```

   is "more specific" than the one with the less number of tags

   ```yaml
   - match:
       kuma.io/service: '*'
   ```

2. A policy that matches by the **exact tag value**


   ```yaml
   - match:
       kuma.io/service: web
   ```

   is "more specific" than the one that matches by a `'*'` (wildcard)

   ```yaml
   - match:
       kuma.io/service: '*'
   ```

3. If 2 policies match by the same number of tags, then the one with a **greater total number of matches by the exact tag value**

   ```yaml
   - match:
       kuma.io/service: web
       version: v1
   ```

   is "more specific" than the other

   ```yaml
   - match:
       kuma.io/service: web
       version: '*'
   ```

4. If 2 policies are equal (match by the same number of tags, and the total number of matches by the exact tag value is the same for both policies, and the total number of matches by a `'*'` tag value is the same for both policies) then **the latest one** 

   ```yaml
   modificationTime: "2020-01-01T20:00:00.0000Z"
   ...
   - match:
       kuma.io/service: web
       version: v1
   ```

   is "more specific" policy than the older one 

   ```yaml
   modificationTime: "2019-01-01T20:00:00.0000Z"
   ...
   - match:
       kuma.io/service: web
       cloud: aws
   ```

## Dataplane Policy

Dataplane policy is a policy that matches group of data plane proxies, not a connection between multiple proxies.

Assuming we have the following data plane proxy

```yaml
type: Dataplane
mesh: default
name: web-1
networking:
  address: 192.168.0.1
  inbound:
     - port: 9000
       servicePort: 6379
       tags:
         kuma.io/service: web
```

and a `ProxyTemplate` which is an example of a Dataplane Policy

```yaml
type: ProxyTemplate
mesh: default
name: custom-template-1
selectors:
  - match:
      kuma.io/service: web
conf:
  imports:
    - default-proxy
```

then the policy is appplied on the `web-1` data plane proxy.

## Connection policies

The policy can be applied either on inbound connections that a data plane proxy receives or outbound connections that data plane proxy creates,
therefore there are two types of connection policies. 

## Outbound Connection Policy

This kind of policy is enforced on the outbound connections initiated by the data plane proxy defined in `sources` section
and then is applied only if the target data plane proxy matches tags defined in `destination`.

Assuming we have the following data plane proxies:

```yaml
type: Dataplane
mesh: default
name: web-1
networking:
  address: 192.168.0.1
  inbound:
     - port: 9000
       servicePort: 6379
       tags:
         kuma.io/service: web
  outbound:
     - port: 1234
       tags:
          kuma.io/service: backend
     - port: 1234
       tags:
          kuma.io/service: admin
```
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
```

and a `HealthCheck` which is an example of Outbound Connection Policy

```yaml
type: HealthCheck
mesh: default
name: catch-all-policy
sources:
  - match:
      kuma.io/service: web
destinations:
  - match:
      kuma.io/service: backend
```

then the health checking is applied only on the first outbound listener of the `web-1` data plane proxy.
The configuration of `backend-1` data plane proxy is not changed in any way.

## Inbound Connection Policy

This kind of policy is enforced on the inbound connections received by the data plane proxy defined in `destination` section
and then is applied only if the data plane proxy that initiated this connection matches tags defined in `sources`.

Assuming we have the following data plane proxies:

```yaml
type: Dataplane
mesh: default
name: web-1
networking:
  address: 192.168.0.1
  inbound:
     - port: 9000
       servicePort: 6379
       tags:
         kuma.io/service: web
  outbound:
     - port: 1234
       tags:
          kuma.io/service: backend
```
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
      - port: 9000
        servicePort: 6379
        tags:
           kuma.io/service: backend-api
```

and a `TrafficPermission` which is an example of Inbound Connection Policy

```yaml
type: TrafficPermission
mesh: default
name: catch-all-policy
sources:
  - match:
      kuma.io/service: web
destinations:
  - match:
      kuma.io/service: backend
```

then the `TrafficPermission` is enforced only on the first inbound listener of the `backend-1` data plane proxy.
The configuration of `web-1` data plane proxy is not changed in any way.

