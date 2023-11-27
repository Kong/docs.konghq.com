---
title: Get started with Red Hat OpenShift and Kong Mesh
content_type: tutorial
description: This guide explains how to get started on Kong Mesh with Red Hat OpenShift.
---

This is a quickstart to get you up and running with Kong Mesh in standalone mode on OpenShift.

This tutorial does not require a license, Kong Mesh can start in evaluation mode, and limits you 5 dataplanes/sidecars to use. Just enough dataplanes to get comfortable with the product.

For OpenShfit, we'll be spinning up a ROSA 4.12 cluster. This tutorial does also assume some base level knowledge of OpenShift.

This tutorial will cover:

How to use the Red Hat Certified Kong Mesh Images
How to implement the required OpenShift SecurityContextConstraints (SCC) for the kong-mesh sidecar
Deploy and join the Kong for Kubernetes Ingress Controller (KIC) to the mesh
Deploy a sample application, bookinfo, on the mesh and validate it's all working
Fun! Let's do it!

## Prerequisites
* ROSA cli or another OpenShift 4.12 cluster with the ability to create LoadBalancer type Kubernetes Services
* kubectl cli
* oc cli
* Helm 3

## Install ROSA

1. Create System Variables:
    ```bash
    CLUSTER_NAME=kong-mesh-2
    REGION=us-west-2
    ```

1. Create a small ROSA cluster:
    ```bash
    rosa create cluster --cluster-name=$CLUSTER_NAME --region=$REGION --multi-az=false --version 4.12.13
    ```

1. When the Cluster install is complete, create a cluster-admin user:
    ```bash
    rosa create admin --cluster $CLUSTER_NAME
    ```

1. Validate you can login to the cluster via the credentials provided by the rosa cli stdout. Once login is successful you can proceed to the next step.

## Install Kong Mesh in Standalone Mode

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

1. Add nonroot-v2 to job service accounts:
    ```bash
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-install-crds
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-patch-ns-job 
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-pre-delete-job
    ```

1. Grab the latest helm chart:
    ```bash
    helm repo add kong-mesh https://kong.github.io/kong-mesh-charts
    ```

1. Install Kong Mesh:
    ```bash
    helm upgrade -i kong-mesh kong-mesh/kong-mesh --version 2.2.0 -f kong-mesh/values.yaml -n kong-mesh-system
    ```

1. Open a second terminal and port-forward to reach the mesh GUI:
    ```bash
    kubectl port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681:5681
    ```

    You should be able to reach the Kong-Mesh UI at `http://localhost:5681/gui`.


1. Last, do some prep work for the sidecar itself so sidecars will startup successfully. Apply the kong-mesh-sidecar scc and corresponding container patches:
    ```bash
    kubectl create -f kong-mesh/kong-mesh-sidecar-scc.yaml
    kubectl apply -f kong-mesh/container-patch.yaml 
    ```

## Deploy KIC on Mesh

1. First we're going to deploy KIC as our ingress controller:
    ```bash
    kubectl create namespace kong 
    kubectl label namespace kong kuma.io/sidecar-injection=enabled
    oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:kong:kong-kong
    ```

1. Grab the latest chart:
    ```bash
    helm repo add kong https://charts.konghq.com
    helm repo update
    ```

1. Then run the install:
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

1. Next, deploy bookinfo. This bookinfo app has been paired down to work with Kong Mesh in evaluation mode. We only have 5 sidecars we can deploy on evaluation mode is all.
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

## Clean Up 

1. Tear Down bookinfo:
    ```bash
    kubectl delete deploy,svc,ingress --all -n bookinfo
    ```

1. Tear Down KIC:
    ```bash
    helm uninstall kong -n kong
    ```

1. Last Tear Down Kong Mesh:
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



