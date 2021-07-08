---
title: Installing Kong Enterprise on Kubernetes
---

## Introduction

Kong Enterprise on Kubernetes is recommended for deployments that require features not supported by Kong for Kubernetes Enterprise. It supports all Kong Enterprise plugins and features, but can't run in DB-less mode.

> Note: See [Kong for Kubernetes deployment options](/enterprise/{{page.kong_version}}/kong-for-kubernetes/deployment-options) for a feature breakdown and image comparison.

You can use kubectl or OpenShift oc to configure Kong Enterprise on Kubernetes, then deploy it using Helm.

<img src="https://doc-assets.konghq.com/kubernetes/Kong-Enterprise-on-Kubernetes.png">

## Prerequisites
Before starting installation, be sure you have the following:

- **Kubernetes cluster with load balancer**: Kong is compatible with all distributions of Kubernetes. You can use a [Minikube](https://kubernetes.io/docs/setup/minikube/), [GKE](https://cloud.google.com/kubernetes-engine/), or [OpenShift](https://www.openshift.com/products/container-platform) cluster.
- **kubectl or oc access**: You should have `kubectl` or `oc` (if working with OpenShift) installed and configured to communicate to your Kubernetes cluster.
- Helm installed.
{% include /md/enterprise/license.md license='prereq' %}

## Step 1. Provision a namespace

To create the license secret, first provision the `kong` namespace:

{% navtabs %}
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

## Step 2. Set Up Kong Enterprise license
Running Kong Enterprise on Kubernetes requires a valid license. See [prerequisites](#prerequisites) for more information.

Save the license file temporarily to disk with filename `license` (no file extension) and execute the following:

{% navtabs %}
{% navtab kubectl %}
```
$ kubectl create secret generic kong-enterprise-license -n kong --from-file=./license
```
{% endnavtab %}
{% navtab OpenShift oc %}
```
$ oc create secret generic kong-enterprise-license -n kong --from-file=./license
```
{% endnavtab %}
{% endnavtabs %}

<div class="alert alert-ee blue">
<strong>Note:</strong><br>
<ul>
  <li>There is no <code>.json</code> extension in the <code>--from-file</code> parameter.</li>
  <li><code>-n kong</code> specifies the namespace in which you are deploying Kong for Kubernetes Enterprise. If you are deploying in a different namespace, change this value.</li></ul></div>

## Step 3. Set up Helm

1. Add the Kong charts repository:
    ```
    $ helm repo add kong https://charts.konghq.com
    ```
2. Update Helm:
    ```
    $ helm repo update
    ```

## Step 4. Seed the Super Admin password
{% navtabs %}
{% navtab kubectl %}
(Optional) Create a password for the super admin:
```
kubectl create secret generic kong-enterprise-superuser-password -n kong --from-literal=password=<your-password>
```
⚠️**Important:** Though not required, this is recommended if you want to use RBAC, as it cannot be done after initial setup.
{% endnavtab %}
{% navtab OpenShift oc %}
(Optional) Create a password for the super admin:
```
oc create secret generic kong-enterprise-superuser-password -n kong --from-literal=password=<your-password>
```
⚠️**Important:** Though not required, this is recommended if you want to use RBAC, as it cannot be done after initial setup.
{% endnavtab %}
{% endnavtabs %}

## Step 5. Prepare the sessions plugin for Kong Manager and Dev Portal
In the following steps, replace `<your-password>` with a secure password.

{% navtabs %}
{% navtab kubectl %}

1. Create a sessions config file for Kong Manager:
    ```
    $ echo '{"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > admin_gui_session_conf
    ```
2. Create a sessions config file for Kong Dev Portal:
    ```
    $ echo '{"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > portal_session_conf
    ```
3. Create secret:
    ```
    kubectl create secret generic kong-session-config -n kong --from-file=admin_gui_session_conf --from-file=portal_session_conf
    ```

{% endnavtab %}
{% navtab OpenShift oc %}

1. Create a sessions config file for Kong Manager:
    ```
    $ echo '{"cookie_name":"admin_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > admin_gui_session_conf
    ```
2. Create a sessions config file for Kong Dev Portal:
    ```
    $ echo '{"cookie_name":"portal_session","cookie_samesite":"off","secret":"<your-password>","cookie_secure":false,"storage":"kong"}' > portal_session_conf
    ```
3. Create secret:
    ```
    $ oc create secret generic kong-session-config -n kong --from-file=admin_gui_session_conf --from-file=portal_session_conf
    ```
{% endnavtab %}
{% endnavtabs %}
## Step 6. Prepare Kong's configuration file

1. Create a `values.yaml` file for Helm based on the template in the [Kong charts repository](https://github.com/Kong/charts/blob/main/charts/kong/values.yaml). This file contains all the possible parameters for your Kong deployment.

    You can also base your configuration on a sample Kong Enterprise `values.yaml`
    file. For example, [this values file](https://github.com/Kong/charts/blob/main/charts/kong/example-values/full-k4k8s-with-kong-enterprise.yaml)
    enables most Kong Enterprise features.

2. Minimally, for setting up Kong Enterprise on Kubernetes, you will need to set the following parameters:

    |Parameter      | Value                         |
    |---------------|-------------------------------|
    |`enterprise.enabled` | `true` |
    |`enterprise.portal.enabled` | (Optional) Set to `true` to enable the [Kong Developer Portal](/enterprise/{{page.kong_version}}/developer-portal/). |
    |`enterprise.rbac.enabled` | (Optional) Set to `true` to enable RBAC. Requires seeding the super admin password; see [above](#step-5-seed-the-super-admin-password). |
    |`env.database` | `"postgres"` or `"cassandra"` |
    |`env.pg_host` | (If using Postgres) Set to host of the Postgres server (only if `postgresql.enabled` is `false`). |
    |`env.pg_port` | (If using Postgres) Set to port of the Postgres server (only if `postgresql.enabled` is `false`). |
    |`env.pg_user` | (If using Postgres) Set to the Postgres user (default `kong`). When `postgresql.enabled` is `true`, this has to match `postgresql.postgresqlUsername`. |
    |`env.pg_password` | (If using Postgres) Set to the Postgres user's password. When `postgresql.enabled` is `true`, this has to match `postgresql.postgresqlPassword`. |
    |`env.pg_database` | (If using Postgres) Set to the Postgres database name (default `kong`). When `postgresql.enabled` is `true`, this has to match `postgresql.postgresqlDatabase`. |
    |`env.password.valueFrom.secretKeyRef.name` | Name of secret that holds the super admin password. In the example above, this is set to `kong-enterprise-superuser-password`. |
    |`env.password.valueFrom.secretKeyRef.key` | The type of secret key used for authentication. If you followed the default settings in the example above, this is `password`. |
    |`image.repository` | The Docker repository. In this case, `kong/kong-gateway`. |
    |`image.tag` | The Docker image tag you want to pull down, e.g. `"{{page.kong_latest.version}}-alpine"`. |
    |`admin.enabled` | Set to `true` to enable the Admin API, which is required for the Kong Manager. |
    |`ingressController.enabled` | Set to `true` if you want to use the Kong Ingress Controller, or `false` if you don't want to install it. |
    |`postgresql.enabled` | Set to `true` to deploy a Postgres database along with Kong. |
    |`postgresql.postgresqlUsername` | Set Postgres user (e.g. `kong`). |
    |`postgresql.postgresqlPassword` | Set Postgres user's password. |
    |`postgresql.postgresqlDatabase` | Set Postgres database name (e.g. `kong`). |

3. In the `Kong Enterprise` section, enable Kong Manager (`manager`) and Kong Dev Portal (`portal`).

    For example:
    ```
    manager:
      enabled: true
      type: LoadBalancer
      http:
        enabled: true
        servicePort: 8002
      tls:
        enabled: true
        servicePort: 8445

    portal:
      enabled: true
      type: LoadBalancer
      http:
        enabled: true
        servicePort: 8003
      tls:
        enabled: true
        servicePort: 8446
    ```

4. Fill in the rest of the parameters as appropriate for your implementation. Use the comments in the sample file to guide you, and see the documentation on [Kong Enterprise parameters](https://github.com/Kong/charts/blob/main/charts/kong/README.md#kong-enterprise-parameters) for more details.

## Step 7. Deploy Kong Enterprise on Kubernetes
The steps in this section show you how to install Kong Enterprise on Kubernetes using Helm.
>Note: the following instructions assume that you're running Helm 3.

{% navtabs %}
{% navtab kubectl %}
1. Run:
    ```
    $ helm install my-kong kong/kong -n kong --values ./values.yaml
    ```
    This may take some time.

    <div class="alert alert-warning">
   
    <strong>Important:</strong>
    If you are running Postgres as a sub-chart and having problems with connecting to
    the database, delete Postgres' persistent volumes in your Kubernetes cluster, then
    retry the Helm install.
    </div>

    <div class="alert alert-warning">
   
    <strong>Important:</strong>
    If you have already installed the CRDs, run the command above with the following flag: <code>--set ingressController.installCRDs=false</code>.
    </div>


2. Check pod status:
    ```
    $ kubectl get pods -n kong
    ```
    After migrations are complete and the `my-kong-kong-<ID>` pod is running, continue to the next section.
{% endnavtab %}
{% navtab OpenShift oc %}
1. Run:
    ```
    $ helm install my-kong kong/kong -n kong --values ./values.yaml
    ```
    This may take some time.

2. Check pod status:
    ```
    $ oc get pods -n kong
    ```
    After migrations are complete and the `my-kong-kong-<ID>` pod is running, continue to the next section.
{% endnavtab %}
{% endnavtabs %}

## Step 8. Finalize Configuration and Verify Installation
{% navtabs %}
{% navtab kubectl %}
1. Run:
    ```
    $ kubectl get svc my-kong-kong-admin -n kong --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

    <div class="alert alert-warning">
   
    <strong>Important:</strong> The command above requires the Kong Admin API. If you
    have not set <code>admin.enabled</code> to <code>true</code> in your
    <code>values.yaml</code>, then this command will not work.
    </div>


2. Copy the IP address from the output, then edit the `values.yaml` file to add the following line under `env` section:

    > **Note:** Do not use IPs with RBAC. If you want to use RBAC, you need to set
    up a DNS hostname first, instead of directly specifying an IP.

    ```
    admin_api_uri: <your-DNSorIP>
    ```

3. Clean up:
    ```
    $ kubectl delete jobs -n kong --all
    ```

4. Update Kong to use the changed `values.yaml`:
    ```
    $ helm upgrade my-kong kong/kong -n kong --values ./values.yaml
    ```

6. After the upgrade is complete, run:
    ```
    kubectl get svc -n kong
    ```

    In the output, the IP in the `EXTERNAL_IP` column is your access point for Kong features, including Kong Manager and Kong Dev Portal:

    ```
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                            AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    8002:31308/TCP,8445:32420/TCP      24m
    my-kong-kong-portal           LoadBalancer   10.101.251.123   10.101.251.123  8003:31609/TCP,8446:32002/TCP      24m
    ```
{% endnavtab %}
{% navtab OpenShift oc %}
1. Run:
    ```
    $ oc get svc my-kong-kong-admin -n kong --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'
    ```

2. Copy the IP address from the output, then edit the `values.yaml` file to add the following line under `env` section:

    > **Note:** Do not use IPs with RBAC. If you want to use RBAC, you need to set
    up a DNS hostname first, instead of directly specifying an IP.

    ```
    admin_api_uri: <your-DNSorIP>
    ```

3. Clean up:
    ```
    $ oc delete jobs -n kong --all
    ```

4. Update Kong to use the changed `values.yaml`:
    ```
    $ helm upgrade my-kong kong/kong -n kong --values ./values.yaml
    ```

6. After the upgrade is complete, run:
    ```
    oc get svc -n kong
    ```

    In the output, the IP in the `EXTERNAL_IP` column is your access point for Kong features, including Kong Manager and Kong Dev Portal:

    ```
    NAME                          TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                            AGE
    my-kong-kong-manager          LoadBalancer   10.96.61.116     10.96.61.116    8002:31308/TCP,8445:32420/TCP      24m
    my-kong-kong-portal           LoadBalancer   10.101.251.123   10.101.251.123  8003:31609/TCP,8446:32002/TCP      24m
    ```
{% endnavtab %}
{% endnavtabs %}

## Next steps...
See [Using Kong for Kubernetes Enterprise](/enterprise/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about concepts, how-to guides, reference guides, and using plugins.
