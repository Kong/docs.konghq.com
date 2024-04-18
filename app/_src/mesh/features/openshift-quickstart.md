---
title: Get started with Red Hat OpenShift and Kong Mesh
content_type: tutorial
description: This guide explains how to get started on Kong Mesh with Red Hat OpenShift.
---

In this guide, you will learn how to get {{site.mesh_product_name}} up and running quickly in [standalone mode](/mesh/{{page.release}}/production/deployment/stand-alone/) on [Red Hat OpenShift](https://www.redhat.com/technologies/cloud-computing/openshift). This tutorial assumes some base-level OpenShift knowledge.

This tutorial doesn't require a license because {{site.mesh_product_name}} can start in evaluation mode, which allows you to have up to five data planes or sidecars. This provides just enough data planes to get comfortable with the product and test it out.

This quickstart tutorial covers:

* How to use the Red Hat Certified {{site.mesh_product_name}} images
* How to implement the required OpenShift security context constraints (SCCs) for the `kong-mesh` sidecar
* How to deploy a sample application, `kuma-demo`, on the mesh and validate that the application is working
* How to use the sample application to test the features of {{site.mesh_product_name}}

## Prerequisites
* [Red Hat OpenShift Service on AWS (ROSA) CLI installed](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa_getting_started_iam/rosa-installing-rosa.html) or another OpenShift 4.12 cluster with the ability to create LoadBalancer type Kubernetes Services
* [An AWS account with ROSA permissions enabled](https://docs.openshift.com/rosa/rosa_install_access_delete_clusters/rosa_getting_started_iam/rosa-config-aws-account.html)
* [kubectl CLI installed](https://kubernetes.io/docs/tasks/tools/)
* [OpenShift Container Platform CLI installed](https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html)
* [Helm 3 installed](https://helm.sh/docs/intro/install/)
* Clone the {{site.mesh_product_name}} OpenShift quickstart repository:
    ```bash
    git clone https://github.com/Kong/kong-mesh-quickstart-openshift.git
    ```

## Install ROSA

In this section, you will install a ROSA cluster called `kong-mesh-2` in the `us-west-2` region. Then, you'll create an admin user to get quick access to the cluster. 

1. Navigate to the `kong-mesh-quickstart-openshift` repository that you just cloned in the prerequisites. All commands in this guide should be run from that repository.

1. Create system variables for the cluster name and region:
    ```bash
    CLUSTER_NAME=kong-mesh-demo
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

1. Validate you can log in to the cluster using the credentials provided by the ROSA CLI `stout`. Once you successfully login, you can proceed to the next section.

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

    This authenticates you to Red Hat's image registry, which allows you to pull the certified images.

1. Add `nonroot-v2` to job service accounts so that each of their Kubernetes jobs successfully runs:
    ```bash
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-install-crds
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-patch-ns-job 
    oc adm policy add-scc-to-user nonroot-v2 system:serviceaccount:kong-mesh-system:kong-mesh-pre-delete-job
    ```

1. Get the latest Helm chart:
    ```bash
    helm repo add kong-mesh https://kong.github.io/kong-mesh-charts
    ```

1. Update Helm chart:
    ```bash
    helm repo update
    ```

1. Install {{site.mesh_product_name}}:
    ```bash
    helm upgrade -i kong-mesh kong-mesh/kong-mesh --version 2.2.0 -f kong-mesh/values.yaml -n kong-mesh-system
    ```

1. Verify that {{site.mesh_product_name}} installed correctly by checking the pod health:
    ```bash
    kubectl get pods -n kong-mesh-system
    ```
    This should return the control plane that is running, like the following:
    ```bash
    NAME                                       READY   STATUS    RESTARTS   AGE
    kong-mesh-control-plane-7443h46bd4-cmhsa   1/1     Running   0          19s
    ```

1. In a new terminal window, `port-forward` to reach the {{site.mesh_product_name}} GUI:
    ```bash
    kubectl port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681:5681
    ```

    You should be able to reach the {{site.mesh_product_name}} UI at `http://localhost:5681/gui`.


1. Finally, you must do some prep work for the sidecar itself so sidecars will start up successfully. 
    1. Apply the `kong-mesh-sidecar` SCCs:
        ```bash
        kubectl create -f kong-mesh/kong-mesh-sidecar-scc.yaml
        ```
    1. Apply the corresponding container patches:
        ```bash
        kubectl apply -f kong-mesh/container-patch.yaml 
        ```
    In OpenShift, by default, all pods and containers are given the restricted SCC. This is insufficient for the {{site.mesh_product_name}} sidecars (containers). The sidecars need a slightly escalated permissions, these permissions are defined in the `kong-mesh-sidecar-scc` manifest. The `container-patch` file defines how to patch the sidecars with the SCCs.

## Deploy the demo application

In this step, you'll deploy the [`kuma-demo` app](/mesh/{{page.release}}/quickstart/kubernetes) to {{site.mesh_product_name}}. This allows you to quickly populate your mesh with services so you can test the capabilities of {{site.mesh_product_name}}.

The `kuma-demo` app consists of two services:

* `demo-app`: A web application that lets you increment a numeric counter
* `redis`: A data store for the counter

1. Escalate the SCC of PostgreSQL SA to `privileged`:
  ```bash
  oc adm policy add-scc-to-user privileged system:serviceaccount:kuma-demo:kuma-demo-postgres
  ```
  Escalating the SCC allows access to all privileged and host features. This is only recommended for this tutorial, do not escalate the SSC of PostgreSQL SA in a production environment.

1. Escalate the SCC of the default SA (this is the SA for the rest of the `kuma-demo` application pods) to use the `kong-mesh-sidecar` SCC:
  ```bash
  oc adm policy add-scc-to-user kong-mesh-sidecar system:serviceaccount:kuma-demo:default
  ```

1. In the `kuma-demo` directory, deploy the application:
  ```bash
  kubectl apply -f kuma-demo/kuma-demo-aio-ocp.yaml
  ```

1. You should see four application pods, each with two containers, in the output:
  ```bash
  kubectl get pods -n kuma-demo
  NAME                                    READY   STATUS    RESTARTS   AGE
  kuma-demo-app-5f5f685863-8778x          2/2     Running   0          51s
  kuma-demo-backend-v0-90bc879754-srafd   2/2     Running   0          52s
  postgres-master-6577s699c8-z9nas        2/2     Running   0          54s
  redis-master-949t4d567-khmha            2/2     Running   0          53s
  ```

1. Use `port-forward` to view the application:
  ```bash
  kubectl port-forward service/frontend -n kuma-demo 8080
  ```

  You can see the applications in the {{site.mesh_product_name}} UI at `http://localhost:8080`.

## Test {{site.mesh_product_name}} capabilities

Now that you've deployed {{site.mesh_product_name}} along with the demo application on your ROSA cluster, you can test {{site.mesh_product_name}}. You can follow the instructions in [Enable Mutual TLS and Traffic Permissions](/mesh/{{page.release}}/quickstart/kubernetes/#enable-mutual-tls-and-traffic-permissions) to learn how to use policies in {{site.mesh_product_name}}.

## Clean up 

In this section, you will remove all components, including `kuma-demo` and {{site.mesh_product_name}}, and delete the ROSA cluster. Once all of these are removed, you can create a {{site.mesh_product_name}} production environment.

1. Remove the `kuma-demo` application:
    ```bash
    kubectl delete deploy,svc --all -n kuma-demo
    ```

1. Remove {{site.mesh_product_name}}:
    ```bash
    helm uninstall kong-mesh -n kong-mesh-system
    ```
    All the components are now removed, so it's safe to delete the ROSA cluster.

1. Delete the ROSA cluster admin user:
    ```bash
    rosa delete admin --cluster $CLUSTER_NAME
    ```

1. Delete the ROSA cluster:
    ```bash
    rosa delete cluster --cluster $CLUSTER_NAME
    ```

## Next steps

Now that you've deleted your demo cluster and components, you can deploy {{site.mesh_product_name}} in a production environment. Follow the instructions in one of the following guides to deploy {{site.mesh_product_name}} using your method of choice:

* [Deploy a standalone control plane](/mesh/{{page.release}}/production/cp-deployment/stand-alone/)
* [Deploy a multi-zone global control plane](/mesh/{{page.release}}/production/cp-deployment/multi-zone/)



