---
title: Removing KongIngress
---

## konghq.com/headers.* annotation

The [`konghq.com/headers.*` annotation][headers-annotation] uses a special
format to set headers. The string after the `.` in the annotation name is the
header name and the annotation value is the header value. For example, to apply
`x-custom-header-a: example,otherexample` and `x-custom-header-b: example`
headers to requests, the KongIngress configuration is:

```yaml
route:
  headers:
    x-custom-header-a:
    - example
    - otherexample
    x-custom-header-b:
    - example
```

The equivalent annotation configuration looks like:

```text
konghq.com/headers.x-custom-header-a: example,otherexample
konghq.com/headers.x-custom-header-b: example
```

You cannot apply multiple instances of the same header annotation to
set multiple header values. You must set the CSV format within a single header.

## KongUpstreamPolicy

The `upstream` section of `KongIngress` resources contains a complex object that does not easily fit in annotations. Version 3.x uses the new `KongUpstreamPolicy` resource to configure upstream settings. The `spec` field of `KongUpstreamPolicy` is similar to the `upstream` section of KongIngress, with the following differences:

- Field names now use `lowerCamelCase` instead of `snake_case` to be consistent with Kubernetes APIs.
- `hash_on`, `hash_fallback`, and their related `has_on_*`, `hash_fallback_*` fields are now `hashOn` and `hashOnFallback` objects. To define the primary hashing strategy, use `hashOn` with one of its fields filled (e.g. when you want to hash on a header, fill `hashOn.header` with a header name). Similarly, to define the secondary hashing strategy, use `hashOnFallback`.

For the exact schema please refer to [KongUpstreamPolicy reference](/kubernetes-ingress-controller/{{ page.release }}/reference/custom-resources/#kongupstreampolicy). 

For example, if you previously used a KongIngress like:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: sample-customization
upstream:
  hash_on: header
  hash_on_header: x-lb
  hash_fallback: ip
  algorithm: consistent-hashing
```

You need to use a `KongUpstreamPolicy`:

```yaml
apiVersion: configuration.konghq.com/v1beta1
kind: KongUpstreamPolicy
metadata:
  name: sample-customization
spec:
  hashOn: 
    header: x-lb
  hashOnFallback: 
    input: ip
  algorithm: consistent-hashing
```

Apply it to a Service resource with a `konghq.com/upstream-policy: sample-customization` annotation.

[annotations]:/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/
[headers-annotation]:/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/#konghqcomheaders
