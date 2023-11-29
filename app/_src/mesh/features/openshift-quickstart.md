---
title: Get started with Red Hat OpenShift and Kong Mesh
content_type: tutorial
description: This guide explains how to get started on Kong Mesh with Red Hat OpenShift.
---

In this guide, you will learn how to get {{site.mesh_product_name}} up and running quickly in standalone mode on [Red Hat OpenShift](https://www.redhat.com/technologies/cloud-computing/openshift). This tutorial assumes some base-level OpenShift knowledge.

This tutorial doesn't require a license because {{site.mesh_product_name}} can start in evaluation mode, which allows you to have up to five data planes or sidecars. This provides just enough data planes to get comfortable with the product and test it out.

This quickstart tutorial covers:

* How to use the Red Hat Certified {{site.mesh_product_name}} Images
* How to implement the required OpenShift security context constraints (SCCs) for the `kong-mesh` sidecar
* How to deploy {{site.kic_product_name}} in [standalone mode](/mesh/{{page.kong_version}}/production/deployment/stand-alone/)
* How to deploy and join the {{site.kic_product_name}} (KIC) to the mesh
* How to deploy a sample application, bookinfo, on the mesh and validate that the application is working
* How to use the sample application to test the features of {{site.mesh_product_name}}

## Prerequisites
* [ROSA CLI installed](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa_getting_started_iam/rosa-installing-rosa.html) or another OpenShift 4.12 cluster with the ability to create LoadBalancer type Kubernetes Services
* [kubectl CLI installed](https://kubernetes.io/docs/tasks/tools/)
* [OpenShift CLI installed](https://docs.openshift.com/container-platform/4.11/cli_reference/openshift_cli/getting-started-cli.html)
* [Helm 3 installed](https://helm.sh/docs/intro/install/)

## Install ROSA

In this section, you will install a ROSA cluster called `kong-mesh-2` in the `us-west-2` region. Then, you'll create an admin user to get quick access to the cluster. 

1. Create system variables for the cluster name and region:
    ```bash
    CLUSTER_NAME=kong-mesh-2
    REGION=us-west-2
    ```

1. Create a small ROSA cluster:
    ```bash
    rosa create cluster --cluster-name=$CLUSTER_NAME --region=$REGION --multi-az=false --version 4.12.13
    ```

1. When the cluster install is complete, create a cluster-admin user:
    ```bash
    rosa create admin --cluster $CLUSTER_NAME
    ```
    Creating an admin user gives you quick access to the cluster for this quickstart. We recommend using a formal identity provider that you grant admin privileges to in a production environment.

1. Validate you can log in to the cluster via the credentials provided by the ROSA CLI `stout`. Once you successfully login, you can proceed to the next section.

## Install {{site.mesh_product_name}} in standalone mode

In this section, you'll install {{site.mesh_product_name}} in standalone mode. Standalone mode is used in this quickstart for simplicity. 

1. Create the `kong-mesh-system` namespace:
    ```bash
    kubectl create namespace kong-mesh-system
    ```

1. Create the image pull secret:
    ```bash
    kubectl create secret docker-registry rh-registry-secret -n kong-mesh-system \
        --docker-server=registry.connect.redhat.com \
        --docker-username=<username> \
        --docker-password=<password> \
        --docker-email=<email>
    ```

    Doing this allows you to authenticate so you can pull down the images from Red Hat's repository.

1. Add `nonroot-v2` to job service accounts so that each of their Kubernetes jobs successfully runs:
    ```bash
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-install-crds
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-patch-ns-job 
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-pre-delete-job
    ```

1. Get the latest helm chart:
    ```bash
    helm repo add kong-mesh https://kong.github.io/kong-mesh-charts
    ```

1. Install {{site.mesh_product_name}}:
    ```bash
    helm upgrade -i kong-mesh kong-mesh/kong-mesh -f kong-mesh/values.yaml -n kong-mesh-system
    ```

1. In a new terminal window, port-forward to reach the {{site.mesh_product_name}} GUI:
    ```bash
    kubectl port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681:5681
    ```

    You should be able to reach the {{site.mesh_product_name}} UI at `http://localhost:5681/gui`.


1. Finally, you must do some prep work for the sidecar itself so sidecars will startup successfully. Apply the `kong-mesh-sidecar` SCCs and corresponding container patches:
    ```bash
    kubectl create -f kong-mesh/kong-mesh-sidecar-scc.yaml
    kubectl apply -f kong-mesh/container-patch.yaml 
    ```

    In OpenShift, by default, all pods and containers are given the restricted SCC. This is insufficient for the {{site.mesh_product_name}} sidecars (containers). The sidecars need a slightly escalated permissions, these permissions are defined in the `kong-mesh-sidecar-scc` manifest. The `container-patch` file defines how to patch the sidecars with the SCCs.

## Deploy KIC on {{site.mesh_product_name}}

In this section, you'll deploy KIC. Why??

1. Deploy KIC as your ingress controller:
    ```bash
    kubectl create namespace kong 
    kubectl label namespace kong kuma.io/sidecar-injection=enabled
    oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:kong:kong-kong
    ```

1. Get the latest Helm chart:
    ```bash
    helm repo add kong https://charts.konghq.com
    helm repo update
    ```

1. Install ? What is this installing? Kong Gateway?:
    ```bash
    helm install kong kong/kong -n kong \
    --set ingressController.installCRDs=false \
    --set podAnnotations."kuma\.io/mesh"=default \
    --set podAnnotations."kuma\.io/gateway"=enabled
    export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" service -n kong kong-kong-proxy)
    curl -i $PROXY_IP
    ```

    The expected output is:
    ```json
    HTTP/1.1 404 Not Found
    Date: Tue, 02 May 2023 15:40:05 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 48
    X-Kong-Response-Latency: 0
    Server: kong/3.2.2

    {"message":"no Route matched with those values"}%
    ```

## Deploy Bookinfo

1. Allow all the service accounts to use the kong-mesh-sidecar scc:
    ```bash
    oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:bookinfo:bookinfo-details
    oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:bookinfo:bookinfo-productpage
    oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:bookinfo:bookinfo-ratings
    oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:bookinfo:bookinfo-reviews
    ```

1. Next, deploy bookinfo. This bookinfo app has been paired down to work with {{site.mesh_product_name}} in evaluation mode. We only have 5 sidecars we can deploy on evaluation mode is all.
    ```bash
    kubectl create namespace bookinfo
    kubectl label namespace bookinfo kuma.io/sidecar-injection=enabled
    kubectl apply -f bookinfo/bookinfo.yaml -n bookinfo
    ```

1. Last we want to create an ingress resource to expose bookinfo to the outside world.
    ```bash
    kubectl apply -f bookinfo/ingress-productpage.yaml -n bookinfo
    ```

1. Now! Validate it's all up and running. Navigate to your browswer to `http://$PROXY_IP/productpage` and you should be able to see productpage with a majority of the bells and whistles.

## List of things to try now that the demo is installed, just as a jumping off point and then the customers can further their own research/testing

## Clean Up 

1. Tear Down bookinfo:
    ```bash
    kubectl delete deploy,svc,ingress --all -n bookinfo
    ```

1. Tear Down KIC:
    ```bash
    helm uninstall kong -n kong
    ```

1. Last Tear Down {{site.mesh_product_name}}:
    ```bash
    helm uninstall kong-mesh -n kong-mesh-system
    ```
    And all the components should be down! It's safe to destroy the ROSA cluster.

1. Delete the ROSA cluster-admin user:
    ```bash
    rosa delete admin --cluster $CLUSTER_NAME
    ```

1. Delete ROSA cluster:
    ```bash
    rosa delete cluster --cluster $CLUSTER_NAME
    ```



