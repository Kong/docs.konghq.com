---
title: Installing Kong Enterprise with Kubernetes
---

## Introduction
Kong for Kubernetes provides two options for its Kong Enterprise container image:

* Kong for Kubernetes Enterprise (`kong-enterprise-k8s`): provides most Kong Enterprise plugins and runs without a database, but does not include other Kong Enterprise features (Kong Manager, Dev Portal, Vitals, etc).
* Kong Enterprise on Kubernetes (`kong-enterprise-edition`): recommended for deployments that require features not supported by `kong-enterprise-k8s`. It supports all Kong Enterprise plugins and features, but cannot run without a database. This package does not require the Kong Ingress Controller.

You can install `kong-enterprise-k8s` using YAML with kubectl, or with OpenShift oc. Other deployment options, such as using Helm Chart and Kustomize, will be available at a later time.

You can also use kubectl or oc to configure `kong-enterprise-edition`, but it has to be deployed using Helm.

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
- A valid Kong Enterprise License
  * If you have a license, continue to [Set Up Kong Enterprise License](#set-up-kong-enterprise-license) below. If you need your license file information, contact Kong Support.
  * If you need a license, request a trial license through our [Request Demo](https://konghq.com/request-demo/) page.
  * Or, try out Kong for Kubernetes Enterprise using a live tutorial at [https://kubecon.konglabs.io/](https://kubecon.konglabs.io/)
- Kong Enterprise Docker registry access on Bintray.
- **For installations of Kong Enterprise on Kubernetes**: Helm is installed.

## Prepare for Installation

### Provision a Namespace

In order to create the secrets for license and Docker registry access,
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

## Set Up Kong Enterprise License
Running Kong Enterprise requires a valid license.

As part of sign up for Kong Enterprise, you should have received a license file. If you do not have one, contact your Kong sales representative. Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

> Note: There is no `.json` extension in the `--from-file` parameter.
> `-n kong` specifies the namespace in which you are deploying Kong for Kubernetes Enterprise. If you are deploying in a different namespace, change this value.

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

Next, choose an installation option: [Kong for Kubernetes Enteprise](#option-1-install-kong-for-kubernetes-enterprise) or [Kong Enterprise on Kubernetes](#option-2-install-kong-enterprise-on-kubernetes).

## Option 1: Install Kong for Kubernetes Enterprise
The steps in this section show you how to install Kong for Kubernetes Enterprise using YAML.

<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">

### Configure Kong Enterprise Docker registry access

Set up Docker credentials to allow Kubernetes nodes to pull down the Kong Enterprise Docker image, which is hosted as a private repository. You receive credentials for the Kong Enterprise Docker image when you sign up for Kong Enterprise.

{% navtabs %}
{% navtab kubectl %}
```
$ kubectl create secret -n kong docker-registry kong-enterprise-k8s-docker \
    --docker-server=kong-docker-kong-enterprise-k8s.bintray.io \
    --docker-username=<your-bintray-username> \
    --docker-password=<your-bintray-api-key>
```
{% endnavtab %}
{% navtab OpenShift oc %}
```
$ oc create secret -n kong docker-registry kong-enterprise-k8s-docker \
    --docker-server=kong-docker-kong-enterprise-k8s.bintray.io \
    --docker-username=<your-bintray-username> \
    --docker-password=<your-bintray-api-key>
```
{% endnavtab %}
{% endnavtabs %}

### Deploy Kong for Kubernetes Enteprise

{% navtabs %}
{% navtab kubectl %}
```
$ kubectl apply -f https://bit.ly/k4k8s-enterprise
```
The initial setup might take a few minutes.

```
$ kubectl get pods -n kong
NAME                            READY   STATUS    RESTARTS   AGE
ingress-kong-6ffcf8c447-5qv6z   2/2     Running   1          44m
```

You can also see the **kong-proxy service**:

```
$ kubectl get service kong-proxy -n kong
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
```
{% endnavtab %}
{% navtab OpenShift oc %}
```
$ oc create -f https://bit.ly/k4k8s-enterprise
```
The initial setup might take a few minutes.

```
$ oc get pods -n kong
NAME                            READY   STATUS    RESTARTS   AGE
ingress-kong-6ffcf8c447-5qv6z   2/2     Running   1          44m
```

You can also see the **kong-proxy service**:

```
$ oc get service kong-proxy -n kong
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
```
{% endnavtab %}
{% endnavtabs %}

> Note: Depending on the Kubernetes distribution you are using, you may or may not see an external IP address assigned to the service. See your provider's guide on obtaining an IP address for a Kubernetes Service of type LoadBalancer.


Set up an environment variable to hold the IP address:

```
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

It might take a while for your cloud provider to associate the IP address to the `kong-proxy` service.
Once you have installed Kong, see the [getting started tutorial](https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/guides/getting-started.md).

## Option 2: Install Kong Enterprise on Kubernetes

The steps in this section show you how to install Kong Enterprise on Kubernetes using Helm.
>Note: the following instructions assume that you're running Helm 3.

<img src="https://doc-assets.konghq.com/kubernetes/Kong-Enterprise-on-Kubernetes.png">

### Set up Helm

1. Add the Kong charts repository:
    ```
    $ helm repo add kong https://charts.konghq.com
    ```
2. Update Helm:
    ```
    $ helm repo update
    ```

### Configure Kong Enterprise Docker registry access
Set up Docker credentials to allow Kubernetes nodes to pull down the Kong Enterprise Docker image, which is hosted as a private repository. You receive credentials for the Kong Enterprise Docker image when you sign up for Kong Enterprise.

{% navtabs %}
{% navtab kubectl %}
1. Set up the credentials:
    ```
    $ kubectl create secret -n kong docker-registry kong-enterprise-edition-docker \
        --docker-server=kong-docker-kong-enterprise-edition-docker.bintray.io \
        --docker-username=<your-bintray-username> \
        --docker-password=<your-bintray-api-key>
    ```

2. (Optional) Create a password for the super admin:
    ```
    kubectl create secret generic kong-enterprise-superuser-password  -n kong --from-literal=password=<your-password>
    ```
    Though not required, this is recommended for users that wish to use RBAC, as it cannot be done after initial setup.
{% endnavtab %}
{% navtab OpenShift oc %}
1. Set up the credentials:
    ```
    $ oc create secret -n kong docker-registry kong-enterprise-edition-docker \
        --docker-server=kong-docker-kong-enterprise-edition-docker.bintray.io \
        --docker-username=<your-bintray-username> \
        --docker-password=<your-bintray-api-key>
    ```

2. (Optional) Create a password for the super admin:
    ```
    oc create secret generic kong-enterprise-superuser-password -n kong --from-literal=password=<your-password>
    ```
    Though not required, this is recommended for users that wish to use RBAC, as it cannot be done after initial setup.
{% endnavtab %}
{% endnavtabs %}
### Enable the sessions plugin for Manager and Dev Portal
In the following steps, replace `<your-password>` with a secure password.

{% navtabs %}
{% navtab kubectl %}

1. Create a sessions config file for Kong Manager:
    ```
    $ cat > admin_gui_session_conf
    {"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}
    ```
2. Create a sessions config file for Kong Dev Portal:
    ```
    $ cat > portal_session_conf
    {"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}
    ```

3. Create secret:
    ```
    $ kubectl create secret generic kong-session-config -n kong --from-file=admin_gui_session_conf --from-file=portal_session_conf
    ```
{% endnavtab %}
{% navtab OpenShift oc %}

1. Create a sessions config file for Kong Manager:
    ```
    $ cat > admin_gui_session_conf
    {"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}
    ```
2. Create a sessions config file for Kong Dev Portal:
    ```
    $ cat > portal_session_conf
    {"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}
    ```

3. Create secret:
    ```
    $ oc create secret generic kong-session-config -n kong --from-file=admin_gui_session_conf --from-file=portal_session_conf
    ```
{% endnavtab %}
{% endnavtabs %}
### Prepare the values.yaml

1. Create a `values.yaml` file based on the sample in the [Kong charts repository](https://github.com/Kong/charts/blob/master/charts/kong/values.yaml). This file sets all the necessary parameters for your Kong environment.

2. Minimally, for setting up Kong Enterprise on Kubernetes, you will need to set the following parameters:

    Parameter | Value  
    ----------|-------
    `env.database` | `"postgres"` or `"cassandra"`
    `env.password.valueFrom.secretKeyRef.name` | Name of secret that holds the super admin password. In the example above, this is set to `kong-enterprise-superuser-password`.
    `env.password.valueFrom.secretKeyRef.key` | The type of secret key used for authentication. If you followed the default settings in the example above, this is `password`.
    `image.repository` | The Docker repository. In this case, `kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition`
    `image.tag` | The Docker image tag you want to pull down, e.g. `"1.5.0.2-alpine"`
    `ingressController.enabled` | `false`

3. Remove the entire section of `Ingress Controller parameters`. Since this installation enables other features such as Kong Manager and Kong Dev Portal, there is no need for a separate ingress controller.

4. In the `Kong Enterprise` section, enable Kong Manager (`manager`) and Kong Dev Portal (`portal`).

5. Fill in the rest of the parameters as they fit your implementation. Use the comments in the file to guide you, and see the documentation on [Kong Enterprise parameters](https://github.com/Kong/charts/blob/master/charts/kong/README.md#kong-enterprise-parameters) for more details.

### Deploy Kong Enterprise on Kubernetes
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
    Once migrations are complete and the `my-kong-kong-<ID>` pod is running, move on to the next section.
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
    Once migrations are complete and the `my-kong-kong-<ID>` pod is running, move on to the next section.
{% endnavtab %}
{% endnavtabs %}

### Set up Kong Manager
{% navtabs %}
{% navtab kubectl %}
1. Run:
    ```
    $ kubectl get svc -n kong my-kong-kong-admin --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

2. Copy the IP address from the output, then edit the `values.yaml` file to add the following line under `env` section:

    ```
    admin_api_uri: <your-ip>
    ```

3. Clean up:
    ```
    $ kubectl delete jobs -n kong --all
    ```

4. Update Kong to use the changed `values.yaml`:
    ```
    $ helm upgrade  my-kong kong/kong --namespace kong --values ~/values.yaml
    ```

6. Once the upgrade is complete, you can log into Kong Manager. Run:
    ```
    kubectl get svc -n kong
    ```

    In the output, the IP in the `EXTERNAL_IP` column is your access point for Kong Manager:

    ```
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                         AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    80:31308/TCP,443:32420/TCP      24m
    ```
    You can also access the Kong Dev Portal directly using its IP from this list, or log into Kong Manager and access the Dev Portal for an individual workspace from there.
{% endnavtab %}
{% navtab OpenShift oc %}
1. Run:
    ```
    $ oc get svc -n kong my-kong-kong-admin --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

2. Copy the IP address from the output, then edit the `values.yaml` file to add the following line under `env` section:

    ```
    admin_api_uri: <your-ip>
    ```

3. Clean up:
    ```
    $ oc delete jobs -n kong --all
    ```

4. Update Kong to use the changed `values.yaml`:
    ```
    $ helm upgrade  my-kong kong/kong --namespace kong --values ~/values.yaml
    ```

6. Once the upgrade is complete, you can log into Kong Manager. Run:
    ```
    oc get svc -n kong
    ```

    In the output, the IP in the `EXTERNAL_IP` column is your access point for Kong Manager:

    ```
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                         AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    80:31308/TCP,443:32420/TCP      24m
    ```
    You can also access the Kong Dev Portal directly using its IP from this list, or log into Kong Manager and access the Dev Portal for an individual workspace from there.
{% endnavtab %}
{% endnavtabs %}
## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about concepts, how-to guides, reference guides, and using plugins.
