---
title: Credential Type Labels
---

In versions before 3.0, credential Secrets used a `kongCredType` field in the Secret to indicate the Secret type. Version 3.0 replaces this field with a `konghq.com/credential` label to allow the admission controller and resource cache to filter out Secrets that {{ site.kic_product_name }} do not use to improve performance and avoid interference with non-{{ site.kic_product_name }} Secret updates.

The `kongCredType` field is now deprecated and will be removed in a future release.

You can use a simple [jq][jq] and kubectl script to find your credential Secrets and generate commands to add an appropriate label:

```bash
kubectl get secret -A -ojson | jq -r '.items[] | select(.data.kongCredType != null) | "kubectl label secret -n \(.metadata.namespace) \(.metadata.name) konghq.com/credential=\(.data.kongCredType | @base64d )"'
```

Or, if you do not have access to all namespaces (replace `default other` with a space-separated list of namespaces to search):

```bash
for namespace in default other; do kubectl get secret -n $namespace -ojson | jq -r '.items[] | select(.data.kongCredType != null) | "kubectl label secret -n \(.metadata.namespace) \(.metadata.name) konghq.com/credential=\(.data.kongCredType | @base64d )"'; done
```

The output is a list of `kubectl` commands to copy and paste in order to apply the label. For example:

```bash
kubectl label secret -n default consumer-5-key-auth konghq.com/credential=key-auth
kubectl label secret -n other consumer-10-key-auth konghq.com/credential=bee-auth
```

You do not need to remove the `kongCredType` field from Secrets after you have
added the label, but once you have added the label, the value of the label is used instead of the field.

[jq]: https://jqlang.github.io/jq/
