---
title: How to Install {{site.base_gateway}} with Helm
toc: true
content-type: how-to
---

This guide shows you how to build a {{site.base_gateway}} deployment on Kubernetes with Helm.

Two options are provided for deploying to local development environments which are tested to work on [Docker Desktop Kubernetes](https://docs.docker.com/desktop/kubernetes/) and [Kind Kubernetes](https://kind.sigs.k8s.io/). A third and more involved guide is also included which should help you deploy this implementation to a public cloud hosted kubernetes as well.

If deployed locally, Kong services will be published to localhost at the domain name `https://kong.127-0-0-1.nip.io`. The [nip.io](https://nip.io) service is used to automatically resolve this domain to the localhost address. 

## Choose one of the following 3 tabs to get started. 

{% navtabs %}
{% navtab Docker Desktop Kubernetes %}
## Docker Desktop

This path will guide you through deploying {{site.base_gateway}} to a local Docker Desktop Kubernetes cluster. Docker Desktop Kubernetes is a tool for running a local Kubernetes cluster in Docker Desktop.

With this guide you will deploy a Docker Desktop Kubernetes cluster and then use Helm to install {{site.base_gateway}}. Please ensure your local system meets the dependencies below before continuing.

## Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- [Docker Desktop Kubernetes](https://docs.docker.com/desktop/kubernetes/)

## Configure Kubectl

Set your kubeconfig context and verify with the following commands.

       kubectl config use-context docker-desktop && kubectl cluster-info

{% endnavtab %}
{% navtab Kind Kubernetes %}

## Kind Kubernetes

This path will guide you through deploying {{site.base_gateway}} to a local Kind Kubernetes cluster. Kind or "Kubernetes-in-Docker", is a tool for running local Kubernetes clusters in Docker containers.

With this guide you can deploy a Kind Kubernetes cluster and then use Helm to install {{site.base_gateway}}. Please ensure your local system meets the dependencies below before continuing.

## Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- [KinD](https://kind.sigs.k8s.io/)

## Create Kubernetes Cluster

A Kind config file is required to build a local cluster listening locally on ports `80` and `443`. Starting from the `bash` command, and ending with the `EOF"` line, highlight and copy this entire text block, then paste it into your terminal.

       bash -c "cat <<EOF > /tmp/kind-config.yaml && kind create cluster --config /tmp/kind-config.yaml
       apiVersion: kind.x-k8s.io/v1alpha4
       kind: Cluster
       name: kong
       networking:
         apiServerAddress: "0.0.0.0"
         apiServerPort: 16443
       nodes:
         - role: control-plane
           extraPortMappings:
           - listenAddress: "0.0.0.0"
             protocol: TCP
             hostPort: 80
             containerPort: 80
           - listenAddress: "0.0.0.0"
             protocol: TCP
             hostPort: 443
             containerPort: 443
       EOF"

Set your kubeconfig context and verify with the following commands.

        kubectl config use-context kind-kong && kubectl cluster-info

{% endnavtab %}
{% navtab Kubernetes in the Cloud%}

## Kubernetes in the Cloud

This path will guide you through deploying {{site.base_gateway}} to a cloud hosted Kubernetes cluster you have already built. Please ensure your local system and your Kubernetes cluster meet the dependency criteria listed below before continuing.

## Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- Domain Name
- DNS configured with your DNS Provider
- Public Cloud hosted Kubernetes cluster
- [Cloud LoadBalancer Support](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/)

## Configure Kubectl

Verify your kubeconfig context is set correctly with the following command.

       kubectl cluster-info

## Prepare your Kong Helm Chart values.yaml
We will need to inject your custom Domain Name into the Helm Values file we will configure the {{site.base_gateway}} deployment with.

1. Curl down the example values.yaml file.

       curl -o ~/quickstart.yaml -L https://bit.ly/KongGatewayHelmValuesAIO

2. Replace 'example.com' with your preferred domain name and export as a variable.

       export BASE_DOMAIN="example.com"

3. Replace the `127-0-0-1.nip.io` base domain in the values file with your preferred domain name.

       sed -i "s/127-0-0-1\.nip\.io/$BASE_DOMAIN/g" ~/quickstart.yaml

{% endnavtab %}
{% endnavtabs %}

## Create {{site.base_gateway}} Secrets

Configuring {{site.base_gateway}} requires a namespace and configuration secrets. The secrets contain Kong's enterprise license, admin password, session configurations, and PostgreSQL connection details.

1. Create the Kong namespace for {{site.base_gateway}}:

       kubectl create namespace kong

2. Create Kong config & credential variables:

       kubectl create secret generic kong-config-secret -n kong \
           --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_samesite":"off","cookie_secure":false}' \
           --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"admin_session","cookie_samesite":"off","cookie_secure":false}' \
           --from-literal=pg_host="enterprise-postgresql.kong.svc.cluster.local" \
           --from-literal=kong_admin_password=kong \
           --from-literal=password=kong

4. Create Kong Enterprise license secret:

{% navtabs %}
{% navtab Kong Enterprise Free Mode%}

       kubectl create secret generic kong-enterprise-license --from-literal=license="'{}'" -n kong --dry-run=client -o yaml | kubectl apply -f -

{% endnavtab %}
{% navtab Kong Enterprise licensed Mode%}

   >This command must be run in the directory that contains your `license.json` file.

       kubectl create secret generic kong-enterprise-license --from-file=license=license.json -n kong --dry-run=client -o yaml | kubectl apply -f -

{% endnavtab %}
{% endnavtabs %}

{:.note}
> Kong can run in two license modes, Enterprise Licensed, or Enterprise Free. If you would like to run all enterprise features, please contact your account manager to request a `license.json` file.

## Install Cert Manager

Cert Manager provides automation for generating SSL certificates. This Kong deployment will use Cert Manager to provide several required certificates.

We use the [SelfSigned](https://cert-manager.io/docs/configuration/selfsigned/) issuer for this example. You can replace this self signed issuer with your own [CA issuer](https://cert-manager.io/docs/configuration/ca/), [ACME LetsEncrypt issuer](https://cert-manager.io/docs/configuration/external/), or other [external issuers](https://cert-manager.io/docs/configuration/external/) to get valid certificates for {{site.base_gateway}}.

Install Cert Manager and create a basic SelfSigned certificate issuer:

1. Add the Jetstack Cert Manager Helm repository:

       helm repo add jetstack https://charts.jetstack.io ; helm repo update

2. Install Cert Manager:

       helm upgrade --install cert-manager jetstack/cert-manager \
           --set installCRDs=true --namespace cert-manager --create-namespace

3. Create a SelfSigned certificate issuer:

       bash -c "cat <<EOF | kubectl apply -n kong -f -
       apiVersion: cert-manager.io/v1
       kind: Issuer
       metadata:
         name: quickstart-kong-selfsigned-issuer-root
       spec:
         selfSigned: {}
       ---
       apiVersion: cert-manager.io/v1
       kind: Certificate
       metadata:
         name: quickstart-kong-selfsigned-issuer-ca
       spec:
         commonName: quickstart-kong-selfsigned-issuer-ca
         duration: 2160h0m0s
         isCA: true
         issuerRef:
           group: cert-manager.io
           kind: Issuer
           name: quickstart-kong-selfsigned-issuer-root
         privateKey:
           algorithm: ECDSA
           size: 256
         renewBefore: 360h0m0s
         secretName: quickstart-kong-selfsigned-issuer-ca
       ---
       apiVersion: cert-manager.io/v1
       kind: Issuer
       metadata:
         name: quickstart-kong-selfsigned-issuer
       spec:
         ca:
           secretName: quickstart-kong-selfsigned-issuer-ca
       EOF"

## Deploy {{site.base_gateway}}

{:.important}
> The following 3 steps are temporary development steps and will be removed from the guide.
> These steps are required to access the helm-chart before it is released with Kong 3.0.

1. `git clone https://github.com/Kong/charts ~/kong-charts-helm-project`
2. `cd ~/kong-charts-helm-project/charts/kong`
3. `helm dependencies update`
{% navtabs %}
{% navtab Docker Desktop Kubernetes %}

Once all dependencies are installed and ready, deploy {{site.base_gateway}} to your cluster:

1. Add the Kong Helm Repo:

       helm repo add kong https://charts.konghq.com ; helm repo update

2. Install Kong:

       helm install quickstart --namespace kong --values https://bit.ly/KongGatewayHelmValuesAIO ./

3. Wait for all pods to be in the `Running` state:

       kubectl get po --namespace kong -w

4. Once all pods are running, open Kong Manager in your browser over https at it's ingress host domain, for example: [https://kong.127-0-0-1.nip.io](https://kong.127-0-0-1.nip.io). Or open it with the following command:

       open "https://$(kubectl get ingress --namespace kong quickstart-kong-manager -o jsonpath='{.spec.tls[0].hosts[0]}')"

    {:.important}
    > You will receive a "Your Connection is not Private" warning message due to using selfsigned certs. If you are using Chrome there may not be an "Accept risk and continue" option, to continue type `thisisunsafe` while the tab is in focus to continue.

5. If running {{site.base_gateway}} in Licensed Mode, use the Super Admin username with the password set in the secret `kong-config-secret` created earlier: `kong_admin`:`kong`

{% endnavtab %}
{% navtab Kind Kubernetes %}

Once all dependencies are installed and ready, deploy {{site.base_gateway}} to your cluster:

1. Add the Kong Helm Repo:

       helm repo add kong https://charts.konghq.com ; helm repo update

2. Install Kong:

       helm install quickstart --namespace kong --values https://bit.ly/KongGatewayHelmValuesAIO ./

3. Wait for all pods to be in the `Running` state:

       kubectl get po --namespace kong -w

4. Once all pods are running, open Kong Manager in your browser over https at it's ingress host domain, for example: [https://kong.127-0-0-1.nip.io](https://kong.127-0-0-1.nip.io). Or open it with the following command:

       open "https://$(kubectl get ingress --namespace kong quickstart-kong-manager -o jsonpath='{.spec.tls[0].hosts[0]}')"

    {:.important}
    > You will receive a "Your Connection is not Private" warning message due to using selfsigned certs. If you are using Chrome there may not be an "Accept risk and continue" option, to continue type `thisisunsafe` while the tab is in focus to continue.

5. If running {{site.base_gateway}} in Licensed Mode, use the Super Admin username with the password set in the secret `kong-config-secret` created earlier: `kong_admin`:`kong`

{% endnavtab %}
{% navtab Kubernetes in the Cloud%}

Once all dependencies are installed and ready, deploy {{site.base_gateway}} to your cluster:

1. Add the Kong Helm Repo:

       helm repo add kong https://charts.konghq.com ; helm repo update

2. Install Kong:

       helm install quickstart --namespace kong --values ~/quickstart.yaml ./

3. Wait for all pods to be in the `Running` state:

       kubectl get po --namespace kong -w

4. Once all pods are running, find the Cloud Loadbalancer of your Kong Gateway Dataplane:

       kubectl get svc --namespace kong quickstart-kong-proxy -w

5. Using your DNS Provider, configure DNS entry to point to the LoadBalancer shown by the last step. A wildcard DNS record is recommended for development environments.

6. Now you should be able to open Kong Manager with the kong subdomain on your domain. For example: [https://kong.example.com](https://kong.example.com) Or open it with the following command:

       open "https://$(kubectl get ingress --namespace kong quickstart-kong-manager -o jsonpath='{.spec.tls[0].hosts[0]}')"

    {:.important}
    > You will receive a "Your Connection is not Private" warning message due to using selfsigned certs. If you are using Chrome there may not be an "Accept risk and continue" option, to continue type `thisisunsafe` while the tab is in focus to continue.

7. If running {{site.base_gateway}} in Licensed Mode, use the Super Admin username with the password set in the secret `kong-config-secret` created earlier: `kong_admin`:`kong`

{% endnavtab %}
{% endnavtabs %}

## Use {{site.base_gateway}}

With this deployment, your Kong Gateway should now be serving the Kong Manager WebGUI and the Kong Admin API.

For local deploys, Kong Manager will be locally accessible at `https://kong.127-0-0-1.nip.io`. The [nip.io](https://nip.io) service resolves this domain to localhost also known as `127.0.0.1`.

You can configure Kong via the Admin API with [decK](https://docs.konghq.com/deck/latest/), [Insomnia](https://docs.insomnia.rest/insomnia/get-started), HTTPie, or cURL, at [https://kong.127-0-0-1.nip.io/api](https://kong.127-0-0-1.nip.io/api)

{% navtabs codeblock %}
{% navtab cURL %}

       curl --silent --insecure -X GET https://kong.127-0-0-1.nip.io/api -H 'kong-admin-token:kong'

{% endnavtab %}
{% navtab HTTPie %}

       http --verify=no get https://kong.127-0-0-1.nip.io/api kong-admin-token:kong

{% endnavtab %}
{% endnavtabs %}

## Teardown 

{% navtabs %}
{% navtab Docker Desktop Kubernetes %}

The following steps can be used to uninstall {{site.base_gateway}} from your system.

1. Remove Kong

       helm uninstall --namespace kong quickstart

2. Delete Kong secretes 

       kubectl delete secrets -nkong kong-enterprise-license
       kubectl delete secrets -nkong kong-config-secret

3. Remove Kong database PVC

       kubectl delete pvc -n kong data-quickstart-postgresql-0

4. Remove Kong Helm Chart Repository
  
       helm repo remove kong

5. Remove cert-manager
  
       helm uninstall --namespace cert-manager cert-manager

6. Remove jetstack cert-manager Helm Repository

       helm repo remove jetstack

{% endnavtab %}
{% navtab Kind Kubernetes %}

The following steps can be used to uninstall {{site.base_gateway}} from your system.

1. Remove Kong

       helm uninstall --namespace kong quickstart

2. Delete Kong secretes

       kubectl delete secrets -nkong kong-enterprise-license
       kubectl delete secrets -nkong kong-config-secret

3. Remove Kong database PVC

       kubectl delete pvc -n kong data-quickstart-postgresql-0

4. Remove Kong Helm Chart Repository
  
       helm repo remove kong

5. Remove cert-manager
  
       helm uninstall --namespace cert-manager cert-manager

6. Remove jetstack cert-manager Helm Repository

       helm repo remove jetstack

7. Destroy the Kind Cluster
  
       kind delete cluster --name=kong
       rm /tmp/kind-config.yaml 

{% endnavtab %}
{% navtab Kubernetes in the Cloud%}

The following steps can be used to uninstall {{site.base_gateway}} from your system.

1. Remove Kong

       helm uninstall --namespace kong quickstart

2. Delete Kong secretes

       kubectl delete secrets -nkong kong-enterprise-license
       kubectl delete secrets -nkong kong-config-secret

3. Remove Kong database PVC

       kubectl delete pvc -n kong data-quickstart-postgresql-0

4. Remove Kong Helm Chart Repository
  
       helm repo remove kong

5. Remove cert-manager
  
       helm uninstall --namespace cert-manager cert-manager

6. Remove jetstack cert-manager Helm Repository

       helm repo remove jetstack

{% endnavtab %}
{% endnavtabs %}

## Conclusion

See the [Kong Ingress Controller docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
