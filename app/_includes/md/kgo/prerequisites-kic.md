{% unless include.disable_accordian %}
<details class="custom" markdown="1">
<summary>
<blockquote class="note">
  <p style="cursor: pointer">Before you begin ensure that you have <u>installed the {{site.kgo_product_name}}</u> in your Kubernetes cluster {% if include.aiGateway %}with AI Gateway support enabled{% endif %}. {% if include.enterprise %}This guide requires an enterprise license.{% endif %}</p>
</blockquote>
</summary>

## Prerequisites
{% endunless %}

### Install CRDs
{% assign gwapi_version = "1.0.0" %}
{% if include.release.value == "1.0.x" %}
{% assign gwapi_version = "0.8.1" %}
{% endif %}

{% if include.experimental %}
If you want to use experimental resources and fields such as `TCPRoute`s and `UDPRoute`s, please run this command.

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v{{ gwapi_version }}/experimental-install.yaml
```
{% endif %}

{% if include.aiGateway %}
The `AIGateway` feature is an **alpha** release, and needs additional CRDs installed:

```bash
kubectl apply -f {{site.links.web}}/assets/gateway-operator/ai-gateway-crd.yaml --server-side
```
{% endif %}

### Install {{ site.kgo_product_name }}

{% include snippets/gateway-operator/install_with_helm.md version=include.version release=include.release aiGateway=include.aiGateway %}

{% if include.enterprise %}

### Enterprise License

{:.note}
> **Note:** This is an enterprise feature. In order to use it you'll need a [license](/gateway-operator/{{ page.release }}/license/)
> installed in your cluster so that {{ site.kgo_product_name }} can consume it.

```yaml
echo "
apiVersion: configuration.konghq.com/v1alpha1
kind: KongLicense
metadata:
  name: kong-license
rawLicenseString: '$(cat ./license.json)'
" | kubectl apply -f -
```
{% endif %}

{% unless include.disable_accordian %}
</details>
{% endunless %}
