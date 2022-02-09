---
title: Set up a Kong Gateway Runtime on Kubernetes
no_version: true
---
Set up a Kubernetes [runtime](/konnect/#konnect-key-concepts-and-terminology)
through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.base_gateway}} instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtimes
associated with the {{site.konnect_saas}} account.

<div class="alert alert-ee blue">
<b>Note:</b> Kong does not host runtimes. You must install and host your own
runtime instances.
</div>

## Prerequisites

* You have **Runtime Admin** or **Organization Admin** permissions in {{site.konnect_saas}}.
* **Kubernetes cluster with load balancer:** {{site.konnect_short_name}} is
compatible with all distributions of Kubernetes. You can use a Minikube, GKE,
or OpenShift TLS.
* **kubectl or oc access:** You have kubectl or oc (if working with OpenShift)
installed and configured to communicate to your Kubernetes TLS.
* [Helm 3](https://helm.sh/docs/intro/install/) is installed.

## Set up Helm

On your runtime's system, create a namespace and pull down the `kong` Helm repo.

1. Create a namespace:
    ```sh
    $ kubectl create namespace kong
    ```

2. Add the Kong charts repository:
    ```bash
    $ helm repo add kong https://charts.konghq.com
    ```

3. Update Helm:
    ```bash
    $ helm repo update
    ```

## Generate certificates

{% include /md/konnect/runtime-certs.md %}

## Configure the runtime

Next, configure a {{site.base_gateway}} instance using the certificate, the
private key, and the remaining configuration details on the
**Configure Runtime** page.

### Configure secrets

Store the certificates and key you generated through the Runtime Manager in
Kubernetes secrets.

1. Create a `tls` secret using the `tls.cert` and `tls.key` files
you saved earlier:

    ```bash
    $ kubectl create secret tls kong-cluster-cert -n kong \
      --cert=/{PATH_TO_FILE}/tls.crt \
      --key=/{PATH_TO_FILE}/tls.key
    ```

2. Create a generic secret for the `ca.crt` file:

    ```bash
    $ kubectl create secret generic kong-cluster-ca -n kong \
      --from-file=ca.crt=/{PATH_TO_FILE}/ca.crt
    ```

### Write and apply configuration

1. Create a `values.yaml` file.


2. Return to {{site.konnect_short_name}} and copy the
codeblock in the **Step 2. Configuration Parameters** section.

    ![Konnect Runtime Parameters](/assets/images/docs/konnect/konnect-runtime-manager.png)

3. Paste the codeblock into your `values.yaml` file. It should look something
like this:

    ```yaml
    image:
      repository: kong/kong-gateway
      tag: "2.7.0.0-alpine"

    secretVolumes:
    - kong-cluster-cert
    - kong-cluster-ca

    admin:
      enabled: false

    env:
      role: data_plane
      database: "off"
      vitals_ttl_days: 732
      cluster_mtls: pki
      cluster_control_plane: {EXAMPLE.CP.KONNECT.FOO}:443
      cluster_server_name: {KONG-CPOUTLET-EXAMPLE.SERVICE}
      cluster_telemetry_endpoint: {EXAMPLE.TP.KONNECT.FOO}:443
      cluster_telemetry_server_name: {KONG-TELEMETRY-EXAMPLE.SERVICE}
      cluster_ca_cert: /etc/secrets/kong-cluster-ca/ca.crt
      cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
      cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key

    ingressController:
      enabled: false
      installCRDs: false
    ```

4. Replace any placeholder values in the `env` section of the `values.yaml`
with your specific values from {{site.konnect_short_name}}.

    If your cluster cert locations differ from the paths in the template, update
    the values in `cluster_cert`, `cluster_cert_key`, and `cluster_ca_cert`
    with references to the secrets you created earlier.

    See [Parameters](/konnect/runtime-manager/runtime-parameter-reference) for
    descriptions and matching values in {{site.konnect_short_name}}.

5. Apply the `values.yaml`:

    ```bash
    $ helm install my-kong kong/kong -n kong \
      --values ./values.yaml
    ```

6. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

### Troubleshooting

If you configured everything above but don't see your runtime in the Runtime
Manager, check the logs from your deployment:

```bash
$ kubectl logs deployment/my-kong-kong -n kong
```

If you find any errors and need to update `values.yaml`, make your changes,
save the file, then reapply the configuration by running the Helm `upgrade`
command:

```bash
$ helm upgrade my-kong kong/kong -n kong \
    --values ./values.yaml
```

## Access services using the proxy

To proxy traffic through this runtime, you'll need its external IP address,
a port, and a route.

1. To find the address and port, run:

    ```bash
    $ kubectl get service my-kong-kong-proxy -n kong
    ```

2. In the output, the IP in the `EXTERNAL_IP` column is the access point for
your {{site.konnect_short_name}} services:

    ```bash
    NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
    kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
    ```

3. With the external IP and one of the available ports (`80` or `443`),
and assuming that you have configured a service with a route,
you can now access your service at `{EXTERNAL_IP}:{PORT}/{ROUTE}`.

    For example, using the values above and a sample route, you now have the
    following:
    * IP: `35.233.198.16`
    * Port: `80`
    * Route: `/mock`

    Putting them together, the end result looks like this:
    `35.233.198.16:80/mock`
