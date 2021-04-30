---
title: Installing Kong for Kubernetes Enterprise
---

## Introduction
Kong for Kubernetes Enterprise provides most Kong Enterprise plugins and runs without a database, but does not include other Kong Enterprise features (Kong Manager, Dev Portal, Vitals, etc).

>Note: See [Kong for Kubernetes deployment options](/enterprise/{{page.kong_version}}/kong-for-kubernetes/deployment-options) for a feature breakdown and image comparison.

You can install Kong for Kubernetes Enterprise using YAML with kubectl, or with OpenShift oc. Other deployment options, such as using Helm Chart and Kustomize, will be available at a later time.

<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Provision a Namespace

To create the license secret, first provision the `kong` namespace:

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
Running Kong for Kubernetes Enterprise requires a valid license. See [prerequisites](#prerequisites) for more information.

Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

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

<div class="alert alert-ee blue">
<strong>Note:</strong><br>
<ul>
  <li>There is no <code>.json</code> extension in the <code>--from-file</code> parameter.</li>
  <li><code>-n kong</code> specifies the namespace in which you are deploying Kong for Kubernetes Enterprise. If you are deploying in a different namespace, change this value.</li></ul></div>

## Step 3. Deploy Kong for Kubernetes Enterprise
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
After you have installed Kong, see the [getting started tutorial](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/guides/getting-started.md).

## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about concepts, how-to guides, reference guides, and using plugins.
