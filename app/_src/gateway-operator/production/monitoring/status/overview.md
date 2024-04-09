---
title: Overview
---

Not unlike other Kubernetes objects, those managed by {{ site.kgo_product_name }} also provide the `status` field.
This field provides invaluable information about the current state of the object.

Typically, to obtain object's status you can use the `kubectl get` command like so:

```bash
kubectl get <TYPE> <NAME> -o jsonpath-as-json='{.status}'
```

The above command will yield a json object which depends on the actual schema of the status field and the state of the object.

To learn more about `status` field of {{ site.kgo_product_name }} managed objects pick one of them from the menu on the left.
