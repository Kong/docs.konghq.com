## Deploy the {{site.kic_product_name}} {#deploy-kic}

You can deploy the {{site.kic_product_name}} using `kubectl` or `Helm`:

{% assign version = include.version | default: page.version %}

{% navtabs codeblock %}
{% navtab kubectl %}
```bash
$ kubectl create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ version }}/deploy/single/all-in-one-dbless.yaml
```
{% endnavtab %}
{% navtab Helm Charts %}
```bash
helm repo add kong https://charts.konghq.com
helm repo update
helm install kong kong/ingress
```
{% endnavtab %}
{% endnavtabs %}

The results should look like this:
```bash
namespace/kong created
customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongcredentials.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
serviceaccount/kong-serviceaccount created
clusterrole.rbac.authorization.k8s.io/kong-ingress-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-clusterrole-nisa-binding created
configmap/kong-server-blocks created
service/kong-proxy created
service/kong-validation-webhook created
deployment.extensions/kong created
```
*Note:* this process could take up to five minutes the first time.

