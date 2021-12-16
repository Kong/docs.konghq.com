---
title: Install on Kubernetes with Helm
---

This page explains how to install {{site.base_gateway}} with {{site.kic_product_name}} using Helm.

* The Enterprise deployment includes a Postgres sub-chart provided by Bitnami.
* For open-source deployments, you can choose to use the Postgres sub-chart, or install without a database.

Configuration for both options is flexible and depends on your environment.

The documentation on installing with a [flat Kubernetes manifest](/gateway/{{page.kong_version}}/install-and-run/kubernetes) also explains how to install in DB-less mode for both Enterprise and OSS deployments.

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

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

## Set up Helm

1.  Add the Kong charts repository:

    ```sh
    helm repo add kong https://charts.konghq.com
    ```

1.  Update Helm:

    ```sh
    helm repo update
    ```

## Create license secret
{:.badge .enterprise}

1.  Save your license file temporarily with the filename `license` (no file extension).

1.  Run:

    ```sh
    kubectl create secret generic kong-enterprise-license --from-file=./license -n kong
    ```

## Create secret for RBAC superuser (recommended)
{:.badge .enterprise}

If you plan to use RBAC, you must create a secret for the superuser account password at this step in installation. You cannot create it later.

1.  Create the RBAC account.

1.  Create the secret:

    ```sh
    kubectl create secret generic kong-enterprise-superuser-password \
    -n kong \
    --from-literal=password={YOUR_PASSWORD}
    ```

## Create secret for Session plugin
{:.badge .enterprise}

If you create an RBAC superuser and plan to work with Kong Manager or Dev Portal, you must also configure the Session plugin and store its config in a Kubernetes secret:

1.  Create a session config file for Kong Manager:

    ```bash
    $ echo '{"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > admin_gui_session_conf
    ```

1.  Create a session config file for Kong Dev Portal:

    ```bash
    $ echo '{"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > portal_session_conf
    ```

    Or, if you have different subdomains for the `portal_api_url` and `portal_gui_host`, set the `cookie_domain`
    and `cookie_samesite` properties as follows:

    ```
    $ echo '{"cookie_name":"portal_session","cookie_samesite":"off","cookie_domain":"<.your_subdomain.com">,"secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > portal_session_conf
    ```

1.  Create the secret:

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

## Create values.yaml file

Create a `values.yaml` file to provide required values such as password secrets or optional email addresses for notifications. You can work from the [Enterprise example file](https://github.com/Kong/charts/blob/main/charts/kong/example-values/full-k4k8s-with-kong-enterprise.yaml). The example file includes comments to explain which values you must set.

For OSS deployments, the default install might be sufficient, but you can explore other `values.yaml` files and [the readme in the charts repository](https://github.com/Kong/charts/blob/main/charts/kong/README.md), which includes an exhaustive list of all possible configuration properties.

Note that the Enterprise deployment includes a Postgres sub-chart provided by Bitnami. You might need to delete the PersistentVolume objects for Postgres in your Kubernetes cluster to connect to the database after install.

## Deploy {{site.base_gateway}} with {{site.kic_product_name}}

1.  Run:

    ```sh
    ## Kong Gateway
    helm install my-kong kong/kong -n kong --values ./values.yaml
    ```

    ```sh
    ## Kong Gateway (OSS)
    helm install kong/kong --generate-name --set ingressController.installCRDs=false
    ```

    For more information on working with Helm charts for {{site.ce_product_name}}, see the [chart documentation](https://github.com/Kong/charts/blob/main/charts/kong/README.md).

    This might take some time.

1.  Check pod status, and make sure the `my-kong-kong-{ID}` pod is running:

    ```bash
    kubectl get pods -n kong
    ```

## Finalize configuration and verify installation
{:.badge .enterprise}

1.  Run:

    ```sh
    kubectl get svc my-kong-kong-admin \
    -n kong \
    --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

1.  Copy the IP address from the output, then add the following to the `.env` section of your `values.yaml` file:

    ```yaml
    admin_api_uri: {YOUR-DNS-OR-IP}
    ```

    {:.note}
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

    With an Enterprise deployment, the output includes `EXTERNAL-IP` values for Kong Manager and Dev Portal. For example:

    ```sh
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                            AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    8002:31308/TCP,8445:32420/TCP      24m
    my-kong-kong-portal           LoadBalancer   10.101.251.123   10.101.251.123  8003:31609/TCP,8446:32002/TCP      24m
    ```

## Next steps

See the [Kong Ingress Controller docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
