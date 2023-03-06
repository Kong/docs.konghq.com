## Deploy the {{site.kic_product_name}} {#deploy-kic}

Deploy the {{site.kic_product_name}} using `kubectl`:

{% if_version gte:2.8.x %}
```bash
$ kubectl create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ include.version }}/deploy/single/all-in-one-dbless.yaml
namespace/kong created
customresourcedefinition.apiextensions.k8s.io/ingressclassparameterses.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongclusterplugins.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/tcpingresses.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/udpingresses.configuration.konghq.com created
serviceaccount/kong-serviceaccount created
role.rbac.authorization.k8s.io/kong-leader-election created
clusterrole.rbac.authorization.k8s.io/kong-ingress created
clusterrole.rbac.authorization.k8s.io/kong-ingress-gateway created
clusterrole.rbac.authorization.k8s.io/kong-ingress-knative created
rolebinding.rbac.authorization.k8s.io/kong-leader-election created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-gateway created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-knative created
service/kong-admin created
service/kong-proxy created
service/kong-validation-webhook created
deployment.apps/ingress-kong created
deployment.apps/proxy-kong created
ingressclass.networking.k8s.io/kong created
```
{% endif_version %}
{% if_version lte:2.7.x %}
```bash
$ kubectl create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.version }}/deploy/single/all-in-one-dbless.yaml
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
{% endif_version %}

It will take a few minutes for all containers to start and report
healthy status.

Alternatively, you can use our helm chart as well:

```bash
$ helm repo add kong https://charts.konghq.com
$ helm repo update

# Helm 3
$ helm install kong/kong --generate-name --set ingressController.installCRDs=false
```

*Note:* this process could take up to five minutes the first time.
