---
title: Install on Kubernetes with Helm
badge: enterprise
---

This page explains how to install {{site.base_gateway}} with {{site.kic_product_name}} with a database. To install in DB-less mode, see the documentation on installing with a flat Kubernetes manifest.

## Prerequisites

- A Kubernetes cluster, v1.19 or later
- `kubectl` v1.19 or later
- (Enterprise only) A `license.json` file from Kong
- Helm 3

## Create namespace

Create the namespace for {{site.base_gateway}} with {{site.kic_product_name}}. For example:

```sh
kubectl create namespace kong
```

## Create license secret

1.  Save your license file temporarily with the filename `license` (no file extension).

1.  Run:

    ```sh
    kubectl create secret generic kong-enterprise-license --from-file=./license -n kong
    ```

## Set up Helm

1.  Add the Kong charts repository:

    ```sh
    helm repo add kong https://charts.konghq.com
    ```

1.  Update Helm:

    ```sh
    helm repo update
    ```

## Create secret for RBAC superuser (recommended)

If you plan to use RBAC, you must create the superuser account at this step in installation. You cannot create it later.

1.  Create the RBAC account.

1.  Create the secret:

    ```sh
    kubectl create secret generic kong-enterprise-superuser-password \
    n kong \
    --from-literal=password=<your-password>
    ```

## Create secret for Session plugin

If you create an RBAC superuser and plan to work with Kong Manager or Dev Portal, you must also configure the Session plugin and store its config in a Kubernetes secret:

For Kong Manager only:

```sh
kubectl create secret generic kong-session-config \
-n kong \
--from-file=admin_gui_session_conf
```

For Kong Manager and Dev Portal:

```sh
kubectl create secret generic kong-session-config \
-n kong \
--from-file=admin_gui_session_conf \
--from-file=portal_session_conf
```

## Create `values.yaml` file

Create a `values.yaml` file to provide required values such as password secrets or optional email addresses for notifications. Work from the [Enterprise example file](https://github.com/Kong/charts/blob/main/charts/kong/example-values/full-k4k8s-with-kong-enterprise.yaml). The example file includes comments to explain which values you must set. The [readme in the charts repository](https://github.com/Kong/charts/blob/main/charts/kong/README.md) includes an exhaustive list of all possible configuration properties.

Note that this deployment includes a Postgres sub-chart provided by Bitnami. You might need to delete the PersistentVolume objects for Postgres in your Kubernetes cluster to connect to the database after install.

## Deploy {{site.base_gateway}} with {{site.kic_product_name}}

1.  Run:

    ```sh
    helm install my-kong kong/kong -n kong --values ./values.yaml
    ```

    This might take some time.

1.  Check pod status, and make sure the `my-kong-kong-<ID>` pod is running:

    ```bash
    kubectl get pods -n kong
    ```

## Finalize configuration and verify installation

1.  Run:

    ```sh
    kubectl get svc my-kong-kong-admin \
    -n kong \
    --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

1.  Copy the IP address from the output, then add the following to the `.env` section of your `values.yaml` file:

    ```yaml
    admin_api_uri: <your-DNS-or-IP>
    ```

    {:.Note}
    > **Note:** If you configure RBAC, you must specify a DNS hostname instead of an IP address.

1.  Clean up:

    ```sh
    kubectl delete jobs -n kong --all
    ```

1.  Update with changed `values.yaml`:

    ```
    helm upgrade my-kong kong/kong -n kong --values ./values.yaml
    ```

1.  After the upgrade finishes, run:

    ```
    kubectl get svc -n kong
    ```

    The output includes `EXTERNAL-IP` values for Kong Manager and Dev Portal. For example:

    ```sh
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                            AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    8002:31308/TCP,8445:32420/TCP      24m
    my-kong-kong-portal           LoadBalancer   10.101.251.123   10.101.251.123  8003:31609/TCP,8446:32002/TCP      24m
    ```
    