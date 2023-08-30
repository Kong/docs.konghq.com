## Deploy the {{site.kic_product_name}} {#deploy-kic}

You can deploy the {{site.kic_product_name}} on minikube using `kubectl` or `Helm Charts`:

{% if_version gte:2.8.x %}
{% navtabs codeblock %}
{% navtab kubectl %}
```bash
$ kubectl create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ include.version }}/deploy/single/all-in-one-dbless.yaml
```
{% endnavtab %}
{% navtab Helm Charts %}
```bash
$ helm repo add kong https://charts.konghq.com
$ helm repo update

# Helm 3
$ helm install kong/kong --generate-name
```
{% endnavtab %}
{% endnavtabs %}

{% endif_version %}


{% if_version lte:2.7.x %}
{% navtabs codeblock %}
{% navtab kubectl %}
```bash
$ kubectl create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.version }}/deploy/single/all-in-one-dbless.yaml
```
{% endnavtab %}
{% navtab Helm Charts %}
```bash
$ helm repo add kong https://charts.konghq.com
$ helm repo update

# Helm 3
$ helm install kong/kong --generate-name
```
{% endnavtab %}
{% endnavtabs %}

{% endif_version %}

The output is similar to:
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

