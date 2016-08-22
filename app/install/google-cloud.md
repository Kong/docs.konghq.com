---
id: page-install-method gke-deployment
title: Install - Google Cloud Platform
header_title: Google Cloud Platform
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  gke_repo: "https://github.com/Mashape/kong-distribution-gke"
  gcloud_sdk: "https://cloud.google.com/sdk/"
  kubectl_sdk: "https://cloud.google.com/container-engine/docs/quickstart#install_the_gcloud_command-line_interface"
---

Kong can easily be povisioned to Google Cloud using the following templates:

- [Download GKE deployment templates]({{ page.links.gke_repo }})
- 

----

### Notes:

1. **Initial setup**:

    You would need [gcloud]({{ page.links.gcloud_sdk }}) and [kubectl]({{ page.links.kubectl_sdk }}) command-line tools installed and set up to run deployment commands. Also make sure your GCP account has at least two STATIC_ADDRESSES available.

    Download or clone the aforementioned repo

    ```bash
    $ git clone git@github.com:Mashape/kong-dist-google-cloud.git
    $ cd kong-dist-google-cloud
    ```

2. **Deploy a cluster**:

    Using `cluster.yaml`, deploy a GKE cluster to use for deploying the solution later. Fill in the following information before deploying:
    
      * desired cluster name
      * zone in which to run the cluster
      * basicauth username and password for authenticating access to the cluster
      * node machine type
      * number of nodes

    When ready, deploy with the following command:

    ```bash
    $ gcloud deployment-manager deployments create cluster --config cluster.yaml
    ```

3. **Deploy a Kong supported Database**

    Using `cassandra.yaml`, deploy a Cassandra `Service` and a `ReplicationController` to the GKE cluster created in the last step.
    Fill in the following information before deploying.

      * the cluster type created for the GKE cluster deployed previously
      * Cassandra image
      * CQL port
      * heap_max_size and heap_new_size for Cassandra's Java resouces tuning  

    When ready, deploy with the following command:

    ```bash
    $ gcloud deployment-manager deployments create cassandra --config cassandra.yaml
    ```

<div class="alert alert-warning">
  <strong>Note:</strong> Currently only Cassandra supported.
</div>

4. **Deploying Kong on the cluster**

    Using `kong.yaml`, deploy a  Kong `Service` and a `ReplicationController` to the GKE cluster created in the last step. Fill in the following information before deploying.

      * the cluster type created for the GKE cluster deployed previously
      * Kong docker image
      * Kong admin and proxy ports
      * allowed IP address range for Kong's proxy ports
      * allowed IP address range for Kong's admin port

    When ready, deploy with the following command:

    ```bash
    $ gcloud deployment-manager deployments create kong --config kong.yaml
    ```

5. **Verifying deployment**

    Be sure your `kubectl` command-line tool is set up to communicate with the cluster you have deployed:

    ```bash
    $ gcloud container clusters get-credentials :cluster-name --zone <zone>
    ```
    Now you can see the resources that have been deployed using `kubectl`:


    ```bash
    $ kubectl get rc
    $ kubectl get pods
    $ kubectl get services
    ```
    Once the `EXTERNAL_IP` is available for Kong service, you can test Kong:

    ```bash
    $ curl <ip-address>:8001
    ```

6. **Using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
