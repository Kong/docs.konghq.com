---
title: Install with Kong Gateway using Helm
toc: true
content-type: how-to
---


This guide will show you how to install {{site.base_gateway}} on Kubernetes with Helm. Two options are provided for deploying a local development environment using [Docker Desktop Kubernetes](https://docs.docker.com/desktop/kubernetes/) and [Kind Kubernetes](https://kind.sigs.k8s.io/). You can also follow this guide using an existing cloud hosted Kubernetes cluster. 


{% navtabs %}
{% navtab Docker Desktop Kubernetes %}
## Docker Desktop

Docker Desktop Kubernetes is a tool for running a local Kubernetes cluster using Docker. These instructions will guide you through deploying {{site.base_gateway}} to a local Docker Desktop Kubernetes cluster.

## Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- [Docker Desktop Kubernetes](https://docs.docker.com/desktop/kubernetes/)

{:.note}
> [Kong Admin API](/gateway/{{page.kong_version}}/admin-api/) & [Kong Manager](/gateway/{{page.kong_version}}/kong-manager/) services will be published to `localhost` at the domain name `kong.127-0-0-1.nip.io`. The [nip.io](https://nip.io) service is used to automatically resolve this domain to the localhost address. 

## Configure Kubectl

Set your kubeconfig context and verify with the following command:

    kubectl config use-context docker-desktop && kubectl cluster-info


{% endnavtab %}
{% navtab Kind Kubernetes %}

## Kind Kubernetes

Kind or "Kubernetes-in-Docker", is a tool for running local Kubernetes clusters in Docker containers. These instructions will guide you through deploying {{site.base_gateway}} to a local Kind Kubernetes cluster.


## Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- [KinD](https://kind.sigs.k8s.io/)

{:.note}
> [Kong Admin API](/gateway/{{page.kong_version}}/admin-api/) & [Kong Manager](/gateway/{{page.kong_version}}/kong-manager/) services will be published to `localhost` at the domain name `kong.127-0-0-1.nip.io`. The [nip.io](https://nip.io) service is used to automatically resolve this domain to the localhost address. 

## Create Kubernetes Cluster

A Kind config file is required to build a local cluster listening locally on ports `80` and `443`. Starting from the `bash` command, and ending with the `EOF"` line, highlight and copy this text block, then paste it into your terminal.

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

## Kubernetes in the cloud

These instructions will guide you through deploying {{site.base_gateway}} to a cloud hosted Kubernetes cluster you have already built. Please ensure your local system and your Kubernetes cluster meet the dependency criteria listed below before continuing.

{:.note}
> Please note that it is recommended to first try the Docker Desktop or Kind Kubernetes local deploys before proceeding to build on a cloud hosted kubernetes cluster.

## Dependencies

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- Domain Name
- DNS configured with your DNS Provider
- Public Cloud hosted Kubernetes cluster
- [Cloud load balancer support](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/)

## Configure Kubectl

Verify your kubeconfig context is set correctly with the following command.

    kubectl cluster-info

## Prepare the Helm chart 

To inject your custom domain name into the Helm values file configure the {{site.base_gateway}} deployment with:

1. `curl` the example values.yaml file.

       curl -o ~/quickstart.yaml -L https://bit.ly/KongGatewayHelmValuesAIO

2. Replace `example.com` with your preferred domain name and export as a variable.

       export BASE_DOMAIN="example.com"

3. Find & replace the `127-0-0-1.nip.io` base domain in the values file with your preferred domain name.

{% navtabs %}
{% navtab MacOS%}

       sed -i '' "s/127-0-0-1\.nip\.io/$BASE_DOMAIN/g" ~/quickstart.yaml

{% endnavtab %}
{% navtab Linux%}

       sed -i "s/127-0-0-1\.nip\.io/$BASE_DOMAIN/g" ~/quickstart.yaml

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}

## Create {{site.base_gateway}} secrets

Configuring {{site.base_gateway}} requires a namespace and configuration secrets. The secrets contain Kong's enterprise license, admin password, session configurations, and PostgreSQL connection details.

1. Create the Kong namespace for {{site.base_gateway}}:

       kubectl create namespace kong

2. Create Kong config and credential variables:

       {% if_version lte:3.1.x %}

       kubectl create secret generic kong-config-secret -n kong \
           --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_samesite":"off","cookie_secure":false}' \
           --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"admin_session","cookie_samesite":"off","cookie_secure":false}' \
           --from-literal=pg_host="enterprise-postgresql.kong.svc.cluster.local" \
           --from-literal=kong_admin_password=kong \
           --from-literal=password=kong
       
       {% endif_version %}
       {% if_version gte:3.2.x %}

       kubectl create secret generic kong-config-secret -n kong \
           --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_same_site":"Lax","cookie_secure":false}' \
           --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"admin_session","cookie_same_site":"Lax","cookie_secure":false}' \
           --from-literal=pg_host="enterprise-postgresql.kong.svc.cluster.local" \
           --from-literal=kong_admin_password=kong \
           --from-literal=password=kong
       
       {% endif_version %}

4. Create a {{site.ee_product_name}} license secret:

{% navtabs %}
{% navtab Kong Gateway Enterprise Free Mode%}

    kubectl create secret generic kong-enterprise-license --from-literal=license="'{}'" -n kong --dry-run=client -o yaml | kubectl apply -f -

{% endnavtab %}
{% navtab Kong Gateway Enterprise Licensed Mode%}

   >This command must be run in the directory that contains your `license.json` file.

    kubectl create secret generic kong-enterprise-license --from-file=license=license.json -n kong --dry-run=client -o yaml | kubectl apply -f -

{% endnavtab %}
{% endnavtabs %}

{:.note}
> Kong can run in two license modes, Enterprise Licensed, or Enterprise Free. If you would like to run all enterprise features, please contact your account manager to request a `license.json` file.

## Install Cert Manager

[Cert Manager](https://cert-manager.io/docs/) provides automation for generating SSL certificates. {{site.base_gateway}} uses Cert Manager to provide the required certificates.



Install Cert Manager and create a basic [SelfSigned](https://cert-manager.io/docs/configuration/selfsigned/) certificate issuer:

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


You can replace this self signed issuer with your own [CA issuer](https://cert-manager.io/docs/configuration/ca/), [ACME LetsEncrypt issuer](https://cert-manager.io/docs/configuration/external/), or other [external issuers](https://cert-manager.io/docs/configuration/external/) to get valid certificates for {{site.base_gateway}}.

## Deploy {{site.base_gateway}}

{% navtabs %}
{% navtab Docker Desktop Kubernetes %}

Once all dependencies are installed and ready, deploy {{site.base_gateway}} to your cluster:

1. Add the Kong Helm repo:

       helm repo add kong https://charts.konghq.com ; helm repo update

2. Install Kong:

       helm install quickstart kong/kong --namespace kong --values https://bit.ly/KongGatewayHelmValuesAIO

3. Wait for all pods to be in the `Running` and `Completed` states:

       kubectl get po --namespace kong -w

4. Once all the pods are running, open Kong Manager in your browser at its ingress host domain, for example: [https://kong.127-0-0-1.nip.io](https://kong.127-0-0-1.nip.io). Or open it with the following command:

       open "https://$(kubectl get ingress --namespace kong quickstart-kong-manager -o jsonpath='{.spec.tls[0].hosts[0]}')"

    {:.important}
    > You will receive a "Your Connection is not Private" warning message due to using selfsigned certs. If you are using Chrome there may not be an "Accept risk and continue" option, to continue type `thisisunsafe` while the tab is in focus to continue.

5. If running {{site.base_gateway}} in Licensed Mode, use the Super Admin username with the password set in the secret `kong-config-secret` created earlier: `kong_admin`:`kong`

{% endnavtab %}
{% navtab Kind Kubernetes %}

Once all dependencies are installed and ready, deploy {{site.base_gateway}} to your cluster:

1. Add the Kong Helm repo:

       helm repo add kong https://charts.konghq.com ; helm repo update

2. Install Kong:

       helm install quickstart kong/kong --namespace kong --values https://bit.ly/KongGatewayHelmValuesAIO

3. Wait for all pods to be in the `Running` and `Completed` states:

       kubectl get po --namespace kong -w

4. Once all the pods are running, open Kong Manager in your browser at its ingress host domain, for example: [https://kong.127-0-0-1.nip.io](https://kong.127-0-0-1.nip.io). Or open it with the following command:

       open "https://$(kubectl get ingress --namespace kong quickstart-kong-manager -o jsonpath='{.spec.tls[0].hosts[0]}')"

    {:.important}
    > You will receive a "Your Connection is not Private" warning message due to using selfsigned certs. If you are using Chrome there may not be an "Accept risk and continue" option, to continue type `thisisunsafe` while the tab is in focus to continue.

5. If running {{site.base_gateway}} in Licensed Mode, use the Super Admin username with the password set in the secret `kong-config-secret` created earlier: `kong_admin`:`kong`

{% endnavtab %}
{% navtab Kubernetes in the Cloud%}

Once all dependencies are installed and ready, deploy {{site.base_gateway}} to your cluster:

1. Add the Kong Helm repo:

       helm repo add kong https://charts.konghq.com ; helm repo update

2. Install Kong:

       helm install quickstart kong/kong --namespace kong --values ~/quickstart.yaml

3. Wait for all pods to be in the `Running` and `Completed` states:

       kubectl get po --namespace kong -w

4. Once all pods are running, find the cloud load balancer of your {{site.base_gateway}} data plane:

       kubectl get svc --namespace kong quickstart-kong-proxy -w

5. Using your DNS Provider, configure a DNS entry to point to the load balancer shown by the last step. A wildcard DNS record is recommended for development environments.

6. Open Kong Manager with the kong subdomain on your domain. For example: `https://kong.example.com`, or open it with the following command:

       open "https://$(kubectl get ingress --namespace kong quickstart-kong-manager -o jsonpath='{.spec.tls[0].hosts[0]}')"

    {:.important}
    > You will receive a "Your Connection is not Private" warning message due to using selfsigned certs. If you are using Chrome there may not be an "Accept risk and continue" option, to continue type `thisisunsafe` while the tab is in focus to continue.

7. If running {{site.base_gateway}} in Licensed Mode, use the Super Admin username with the password set in the secret `kong-config-secret` created earlier: `kong_admin`:`kong`

{% endnavtab %}
{% endnavtabs %}

## Use {{site.base_gateway}}

{{site.base_gateway}} is now serving the [Kong Manager](/gateway/{{page.kong_version}}/kong-manager/) Web UI and the [Kong Admin API](/gateway/{{page.kong_version}}/admin-api/).

For local deployments, Kong Manager is locally accessible at `https://kong.127-0-0-1.nip.io`. The [nip.io](https://nip.io) service resolves this domain to localhost also known as `127.0.0.1`.

You can configure Kong via the Admin API with [decK](/deck/), [Insomnia](https://docs.insomnia.rest/insomnia/get-started), HTTPie, or cURL, at `https://kong.127-0-0-1.nip.io/api`:

    curl --silent --insecure -X GET https://kong.127-0-0-1.nip.io/api -H 'kong-admin-token:kong'


## Teardown 

{% navtabs %}
{% navtab Docker Desktop Kubernetes %}

To remove {{site.base_gateway}} from your system, follow these instructions:

1. Remove Kong

       helm uninstall --namespace kong quickstart

2. Delete Kong secrets 

       kubectl delete secrets -nkong kong-enterprise-license
       kubectl delete secrets -nkong kong-config-secret

3. Remove Kong database [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

       kubectl delete pvc -n kong data-quickstart-postgresql-0

4. Remove Kong Helm chart repository
  
       helm repo remove kong

5. Remove cert-manager
  
       helm uninstall --namespace cert-manager cert-manager

6. Remove jetstack cert-manager Helm repository

       helm repo remove jetstack

{% endnavtab %}
{% navtab Kind Kubernetes %}

To remove {{site.base_gateway}} from your system, follow these instructions:

1. Remove Kong

       helm uninstall --namespace kong quickstart

2. Delete Kong secrets

       kubectl delete secrets -nkong kong-enterprise-license
       kubectl delete secrets -nkong kong-config-secret

3. Remove Kong database [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

       kubectl delete pvc -n kong data-quickstart-postgresql-0

4. Remove Kong Helm chart repository
  
       helm repo remove kong

5. Remove cert-manager
  
       helm uninstall --namespace cert-manager cert-manager

6. Remove jetstack cert-manager Helm repository

       helm repo remove jetstack

7. Destroy the Kind cluster
  
       kind delete cluster --name=kong
       rm /tmp/kind-config.yaml 

{% endnavtab %}
{% navtab Kubernetes in the Cloud%}

To remove {{site.base_gateway}} from your system, follow these instructions:

1. Remove Kong

       helm uninstall --namespace kong quickstart

2. Delete Kong secrets

       kubectl delete secrets -nkong kong-enterprise-license
       kubectl delete secrets -nkong kong-config-secret

3. Remove Kong database [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)

       kubectl delete pvc -n kong data-quickstart-postgresql-0

4. Remove Kong Helm chart repository
  
       helm repo remove kong

5. Remove cert-manager
  
       helm uninstall --namespace cert-manager cert-manager

6. Remove jetstack cert-manager Helm Repository

       helm repo remove jetstack

{% endnavtab %}
{% endnavtabs %}

## Next Steps

See the [{{site.kic_product_name}} docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
