{% unless include.disable_accordian %}
<details markdown="1">
<summary>
  <strong>Prerequisites:</strong> Install the {{site.kgo_product_name}} in your Kubernetes cluster{% if include.aiGateway %} with AI Gateway support enabled.{% endif %}{% if include.kongPluginInstallation %} with KongPluginInstallation support enabled.{% endif %}{% if include.kconfCRDs %} with Kong's Kubernetes Configuration CRDs enabled.{% endif %} {% if include.enterprise %}This guide requires an enterprise license.{% endif %}
</summary>

## Prerequisites
{% endunless %}

{% if include.install_crds %}
{% assign gwapi_version = "1.2.1" %}
{% if_version eq:1.0.x %}
{% assign gwapi_version = "0.8.1" %}
{% endif_version %}
{% if_version gte:1.1.x lte:1.3.x %}
{% assign gwapi_version = "1.1.0" %}
{% endif_version %}
{% if_version gte:1.4.x lte:1.5.x %}
{% assign gwapi_version = "1.2.0" %}
{% endif_version %}
{% if_version gte:1.6.x %}
{% assign gwapi_version = "1.3.0" %}
{% endif_version %}
### Install CRDs

If you want to use Gateway API resources, run this command:

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v{{ gwapi_version }}/standard-install.yaml
```

{% if include.experimental %}
#### Gateway API experimental CRDs

If you want to use experimental resources and fields such as `TCPRoute`s and `UDPRoute`s, please run this command.

```shell
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v{{ gwapi_version }}/experimental-install.yaml
```
{% endif %}

{% if include.aiGateway %}
#### `AIGateway`

The `AIGateway` feature is an **alpha** release, and needs additional CRDs installed:

```bash
kubectl apply -f {{site.links.web}}/assets/gateway-operator/ai-gateway-crd.yaml --server-side
```
{% endif %}
{% endif %}

### Install {{ site.kgo_product_name }}

{% include snippets/gateway-operator/install_with_helm.md version=include.version release=include.release
    kconfCRDs=include.kconfCRDs
    konnectEntities=include.konnectEntities
    aiGateway=include.aiGateway
    kongPluginInstallation=include.kongPluginInstallation %}

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
