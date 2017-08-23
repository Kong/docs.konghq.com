---
id: page-install-method
title: Install - Kong on Kubernetes
header_title: Kong on Kubernetes managed cluster
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  gcloud: "https://cloud.google.com/sdk/"
  kubectl: "https://cloud.google.com/container-engine/docs/quickstart#install_the_gcloud_command-line_interface"
  gh_tag: "https://github.com/Mashape/kong-dist-kubernetes/tree/1.0.0"
  minikube: "https://github.com/Mashape/kong-dist-kubernetes/blob/master/minikube/README.md"
---

Kong can easily be provisioned to Kubernetes cluster using the following steps:

1. **Initial setup**
  
    Download or clone the following repo:

    ```bash
    $ git clone git@github.com:Mashape/kong-dist-kubernetes.git
    $ cd kong-dist-kubernetes
    ```
    If you want to run Kubernetes locally, please follow the [README]({{ page.links.minikube }}) 
    and use the manifest files provided in `minikube` directory.
    
    Skip to step 3 if you have already provisioned a cluster and registered it
    with Kubernetes.

    Note: Included manifest files in repo only support Kong v0.11.x, for 0.10.x
    please use the [tag 1.0.0]({{ page.links.gh_tag }}).

2.  **Deploy a GKE cluster**
    
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

    By now, you have provisioned a Kubernetes managed cluster.


3. **Deploy a Kong supported database**
  
    Before deploying Kong, you need to provision a Cassandra or PostgreSQL pod.

    For Cassandra, use the `cassandra.yaml` file from this repo to deploy a
    Cassandra `Service` and a `StatefulSet` in the cluster:

    ```bash
    $ kubectl create -f cassandra.yaml
    ```
    Note: Please update the `cassandra.yaml` file for the cloud you are working
    with.

    For PostgreSQL, use the `postgres.yaml` file from the kong-dist-kubernetes 
    repo to deploy a PostgreSQL `Service` and a `ReplicationController` in the
    cluster:

    ```bash
    $ kubectl create -f postgres.yaml
    ```

4. **Prepare database**

    Using the `kong_migration_<postgres|cassandra>.yaml` file from this repo,
    run the migration job, jump to step 5 if Kong migrations are up–to–date:
    
    ```bash
    $ kubectl create -f kong_migration_<postgres|cassandra>.yaml
    ```
    Once job completes, you can remove the pod by running following command:

    ```bash
    $ kubectl delete -f kong_migration_<postgres|cassandra>.yaml
    ```

5. **Deploy Kong**

    Using the `kong_<postgres|cassandra>.yaml` file from this
    repo, deploy Kong admin, proxy services, and a `Deployment` controller to
    the cluster:
    
    ```bash
    $ kubectl create -f kong_<postgres|cassandra>.yaml
    ```

6. **Verify your deployments**

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

7. **Using Kong**

    Quickly learn how to use Kong with the 
    [5-minute Quickstart](/docs/latest/getting-started/quickstart/).
