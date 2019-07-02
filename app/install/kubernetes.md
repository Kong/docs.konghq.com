---
id: page-install-method
title: Install - Kong on Kubernetes
header_title: Kong and Kong Enterprise on Kubernetes
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  kubectl: "https://cloud.google.com/container-engine/docs/quickstart#install_the_gcloud_command-line_interface"
  gh_tag: "https://github.com/Kong/kong-dist-kubernetes/tree/1.0.0"
  kubeapps_hub: "https://hub.kubeapps.com/charts/stable/kong"
  gh_repo: "https://github.com/Kong/kong-dist-kubernetes/"
  az: "https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest"
---

## Kubernetes Ingress Controller for Kong

Install Kong or Kong Enterprise using the official
[Kubernetes Ingress Controller](https://github.com/Kong/kubernetes-ingress-controller).

Learn more via the [README](https://github.com/Kong/kubernetes-ingress-controller/blob/master/README.md). 
To run a local proof of concept, follow the [Minikube and Minishift tutorials](https://github.com/Kong/kubernetes-ingress-controller/tree/master/deploy).

The [Kubernetes Ingress Controller for Kong launch announcement](https://konghq.com/blog/kubernetes-ingress-controller-for-kong/)
is on the [Kong Blog](https://konghq.com/blog/).

For questions and discussion, please visit [Kong Nation](https://discuss.konghq.com/c/kubernetes). For bug reports,
please [open a new issue on GitHub](https://github.com/Kong/kubernetes-ingress-controller/issues).

## Kong via Google Cloud Platform Marketplace

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

<iframe width="660" height="400" src="https://www.youtube-nocookie.com/embed/MPlSyWDAOpw?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Kong via Helm

Install **Kong** or **Kong Enterprise** using the official [Helm chart]({{ page.links.kubeapps_hub }}).

For questions and discussion, please visit [Kong Nation](https://discuss.konghq.com/c/kubernetes).

## Kong via Manifest Files

Kong, or the trial version of Kong Enterprise, can be provisioned
on a Kubernetes cluster via the manifest files provided
in the [Kong Kubernetes repository]({{ page.links.gh_repo }}).

### Prerequisites

1. Download or clone the [Kong Kubernetes repository]({{ page.links.gh_repo }})
2. A Kubernetes cluster

## Installation Steps

The [Kong Kubernetes repository]({{ page.links.gh_repo }}) includes Make tasks `run_cassandra`,
`run_postgres` and `run_dbless` for ease of use, but we'll detail the specific YAML files the tasks use here.

For all variations create the Kong namespace
```bash
$ kubectl apply -f kong-namespace.yaml
```

The next step depends on whether you are going to use Kong with Cassandra, Postgres or without a datastore:


For Cassandra, continue to [Cassandra Backed Kong](#cassandra-backed-kong)

For Postgres, continue to [Postgres Backed Kong](#postgres-backed-kong)

For DB-less mode, continue to [Using Kong without a Database](#using-kong-without-a-database)

### Cassandra Backed Kong

Use the `cassandra-service.yaml` and `cassandra-statefulset.yaml`
file from this repository to deploy a Cassandra `Service` and a `StatefulSet` in the cluster.

```bash
$ kubectl apply -f cassandra-service.yaml
$ kubectl apply -f cassandra-statefulset.yaml
```

Use the `kong-control-plane-cassandra.yaml` file from this repository to run required migrations
and deploy Kong control plane node including the Kong admin api

```bash
$ kubectl -n kong apply -f kong-control-plane-cassandra.yaml
```

Use the `kong-ingress-data-plane-cassandra.yaml` file from this repository to run the Kong data
plane node

``` bash
$ kubectl -n kong apply -f kong-ingress-data-plane-cassandra.yaml
```

Continue to [Using Datastore Backed Kong](#using-datastore-backed-kong)

### PostgreSQL Backed Kong

Use the `postgres.yaml` file from the repository to deploy a  PostgreSQL `Service` and a 
`ReplicationController` in the cluster:

```bash
$ kubectl create -f postgres.yaml
```

Use the `kong-control-plane-postgres.yaml` file from this repository to run required migrations
and deploy Kong control plane node including the Kong Admin API:

```bash
$ kubectl -n kong apply -f kong-control-plane-postgres.yaml
```

Use the `kong-ingress-data-plane-postgres.yaml` file from this repository to run the Kong data
plane node

``` bash
$ kubectl -n kong apply -f kong-ingress-data-plane-postgres.yaml
```

Continue to [Using Datastore Backed Kong](#using-datastore-backed-kong)

### Using Datastore Backed Kong

First let's ensure the Kong control plane and data plane are successfully running

```bash
kubectl get all -n kong
NAME                           READY   STATUS
pod/kong-control-plane         1/1     Running
pod/kong-ingress-data-plane    1/1     Running
```

Get access to the Kong Admin API port (if running minikube the below should work):

```bash
$ export HOST=$(kubectl get nodes --namespace default -o jsonpath='{.items[0].status.addresses[0].address}')
$ export ADMIN_PORT=$(kubectl get svc --namespace kong kong-control-plane  -o jsonpath='{.spec.ports[0].nodePort}')
```

Continue to [configuring a service](/latest/getting-started/configuring-a-service/).

### Using Kong without a Database

For declarative / db-less, create a config map using the `declarative.yaml` sample file from
this repository
```bash
$ kubectl create configmap kongdeclarative -n kong --from-file=declarative.yaml
```

Now deploy the Kong dataplane using the `kong-dbless.yaml` file from this repository

```bash
$ kubectl apply -f kong-dbless.yaml
```

### Using Declarative / DB Less Backed Kong

To update declarative / db-less Kong edit the declarative file and then replace the config map

```bash
$ kubectl create configmap kongdeclarative -n kong --from-file=declarative.yaml -o yaml --dry-run | kubectl replace -n kong -f -
```

Now do a rolling deployment using the `md5sum` of the declarative Kong yaml file

```bash
$ kubectl patch deployment kong-dbless -n kong -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"declarative\":\"`md5sum declarative.yaml | awk '{ print $$1 }'`\"}}}}}}"
```

Get access to the Kong Admin API port (if running minikube the below should work):

```bash
$ export HOST=$(kubectl get nodes --namespace default -o jsonpath='{.items[0].status.addresses[0].address}')=
$ export ADMIN_PORT=$(kubectl get svc --namespace kong kong-control-plane  -o jsonpath='{.spec.ports[0].nodePort}')
```

Continue to [db-less and declarative configuration documentation page](/latest/db-less-and-declarative-config/)

## Additional Steps for Kong Enterprise Trial Users

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
