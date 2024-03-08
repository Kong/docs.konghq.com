{% unless include.disable_accordian %}
<details class="custom" markdown="1">
<summary>
<blockquote class="note">
  <p style="cursor: pointer">Before you begin ensure that you have <u>installed the {{site.kgo_product_name}}</u> in your Kubernetes cluster and are able to connect to Kong. {% if include.enterprise %}This guide requires an enterprise license.{% endif %}</p>
</blockquote>
</summary>

## Prerequisites
{% endunless %}

{% assign gwapi_version = "1.0.0" %}
{% if include.release.value == "1.0.x" %}
{% assign gwapi_version = "0.8.1" %}
{% endif %}

Below command installs all Gateway API resources that have graduated to GA or beta,
including `GatewayClass`, `Gateway`, `HTTPRoute`, and `ReferenceGrant`.

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v{{ gwapi_version }}/standard-install.yaml
```

If you want to use experimental resources and fields such as `TCPRoute`s and `UDPRoute`s, please run this command.

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v{{ gwapi_version }}/experimental-install.yaml
```

{% include snippets/gateway-operator/install_with_helm.md version=include.version release=include.release %}

{% if include.enterprise %}
{:.note}
> **Note:** This is an enterprise feature. In order to use it you'll need a [license](/gateway-operator/{{ page.release }}/license/)
> installed in your cluster so that {{ site.kgo_product_name }} can consume it.
{% endif %}

{% unless include.disable_accordian %}
</details>
{% endunless %}
