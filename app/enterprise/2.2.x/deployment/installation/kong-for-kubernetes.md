---
title: Installing Kong for Kubernetes Enterprise
skip_read_time: true
---

## Introduction
Kong for Kubernetes Enterprise provides most Kong Enterprise plugins and runs
without a database, but does not include other Kong Enterprise features (Kong
Manager, Dev Portal, Vitals, and so on).

This installation topic walks you through a DB-less deployment on
Kubernetes. For the full range of Enterprise features, you need a
database-backed or a hybrid deployment. See the instructions for
[Installing Kong Enterprise on Kubernetes](/enterprise/{{page.kong_version}}/deployment/installation/kong-on-kubernetes),
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

### Deployment Options

The following instructions assume that you are deploying {{site.ee_product_name}} in [classic embedded mode](/enterprise/{{page.kong_version}}/deployment/deployment-options).

If you would like to run {{site.ee_product_name}} in Hybrid mode, the instructions in this topic will walk you though setting up a Control Plane instance. Afterward, you will need to bring up additional Kong instances for the Data Planes, and perform further configuration steps. See [Hybrid Mode setup documentation](https://github.com/Kong/charts/blob/main/charts/kong#hybrid-mode) for details.

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
{% include /md/{{page.kong_version}}/bintray-and-license.md %}

## Step 1. Provision a Namespace

To create the secrets for license and Docker registry access,
first provision the `kong` namespace:

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

## Step 2. Set Up Kong Enterprise License
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

## Step 3. Configure Kong Enterprise Docker registry access

Set up Docker credentials to allow Kubernetes nodes to pull down the Kong Enterprise Docker image, which is hosted in a private repository. You receive credentials for the Kong Enterprise Docker image when you sign up for Kong Enterprise.

{% navtabs codeblock %}
{% navtab kubectl %}
```sh
$ kubectl create secret -n kong docker-registry kong-enterprise-edition-docker \
    --docker-server=kong-docker-kong-enterprise-edition-docker.bintray.io \
    --docker-username=<your-bintray-username> \
    --docker-password=<your-bintray-api-key>
```
{% endnavtab %}
{% navtab OpenShift oc %}
```sh
$ oc create secret -n kong docker-registry kong-enterprise-edition-docker \
    --docker-server=kong-docker-kong-enterprise-edition-docker.bintray.io \
    --docker-username=<your-bintray-username> \
    --docker-password=<your-bintray-api-key>
```
{% endnavtab %}
{% endnavtabs %}

## Step 4. Deploy Kong for Kubernetes Enterprise
The steps in this section show you how to install Kong for Kubernetes Enterprise using YAML.

{% navtabs codeblock %}
{% navtab kubectl %}
```sh
$ kubectl apply -f https://bit.ly/k4k8s-enterprise-install
```
{% endnavtab %}
{% navtab OpenShift oc %}
```sh
$ oc create -f https://bit.ly/k4k8s-enterprise-install
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
After you have installed Kong, see the [getting started tutorial](https://github.com/Kong/kubernetes-ingress-controller/blob/main/docs/guides/getting-started.md).

## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/deployment/using-kong-for-kubernetes) for information about concepts, how-to guides, reference guides, and using plugins.
