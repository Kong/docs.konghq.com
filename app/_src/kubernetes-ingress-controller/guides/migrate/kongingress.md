---
title: Removing KongIngress
---

## konghq.com/headers.* annotation

The [`konghq.com/headers.*` annotation][headers-annotation] uses a special
format to set headers. The string after the `.` in the annotation name is the
header name and the annotation value is the header value. For example, to apply
`x-custom-header-a: example,otherexample` and `x-custom-header-b: example`
headers to requests, KongIngress configuration would look like:

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

Note that you cannot apply multiple instances of the same header annotation to
set multiple header values: you must set the CSV format within a single header.

## KongUpstreamPolicy

The `upstream` section of KongIngress resources contains a complex object that does not easily fit in annotations. 3.x uses the new KongUpstreamPolicy resource to configure upstream settings. The `spec` field of KongUpstreamPolicy is the same as the `upstream` section of KongIngress. For example, if you previously used a KongIngress like:

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

You will now use a KongUpstreamPolicy like:

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

[annotations]:https://docs.konghq.com/kubernetes-ingress-controller/2.12.x/references/annotations/
[headers-annotation]:https://docs.konghq.com/kubernetes-ingress-controller/2.12.x/references/annotations/#konghqcomheaders
