---
title: Production usage values
---

To install a production-ready {{site.mesh_product_name}}, care must be taken in multiple areas to ensure the service mesh is secure, reliable, and performant. When deploy {{site.mesh_product_name}} on Kubernetes, please use the provided values here to deploy your {{site.mesh_product_name}} installation.

Please note that values list in this page are meant to be a starting point for your installation, it's always recommended to read the full [reference of helm configuration](/mesh/{{ page.release }}/reference/kuma-cp/#helm-valuesyaml) to find supports for other options available before executing the install steps. These value will override the values in the default reference helm configuration, and they may be overridden again by further `values.yaml` files or `helm` command arguments. Please refer to [Helm documentation](https://helm.sh/docs/chart_template_guide/values_files/) to learn more about how values are calculated.

The `values.yaml` files here can be used as follows:

```sh
# Install a single-zone {{site.mesh_product_name}} control plane
helm install {{ site.mesh_helm_install_name }} {{ site.mesh_helm_repo }} --namespace {{site.mesh_namespace}} -f ./values.single-zone-cp.yaml

# Install the global control plane for a multi-zone {{site.mesh_product_name}} control plane
helm install {{ site.mesh_helm_install_name }} {{ site.mesh_helm_repo }} --namespace {{site.mesh_namespace}} -f ./values.global-cp.yaml

# Install a federated zone for the multi-zone {{site.mesh_product_name}} control plane
helm install {{ site.mesh_helm_install_name }} {{ site.mesh_helm_repo }} --namespace {{site.mesh_namespace}} -f ./values.federated-zone-cp.yaml \
  --set '{{site.set_flag_values_prefix}}controlPlane.zone=zone-prod' \
  --set '{{site.set_flag_values_prefix}}controlPlane.kdsGlobalAddress=kds-global.example.com'
```

The values in this page may reference resources that need to be created in advance when certain features are enabled, please read the value files carefully and prepare these resources according to notes near the `(action)` keywords. If you decide to disable the feature that require a resource to be pre-existing, please remove/change those fields according to the full [reference of helm configuration](/mesh/{{ page.release }}/reference/kuma-cp/#helm-valuesyaml).

Please choose one `values.yaml` file according to your installation scenario:


{% tabs values-yaml useUrlFragment=true %}
{% tab values-yaml single zone control plane %}
```yaml
{% embed helm-values-prod/values.single-zone-cp.yaml versioned %}
```
{% endtab %}

{% tab values-yaml global control plane %}
```yaml
{% embed helm-values-prod/values.global-cp.yaml versioned %}
```
{% endtab %}

{% tab values-yaml federated zone control plane %}
```yaml
{% embed helm-values-prod/values.federated-zone-cp.yaml versioned %}
```
{% endtab %}
{% endtabs %}
