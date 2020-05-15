---
title: Installing Kong for Kubernetes Enterprise
---

## Introduction
Kong for Kubernetes Enterprise provides most Kong Enterprise plugins and runs without a database, but does not include other Kong Enterprise features (Kong Manager, Dev Portal, Vitals, etc). See [Kong for Kubernetes deployment options](/enterprise/{{page.kong_version}}/kong-for-kubernetes/deployment-options) for more information.

You can install Kong for Kubernetes Enterprise using YAML with kubectl, or with OpenShift oc. Other deployment options, such as using Helm Chart and Kustomize, will be available at a later time.

<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
- A valid Kong Enterprise License
  * If you have a license, continue to [Set Up Kong Enterprise License](#step-2-set-up-kong-enterprise-license) below. If you need your license file information, contact Kong Support.
  * If you need a license, request a trial license through our [Request Demo](https://konghq.com/request-demo/) page.
  * Or, try out Kong for Kubernetes Enterprise using a live tutorial at [https://kubecon.konglabs.io/](https://kubecon.konglabs.io/)
- Kong Enterprise Docker registry access on Bintray.

## Step 1. Provision a Namespace

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

## Step 2. Set Up Kong Enterprise License
Running Kong for Kubernetes Enterprise requires a valid license.

As part of the sign-up process for Kong Enterprise, you should have received a license file. If you do not have one, contact your Kong sales representative. Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

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

## Step 3. Configure Kong Enterprise Docker registry access

Set up Docker credentials to allow Kubernetes nodes to pull down the Kong Enterprise Docker image, which is hosted in a private repository. You receive credentials for the Kong Enterprise Docker image when you sign up for Kong Enterprise.

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

## Step 4. Deploy Kong for Kubernetes Enterprise
The steps in this section show you how to install Kong for Kubernetes Enterprise using YAML.

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
After you have installed Kong, see the [getting started tutorial](https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/guides/getting-started.md).

## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about concepts, how-to guides, reference guides, and using plugins.
