---
title: Installing Kong Enterprise on Kubernetes
---

## Introduction

Kong Enterprise on Kubernetes is recommended for deployments that require features not supported by Kong for Kubernetes Enterprise. It supports all Kong Enterprise plugins and features, but can't run in DB-less mode. See [Kong for Kubernetes deployment options](/enterprise/{{page.kong_version}}/kong-for-kubernetes/deployment-options) for more information.

You can use kubectl or OpenShift oc to configure Kong Enterprise on Kubernetes, then deploy it using Helm.

<img src="https://doc-assets.konghq.com/kubernetes/Kong-Enterprise-on-Kubernetes.png">

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster with load balancer**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
- A valid Kong Enterprise License:
  * If you have a license, continue to [Set Up Kong Enterprise License](#step-2-set-up-kong-enterprise-license) below. If you need your license file information, contact Kong Support.
  * If you need a license, request a trial license through our [Request Demo](https://konghq.com/request-demo/) page.
  * Or, try out Kong for Kubernetes Enterprise using a live tutorial at [https://kubecon.konglabs.io/](https://kubecon.konglabs.io/)
- Kong Enterprise Docker registry access on Bintray.
- Helm installed.

## Step 1. Provision a namespace

To create the secrets for license and Docker registry access,
first provision the `kong` namespace:

{% navtabs %}
{% navtab kubectl %}
```bash
$ kubectl create namespace kong
```
{% endnavtab %}
{% navtab OpenShift oc %}
```bash
$ oc new-project kong
```
{% endnavtab %}
{% endnavtabs %}

## Step 2. Set Up Kong Enterprise license
Running Kong Enterprise on Kubernetes requires a valid license.

As part of the sign-up process for Kong Enterprise, you should have received a license file. If you do not have one, contact your Kong sales representative. Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

> Note:
* There is no `.json` extension in the `--from-file` parameter.
* `-n kong` specifies the namespace in which you are deploying Kong for Kubernetes Enterprise. If you are deploying in a different namespace, change this value.

{% navtabs %}
{% navtab kubectl %}
```
$ kubectl create secret generic kong-enterprise-license --from-file=./license -n kong
```
{% endnavtab %}
{% navtab OpenShift oc %}
```
$ oc create secret generic kong-enterprise-license --from-file=./license -n kong
```
{% endnavtab %}
{% endnavtabs %}

## Step 3. Set up Helm

1. Add the Kong charts repository:
    ```
    $ helm repo add kong https://charts.konghq.com
    ```
2. Update Helm:
    ```
    $ helm repo update
    ```

## Step 4. Configure Kong Enterprise Docker registry access
Set up Docker credentials to allow Kubernetes nodes to pull down the Kong Enterprise Docker image, which is hosted in a private repository. You receive credentials for the Kong Enterprise Docker image when you sign up for Kong Enterprise.

{% navtabs %}
{% navtab kubectl %}
Set up the credentials:
```
$ kubectl create secret -n kong docker-registry kong-enterprise-edition-docker \
    --docker-server=kong-docker-kong-enterprise-edition-docker.bintray.io \
    --docker-username=<your-bintray-username> \
    --docker-password=<your-bintray-api-key>
```
{% endnavtab %}
{% navtab OpenShift oc %}
Set up the credentials:
```
$ oc create secret -n kong docker-registry kong-enterprise-edition-docker \
    --docker-server=kong-docker-kong-enterprise-edition-docker.bintray.io \      
    --docker-username=<your-bintray-username> \
    --docker-password=<your-bintray-api-key>
```
{% endnavtab %}
{% endnavtabs %}

## Step 5. Seed the Super Admin password
{% navtabs %}
{% navtab kubectl %}
(Optional) Create a password for the super admin:
```
kubectl create secret generic kong-enterprise-superuser-password  -n kong --from-literal=password=<your-password>
```
⚠️**Important:** Though not required, this is recommended if you want to use RBAC, as it cannot be done after initial setup.
{% endnavtab %}
{% navtab OpenShift oc %}
(Optional) Create a password for the super admin:
```
oc create secret generic kong-enterprise-superuser-password -n kong --from-literal=password=<your-password>
```
⚠️**Important:** Though not required, this is recommended if you want to use RBAC, as it cannot be done after initial setup.
{% endnavtab %}
{% endnavtabs %}

## Step 6. Prepare the sessions plugin for Kong Manager and Dev Portal
In the following steps, replace `<your-password>` with a secure password.

{% navtabs %}
{% navtab kubectl %}

1. Create a sessions config file for Kong Manager:
    ```
    $ echo '{"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > admin_gui_session_conf
    ```
2. Create a sessions config file for Kong Dev Portal:
    ```
    $ echo '{"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > portal_session_conf
    ```
3. Create secret:
    ```
    kubectl create secret generic kong-session-config -n kong --from-file=admin_gui_session_conf=<manager-config-filename> --from-file=portal_session_conf=<portal-config-filename>
    ```

{% endnavtab %}
{% navtab OpenShift oc %}

1. Create a sessions config file for Kong Manager:
    ```
    $ echo '{"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > admin_gui_session_conf
    ```
2. Create a sessions config file for Kong Dev Portal:
    ```
    $ echo '{"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > portal_session_conf
    ```
3. Create secret:
    ```
    $ oc create secret generic kong-session-config -n kong --from-file=admin_gui_session_conf=<manager-config-filename> --from-file=portal_session_conf=<portal-config-filename>
    ```
{% endnavtab %}
{% endnavtabs %}
## Step 7. Prepare Kong's configuration file

1. Create a `values.yaml` file based on the sample in the [Kong charts repository](https://github.com/Kong/charts/blob/master/charts/kong/values.yaml). This file sets all the necessary parameters for your Kong environment.

2. Minimally, for setting up Kong Enterprise on Kubernetes, you will need to set the following parameters:

    |Parameter      | Value                         |
    |---------------|-------------------------------|
    |`env.database` | `"postgres"` or `"cassandra"` |
    |`env.password.valueFrom.secretKeyRef.name` | Name of secret that holds the super admin password. In the example above, this is set to `kong-enterprise-superuser-password`. |
    |`env.password.valueFrom.secretKeyRef.key` | The type of secret key used for authentication. If you followed the default settings in the example above, this is `password`. |
    |`image.repository` | The Docker repository. In this case, `kong-docker-kong-enterprise-edition-docker.bintray.io/ kong-enterprise-edition`. |
    |`image.tag` | The Docker image tag you want to pull down, e.g. `"1.5.0.2-alpine"`. |
    |`ingressController.enabled` | Set to `true` if you want to use the Kong Ingress Controller, or `false` if you don't want to install it. |

3. In the `Kong Enterprise` section, enable Kong Manager (`manager`) and Kong Dev Portal (`portal`).

    For example:
    ```
    manager:
      enabled: true
      type: LoadBalancer
      http:
        enabled: true
        servicePort: 8002
      tls:
        enabled: true
        servicePort: 8445

    portal:
      enabled: true
      type: LoadBalancer
      http:
        enabled: true
        servicePort: 8003
      tls:
        enabled: true
        servicePort: 8446
    ```

4. Fill in the rest of the parameters as appropriate for your implementation. Use the comments in the sample file to guide you, and see the documentation on [Kong Enterprise parameters](https://github.com/Kong/charts/blob/master/charts/kong/README.md#kong-enterprise-parameters) for more details.

## Step 8. Deploy Kong Enterprise on Kubernetes
The steps in this section show you how to install Kong Enterprise on Kubernetes using Helm.
>Note: the following instructions assume that you're running Helm 3.

{% navtabs %}
{% navtab kubectl %}
1. Run:
    ```
    $ helm install  my-kong kong/kong --namespace kong --values ~/values.yaml
    ```
    This may take some time.

2. Check pod status:
    ```
    $ kubectl get pods -n kong
    ```
    After migrations are complete and the `my-kong-kong-<ID>` pod is running, continue to the next section.
{% endnavtab %}
{% navtab OpenShift oc %}
1. Run:
    ```
    $ helm install  my-kong kong/kong --namespace kong --values ~/values.yaml
    ```
    This may take some time.

2. Check pod status:
    ```
    $ oc get pods -n kong
    ```
    After migrations are complete and the `my-kong-kong-<ID>` pod is running, continue to the next section.
{% endnavtab %}
{% endnavtabs %}

## Step 9. Finalize Configuration and Verify Installation
{% navtabs %}
{% navtab kubectl %}
1. Run:
    ```
    $ kubectl get svc -n kong my-kong-kong-admin --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

2. Copy the IP address from the output, then edit the `values.yaml` file to add the following line under `env` section:

    > **Note:** Do not use IPs with RBAC. If you want to use RBAC, you need to set
    up a DNS hostname first, instead of directly specifying an IP.

    ```
    admin_api_uri: <your-DNSorIP>
    ```

3. Clean up:
    ```
    $ kubectl delete jobs -n kong --all
    ```

4. Update Kong to use the changed `values.yaml`:
    ```
    $ helm upgrade my-kong kong/kong --namespace kong --values ~/values.yaml
    ```

6. After the upgrade is complete, run:
    ```
    kubectl get svc -n kong
    ```

    In the output, the IP in the `EXTERNAL_IP` column is your access point for Kong features, including Kong Manager and Kong Dev Portal:

    ```
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                            AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    8002:31308/TCP,8445:32420/TCP      24m
    my-kong-kong-portal           LoadBalancer   10.101.251.123   10.101.251.123  8003:31609/TCP,8446:32002/TCP      24m
    ```
{% endnavtab %}
{% navtab OpenShift oc %}
1. Run:
    ```
    $ oc get svc -n kong my-kong-kong-admin --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

2. Copy the IP address from the output, then edit the `values.yaml` file to add the following line under `env` section:

    > **Note:** Do not use IPs with RBAC. If you want to use RBAC, you need to set
    up a DNS hostname first, instead of directly specifying an IP.

    ```
    admin_api_uri: <your-DNSorIP>
    ```

3. Clean up:
    ```
    $ oc delete jobs -n kong --all
    ```

4. Update Kong to use the changed `values.yaml`:
    ```
    $ helm upgrade  my-kong kong/kong --namespace kong --values ~/values.yaml
    ```

6. After the upgrade is complete, run:
    ```
    oc get svc -n kong
    ```

    In the output, the IP in the `EXTERNAL_IP` column is your access point for Kong features, including Kong Manager and Kong Dev Portal:

    ```
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                            AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    8002:31308/TCP,8445:32420/TCP      24m
    my-kong-kong-portal           LoadBalancer   10.101.251.123   10.101.251.123  8003:31609/TCP,8446:32002/TCP      24m
    ```
{% endnavtab %}
{% endnavtabs %}

## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about concepts, how-to guides, reference guides, and using plugins.
