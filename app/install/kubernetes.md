---
id: page-install-method
title: Install - Kong on Kubernetes
header_title: Kong and Kong Enterprise on Kubernetes
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  gcloud: "https://cloud.google.com/sdk/"
  kubectl: "https://cloud.google.com/container-engine/docs/quickstart#install_the_gcloud_command-line_interface"
  gh_tag: "https://github.com/Kong/kong-dist-kubernetes/tree/1.0.0"
  minikube: "https://github.com/Kong/kong-dist-kubernetes/blob/master/minikube/README.md"
  kubeapps_hub: "https://hub.kubeapps.com/charts/stable/kong"
  gh_repo: "https://github.com/Kong/kong-dist-kubernetes/"
  az: "https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest"
---

## Table of Contents

<!-- FIXME the list below should be an unordered list, but currently those do not render correctly in this section of the Docs site - depends on https://github.com/Kong/docs.konghq.com/issues/917 -->
1. [Kubernetes Ingress Controller for Kong](#kubernetes-ingress-controller-for-kong)
1. [Kong via Google Cloud Platform Marketplace](#kong-via-google-cloud-platform-marketplace)
1. [Kong via Helm or Minikube](#kong-via-helm-or-minikube)
1. [Kong via Manifest Files](#kong-via-manifest-files)
1. [Additional Steps for Kong Enterprise Trial Users](#additional-steps-for-kong-enterprise-trial-users)

# Kubernetes Ingress Controller for Kong

Install Kong or Kong Enterprise using the official
<a href="https://github.com/Kong/kubernetes-ingress-controller">Kubernetes Ingress Controller</a>.

Learn more via the <a href="https://github.com/Kong/kubernetes-ingress-controller/blob/master/README.md">README
</a>. To get up and running quickly, follow the
<a href="https://github.com/Kong/kubernetes-ingress-controller/tree/master/deploy">Minikube and Minishift tutorials</a>.

The [Kubernetes Ingress Controller for Kong launch announcement](https://konghq.com/blog/kubernetes-ingress-controller-for-kong/)
is on the [Kong Blog](https://konghq.com/blog/).

For questions and discussion, please visit [Kong Nation](https://discuss.konghq.com/c/kubernetes). For bug reports,
please [open a new issue on GitHub](https://github.com/Kong/kubernetes-ingress-controller/issues).

# Kong via Google Cloud Platform Marketplace

Perhaps the fastest way to try Kong on Kubernetes is via the Google Cloud
Platform Marketplace and [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) -
plus, with Google Cloud Platform's [Free Tier and credit](https://cloud.google.com/free/),
it will likely be free for you to get started.

1. Visit https://console.cloud.google.com/marketplace/details/kong/kong
1. Click "Configure" and follow the on-screen prompts
1. Refer to https://github.com/Kong/google-marketplace-kong-app/blob/master/README.md
for important details regarding exposing the Admin API so that you can configure Kong.

If you were only experimenting, consider deleting your Google Cloud resources
once you've completed your experiment to avoid on-going Google Cloud usage charges.

# Kong via Helm or Minikube

An easy way to deploy Kong on Kubernetes is via [Helm]({{ page.links.kubeapps_hub }}).

Kong can also be deployed on minikube - please follow the [README]({{ page.links.minikube }})
and use the manifest files provided in `minikube` directory.

# Kong via Manifest Files

Kong, or the trial version of Kong Enterprise, can be provisioned
on a Kubernetes cluster via the manifest files provided
in the [repo]({{ page.links.gh_repo }}).

## 1. **Initial setup**

Download or clone the following repo:

```bash
$ git clone git@github.com:Kong/kong-dist-kubernetes.git
$ cd kong-dist-kubernetes
```

Skip to step 3 if you have already provisioned a cluster and registered it
with Kubernetes.

## 2.  **Deploy a cluster**

### [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/)

You need [gcloud]({{ page.links.gcloud }}) and [kubectl]({{ page.links.kubectl }})
command-line tools installed and set up to run deployment commands. Also
make sure your Google Cloud account has `STATIC_ADDRESSES` available for
the external access of Kong services.

Using the `cluster.yaml` file from this repo, deploy a
GKE cluster. Provide the following information before deploying:

1. Desired cluster name
2. Zone in which to run the cluster
3. A basicauth username and password for authenticating the access to the
cluster

```bash
$ gcloud deployment-manager deployments \
    create cluster --config cluster.yaml
```

### [Azure Kubernetes Cluster (AKS)](https://docs.microsoft.com/en-us/azure/aks/)

You need [az]({{ page.links.az }}) command-line tools installed and set up to run deployment commands.

1. **Create a Resource Group**

    ```bash
    $ az group create --name myAKSCluster --location eastus
    ```

2. **Install kubectl**

    If you already have [kubectl]({{ page.links.kubectl }}) installed, you can skip this step.

    ```bash
    $ az aks install-cli
    ```

3. **Configure kubectl**

    ```bash
    $ az aks get-credentials --resource-group myAKSCluster --name myAKSCluster
    ```

## 3. **Deploy a datastore**

Before deploying Kong, you need to provision a Cassandra or PostgreSQL pod.

For Cassandra, use the `cassandra.yaml` file from this repo to deploy a
Cassandra `Service` and a `StatefulSet` in the cluster.

```bash
$ kubectl create -f cassandra.yaml
```

For PostgreSQL, use the `postgres.yaml` file from the kong-dist-kubernetes
repo to deploy a PostgreSQL `Service` and a `ReplicationController` in the
cluster:

```bash
$ kubectl create -f postgres.yaml
```

**Kong Enterprise trial users** should complete the steps in the
**Additional Steps for Kong Enterprise Trial Users** section below before proceeding.

## 4. **Prepare database**

Using the `kong_migration_<postgres|cassandra>.yaml` file,
run the migration job:

```bash
$ kubectl create -f kong_migration_<postgres|cassandra>.yaml
```
Once the job completes, you can remove the pod by running following command:

```bash
$ kubectl delete -f kong_migration_<postgres|cassandra>.yaml
```

## 5. **Deploy Kong**

Using the `kong_<postgres|cassandra>.yaml` file from this
repo, deploy Kong admin, proxy services, and a `Deployment` controller to
the cluster:

```bash
$ kubectl create -f kong_<postgres|cassandra>.yaml
```

## 6. **Verify your deployments**

You can now see the resources that have been deployed using `kubectl`:

```bash
$ kubectl get all
```

Once the `EXTERNAL_IP` is available for Kong Proxy and Admin services, you
can test Kong by making the following requests:

```bash
$ curl <kong-admin-ip-address>:8001
$ curl https://<admin-ssl-ip-address>:8444
$ curl <kong-proxy-ip-address>:8000
$ curl https://<kong-proxy-ssl-ip-address>:8443
```

## 7. **Get Started with Kong**

Quickly learn how to use Kong with the
[5-minute Quickstart](/latest/getting-started/quickstart/).

# Additional Steps for Kong Enterprise Trial Users

1. **Publish a Kong Enterprise Docker image to your container registry**

    Because the Kong Enterprise image is not available on the public Docker container registry,
    you must publish it to a private repository for use with Kubernetes. While any private
    repository will work, this example uses the
    [Google Cloud Platform Container Registry](https://cloud.google.com/container-registry/),
    which automatically integrates with the Google Cloud Platform examples in the other steps.

    In the steps below, replace `<image ID>` with ID associated with your loaded image in `docker images` output.
    Replace `<project ID>` with your [Google Cloud Platform project ID](https://support.google.com/cloud/answer/6158840).

    ```bash
    $ docker load -i /tmp/kong-docker-enterprise-edition.tar.gz
    $ docker images
    $ docker tag <image ID> gcr.io/<project ID>/kong-ee
    $ gcloud docker -- push gcr.io/demo-cs-lab/kong-ee:latest
    ```
2. **Add your Kong Enterprise License File**

    Edit `kong_trial_postgres.yaml` and `kong_trial_migration_postgres.yaml` to replace
    `YOUR_LICENSE_HERE` with your Kong Enterprise License File string - it should look like:

    ```yaml
    - name: KONG_LICENSE_DATA
    value: '{"license":{"signature":"alongstringofcharacters","payload":{"customer":"Test Company","license_creation_date":"2018-03-06","product_subscription":"Kong Only","admin_seats":"5","support_plan":"Premier","license_expiration_date":"2018-06-04","license_key":"anotherstringofcharacters"},"version":1}}'
    ```

3. **Use the Kong Enterprise image**

    Edit `kong_trial_postgres.yaml` and `kong_trial_migration_postgres.yaml` and replace
    `image: kong` with `image: gcr.io/<project ID>/kong-ee`, using the same project ID as above.

4. **Deploy Kong Enterprise**

    Continue from step 4 in the **Kong or Kong Enterprise via Manifest Files**
    instruction above, using the `kong_trial_*` YAML files in the
    [Kong Enterprise Trial directory](https://github.com/Kong/kong-dist-kubernetes/tree/master/ee-trial).
    Once Kong Enterprise is running, you should be able to access the Kong Admin GUI
    at `<kong-admin-ip-address>:8002` or `https://<kong-ssl-admin-ip-address>:8445`.
