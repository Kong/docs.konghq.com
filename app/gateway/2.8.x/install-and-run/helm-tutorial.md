---
title: Kong Gateway Production Tutorial
toc: Tutorial
---

This 
The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

# Linking

[Relative Link](/gateway/{{page.kong_version}}/install-and-run/helm-quickstart-enterprise)

[Link to a heading](/gateway/{{page.kong_version}}/install-and-run/helm-quickstart-enterprise/#install-cert-manager)

[link to something not in this section](/deck/latest/installation/#prerequisites)

{% navtabs %}
{% navtab Docker Desktop Kubernetes %}


## Docker Instruction
## Docker Pre Reqs Prerequisites 

## Install Cert Manager 

Cert Manager provides automation for generating ssl certificates. This Kong deployment will use Cert Manager to provide several required certs.

Once Docker Desktop Kubernetes is enabled, install dependencies: 

1. Add the Jetstack Cert Manager Helm repository:

        helm repo add jetstack https://charts.jetstack.io ; helm repo update

2. Install Cert Manager:
        
        helm upgrade --install cert-manager jetstack/cert-manager \
            --set installCRDs=true --namespace cert-manager --create-namespace

## Configure Kong Gateway


## Uninstall 

The following steps can be used to uninstall Kong Gateway. 

### Remove Kong

`helm uninstall --namespace kong enterprise`

### Delete Kong secretes

1. `kubectl delete secrets -nkong kong-enterprise-license`
2. `kubectl delete secrets -nkong kong-config-secret`

### Remove Kong Database PVC

`kubectl delete pvc -nkong data-enterprise-postgresql-0`

### Clean Up

```sh
# Remove Kong
helm uninstall --namespace kong enterprise

# Delete Kong secrets
kubectl delete secrets -nkong kong-enterprise-license
kubectl delete secrets -nkong kong-config-secret

# Remove Kong Database PVC
kubectl delete pvc -nkong data-enterprise-postgresql-0

# Remove Kong Helm Chart Repository
helm repo remove kong
### Clean Up

```sh
# Remove Kong
helm uninstall --namespace kong enterprise

# Delete Kong secrets
kubectl delete secrets -nkong kong-enterprise-license
kubectl delete secrets -nkong kong-config-secret

# Remove Kong Database PVC
kubectl delete pvc -nkong data-enterprise-postgresql-0

# Remove Kong Helm Chart Repository
helm repo remove kong

# Remove cert-manager
helm uninstall --namespace kong cert-manager

# Remove jetstack cert-manager Helm Repository
helm repo remove jetstack

# Remove Kong Helm Chart PR 592
rm -rf ~/kong-charts-helm-project
```
-

{% endnavtab %}
{% endnavtabs %}

You can use the Kong Admin API with Insomnia, HTTPie, or cURL, at [https://kong.127-0-0-1.nip.io/api](https://kong.127-0-0-1.nip.io/api)

{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl --insecure -i -X GET https://kong.127-0-0-1.nip.io/api -H 'kong-admin-token:kong'
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http --verify=no get https://kong.127-0-0-1.nip.io/api kong-admin-token:kong
```
{% endnavtab %}
{% endnavtabs %}


## Conclusion

See the [Kong Ingress Controller docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
