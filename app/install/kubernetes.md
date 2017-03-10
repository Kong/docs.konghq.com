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
---

Kong can easily be provisioned to Kubernetes cluster using the following steps:

1. **Initial setup**
  
    Download or clone the following repo:

    ```bash
    $ git clone git@github.com:Mashape/kong-dist-kubernetes.git
    $ cd kong-dist-kubernetes
    ```
    
    Skip to step 3 if you have already provisioned a cluster and registered it
    with Kubernetes.
    
2.  **Deploy a GKE cluster**
    
    You need [gcloud]({{ page.links.gcloud }}) and
    [kubectl]({{ page.links.kubectl }}) command-line tools installed and set up
    to run deployment commands. Also make sure your Google Cloud account has at
    least two `STATIC_ADDRESSES` available. 

    Using the `cluster.yaml` file from the kong-dist-kubernetes repo, deploy a
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

    For Cassandra, use the `cassandra.yaml` file from the kong-dist-kubernetes 
    repo to deploy a Cassandra `Service` and a `ReplicationController` in the
    cluster:  

    ```bash
    $ kubectl create -f cassandra.yaml
    ```
    
    For PostgreSQL, use the `postgres.yaml` file from the kong-dist-kubernetes 
    repo to deploy a PostgreSQL `Service` and a `ReplicationController` in the
    cluster:

    ```bash
    $ kubectl create -f postgres.yaml
    ```

4. **Deploy Kong**

    Using the `kong_<postgres|cassandra>.yaml` file from the
    kong-dist-kubernetes repo, deploy a Kong `Service` and a `Deployment` to the
    cluster created in the last step:
    
    ```bash
    $ kubectl create -f kong_<postgres|cassandra>.yaml.yaml
    ```

5. **Verify your deployments**

    You can now see the resources that have been deployed using `kubectl`:

    ```bash
    $ kubectl get rc
    $ kubectl get deployment
    $ kubectl get pods
    $ kubectl get services
    $ kubectl get logs <pod-name>
    ```

    Once the `EXTERNAL_IP` is available for Kong Proxy and Admin services, you
    can test Kong by making the following requests:

    ```bash
    $ curl <admin-ip-address>:8001
    $ curl <proxy-ip-address>:8000
    ```

6. **Using Kong**

    Quickly learn how to use Kong with the 
    [5-minute Quickstart](/docs/latest/getting-started/quickstart/).
