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
helm install kong kong/ingress -n kong --create-namespace
```
{% endnavtab %}
{% endnavtabs %}


The results should look like this:

{% navtabs codeblock %}
{% navtab kubectl %}

```bash
   namespace/kong created
   customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
   customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
   customresourcedefinition.apiextensions.k8s.io/kongcredentials.configuration.konghq.com created
   customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
   serviceaccount/kong-serviceaccount created
   clusterrole.rbac.authorization.k8s.io/kong-ingress-clusterrole created
   clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-clusterrole-nisa-binding created
   service/kong-proxy created
   service/kong-validation-webhook created
   deployment.apps/ingress-kong created
   deployment.apps/proxy-kong created
   ingressclass.networking.k8s.io/kong created
```

{% endnavtab %}
{% navtab Helm Charts %}

```bash
NAME: kong
LAST DEPLOYED: Tue Oct  3 15:12:38 2023
NAMESPACE: kong
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
{% endnavtab %}
{% endnavtabs %}


*Note:* this process could take up to five minutes the first time.

