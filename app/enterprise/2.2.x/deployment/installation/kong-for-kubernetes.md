---
title: Installing Kong for Kubernetes Enterprise
---

## Introduction
Kong for Kubernetes Enterprise provides most {{site.ee_product_name}} plugins and runs
without a database, but does not include other enterprise features (Kong
Manager, Dev Portal, Vitals, and so on).

This installation topic walks you through a DB-less deployment on
Kubernetes. For the full range of enterprise features, you need a
database-backed or a hybrid deployment. See the instructions for
[Installing {{site.ee_product_name}} on Kubernetes](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes),
which walk you through a deployment with a database.

<div class="alert alert-ee blue">
<strong>Note:</strong>
See <a href="/enterprise/{{page.kong_version}}/deployment/kubernetes-deployment-options">Kong for Kubernetes deployment options</a>
for a feature breakdown and comparison between DB-less and database-backed
deployments.
</div>

![Kong for Kubernetes Enterprise](/assets/images/docs/ee/kubernetes/k4k8s-enterprise.png)

You can install Kong for Kubernetes Enterprise using YAML with `kubectl`, with
OpenShift `oc`, or [with Helm](https://github.com/Kong/charts/tree/main/charts/kong).

### Deployment options

The following instructions assume that you are deploying {{site.ee_product_name}} in [classic embedded mode](/enterprise/{{page.kong_version}}/deployment/deployment-options/).

If you would like to run {{site.ee_product_name}} in Hybrid mode, the instructions in this topic will walk you though setting up a Control Plane instance. Afterward, you will need to bring up additional Kong instances for the Data Planes, and perform further configuration steps. See [Hybrid Mode setup documentation](https://github.com/Kong/charts/blob/main/charts/kong#hybrid-mode) for details.

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Provision a namespace

To create the license secret, first provision the `kong` namespace:

{% navtabs codeblock %}
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

## Step 2. Set up license
Running Kong for Kubernetes Enterprise requires a valid license. See [prerequisites](#prerequisites) for more information.

Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

{% navtabs codeblock %}
{% navtab kubectl %}
```sh
$ kubectl create secret generic kong-enterprise-license --from-file=./license -n kong
```
{% endnavtab %}
{% navtab OpenShift oc %}
```sh
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

{% navtabs codeblock %}
{% navtab kubectl %}
```sh
$ kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{site.data.kong_latest_KIC.version}}/deploy/single/all-in-one-dbless-k4k8s-enterprise.yaml
```
{% endnavtab %}
{% navtab OpenShift oc %}
```sh
$ oc create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{site.data.kong_latest_KIC.version}}/deploy/single/all-in-one-dbless-k4k8s-enterprise.yaml
```
{% endnavtab %}
{% endnavtabs %}

The initial setup might take a few minutes.

{% navtabs codeblock %}
{% navtab kubectl %}
```sh
$ kubectl get pods -n kong

NAME                            READY   STATUS    RESTARTS   AGE
ingress-kong-6ffcf8c447-5qv6z   2/2     Running   1          44m
```
{% endnavtab %}
{% navtab OpenShift oc %}
```sh
$ oc get pods -n kong

NAME                            READY   STATUS    RESTARTS   AGE
ingress-kong-6ffcf8c447-5qv6z   2/2     Running   1          44m
```
{% endnavtab %}
{% endnavtabs %}

You can also see the **kong-proxy service**:

{% navtabs codeblock %}
{% navtab kubectl %}
```sh
$ kubectl get service kong-proxy -n kong

NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
```
{% endnavtab %}
{% navtab OpenShift oc %}
```sh
$ oc get service kong-proxy -n kong

NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
```
{% endnavtab %}
{% endnavtabs %}


<div class="alert alert-ee blue">
<strong>Note:</strong> Depending on the Kubernetes distribution you are using,
you might see an external IP address assigned to the service. Refer to your
provider's guide on obtaining an IP address for a Kubernetes Service of type
LoadBalancer.
</div>

Set up an environment variable to hold the IP address:

```sh
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

It might take a while for your cloud provider to associate the IP address to the `kong-proxy` service.
After you have installed {{site.base_gateway}}, see the [getting started tutorial](/kubernetes-ingress-controller/latest/guides/getting-started/).

## Next steps
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/deployment/using-kong-for-kubernetes/) for information about concepts, how-to guides, reference guides, and using plugins.
