---
title: Installing Kong for Kubernetes Enterprise
---

### Introduction
This installation topic guides you through installing and deploying Kong for Kubernetes Enterprise (K4K8S-Enterprise), then directs you to the documentation for configuring and using the product.

<img src="https://doc-assets.konghq.com/kubernetes/K4K8S-Enterprise-Diagram.png" alt="Kong for Kubernetes Enterprise control diagram">

>Note: Installation steps in this topic include installing Kong for Kubernetes Enterprise using YAML. Other deployment options, such as using Helm Chart and Kustomize, will be available at a later time.


### Prerequisites
Before installing Kong for Kubernetes Enterprise, be sure you have the following:

- **Kubernetes cluster**: You can use [Minikube](https://kubernetes.io/docs/setup/minikube/) or a [GKE](https://cloud.google.com/kubernetes-engine/) cluster. Kong is compatible with all distributions of Kubernetes. 
- **kubectl access**: You should have `kubectl` installed and configured to communicate to your Kubernetes cluster.
- A valid Kong Enterprise License
  * If you have a license, continue to [Step 1. Set Kong Enterprise License](#step-1-set-kong-enterprise-license) below. If you need your license file information, contact Kong Support. 
  * If you need a license, request a trial license through our [Request Demo](https://konghq.com/request-demo/) page. 
  * Or, try out Kong for Kubernetes Enterprise using a live tutorial at [https://kubecon.konglabs.io/](https://kubecon.konglabs.io/)
- Kong Enterprise Docker registry access


## Installing Kong for Kubernetes Enterprise
The steps in this section include installing Kong for Kubernetes Enterprise using YAML.

Installation steps include:
- [Step 1. Set Kong Enterprise License ](#step-1-set-kong-enterprise-license)
- [Step 2. Configure Kong Enterprise Docker registry access](#step-2-configure-kong-enterprise-docker-registry-access)
- [Step 3. Deploy Kong for Kubernetes Enterprise](#step-3-deploy-kong-for-kubernetes-enterprise)

In order to create the secrets for license and Docker registry access,
let's provision the `kong` namespace first:

```bash
$ kubectl create namespace kong
namespace/kong created
```

### Step 1. Set Kong Enterprise License
Kong for Kubernetes Enterprise requires a valid license.

As part of sign up for Kong Enterprise, you should have received a license file. If you do not have one, contact your Kong sales representative. Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

> Note: There is no .json extension in the --from-file parameter.
> -n kong specifies the namespace in which you are deploying Kong for Kubernetes Enterprise. If you are deploying in a different namespace, change this value.

```
$ kubectl create secret generic kong-enterprise-license --from-file=./license
-n kong
```


### Step 2. Configure Kong Enterprise Docker registry access
Set up Docker credentials to allow Kubernetes nodes to pull down the Kong Enterprise Docker image, which is hosted as a private repository. You receive credentials for the Kong Enterprise Docker image when you sign up for Kong Enterprise.

```
$ kubectl create secret -n kong docker-registry kong-enterprise-docker \
    --docker-server=kong-docker-kong-enterprise-k8s.bintray.io \
    --docker-username=<BINTRAY-USERNAME> \
    --docker-password=<BINTRAY-APIKEY>
```
For future reference, make a note of the namespace in which you are deploying Kong.
Once these credentials are created, you are ready to deploy Kong Enterprise Ingress Controller.


### Step 3. Deploy Kong for Kubernetes Enterprise

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

> Note: Depending on the Kubernetes distribution you are using, you may or may not see an external IP address assigned to the service. See your provider's guide on obtaining an IP address for a Kubernetes Service of type LoadBalancer.


Set up an environment variable to hold the IP address:

```
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

It might take a while for your cloud provider to associate the IP address to the `kong-proxy` service.
Once you have installed Kong, see the [getting started tutorial](https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/guides/getting-started.md).

## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about Concepts, How-to guides, Reference guides, and using Plugins. 

## Optional: Installing Kong Enterprise on Kubernetes

> Note: The recommended installation is [Kong for Kubernetes Enterprise](#introduction).

To install Kong Enterprise on Kubernetes, instead of installing Kong for Kubernetes, see the following diagram. (Steps to be provided at a later time.)

<img src="https://doc-assets.konghq.com/kubernetes/Kong-Enterprise-on-Kubernetes.png">
