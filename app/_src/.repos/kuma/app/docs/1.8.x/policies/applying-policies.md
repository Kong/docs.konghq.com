---
title: Applying Policies
---

Once installed, Kuma can be configured via its policies. You can apply policies with [`kumactl`](/docs/{{ page.version }}/explore/cli) on Universal, and with `kubectl` on Kubernetes. Regardless of what environment you use, you can always read the latest Kuma state with [`kumactl`](/docs/{{ page.version }}/explore/cli) on both environments.

{% tip %}
We follow the best practices. You should always change your Kubernetes state with CRDs, that's why Kuma disables `kumactl apply [..]` when running in K8s environments.
{% endtip %}

These policies can be applied either by file via the `kumactl apply -f [path]` or `kubectl apply -f [path]` syntax, or by using the following command:

```sh
echo "
  type: ..
  spec: ..
" | kumactl apply -f -
```

or - on Kubernetes - by using the equivalent:

```sh
echo "
  apiVersion: kuma.io/v1alpha1
  kind: ..
  spec: ..
" | kubectl apply -f -
```

Below you can find the policies that Kuma supports. In addition to [`kumactl`](/docs/{{ page.version }}/explore/cli), you can also retrieve the state via the Kuma [HTTP API](/docs/{{ page.version }}/reference/http-api) as well.
