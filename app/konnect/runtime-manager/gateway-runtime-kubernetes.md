---
title: Set up a Kong Gateway Runtime on Kubernetes
no_version: true
---
Set up a Kubernetes [runtime](/konnect/overview/#konnect-key-concepts-and-terminology)
through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.base_gateway}} instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtimes
associated with the {{site.konnect_short_name}} SaaS account.

<div class="alert alert-ee blue">
<b>Note:</b> Kong does not host runtimes. You must install and host your own
runtime instances.
</div>

## Prerequisites

* You have a {{site.konnect_product_name}} account. Contact your sales
representative for access.
* **Kubernetes cluster with load balancer:** {{site.konnect_short_name}} is
compatible with all distributions of Kubernetes. You can use a Minikube, GKE,
or OpenShift cluster.
* **kubectl or oc access:** You should have kubectl or oc (if working with OpenShift)
installed and configured to communicate to your Kubernetes cluster.
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

1. Create a `tls` secret using the `cluster.cert` and `cluster.key` files
you saved earlier:

    ```bash
    $ kubectl create secret tls kong-cluster-cert -n kong \
      --cert=/<path-to-file>/cluster.crt \
      --key=/<path-to-file>/cluster.key
    ```

2. Create a generic secret for the `ca.crt` file:

    ```bash
    $ kubectl create secret generic kong-cluster-ca -n kong \
      --from-file=ca.crt=/<path-to-file>/ca.crt
    ```

### Write configuration

1. Back in {{site.konnect_short_name}}, copy the
codeblock from the **Configuration Parameters** section.

2. Create a `values.yaml` file. Remove the `KONG_` prefix from the parameters
in the sample codeblock and add the following parameters to the file.

    Make sure to replace the values in `cluster_cert`, `cluster_cert_key`,
    and `cluster_ca_cert` with references to the secrets you created earlier:

    ```yaml
    image:
      repository: kong-docker-kong-gateway-docker.bintray.io/kong-enterprise-edition
      tag: "{{site.data.kong_latest_ee.version}}-alpine"

    secretVolumes:
    - kong-cluster-cert
    - kong-cluster-ca

    admin:
      enabled: false

    env:
      role: data_plane
      database: "off"
      anonymous_reports: off
      vitals_ttl_days: 732
      cluster_mtls: pki
      cluster_control_plane: <example.cp.konnect.foo>:443
      cluster_server_name: <kong-cpoutlet-example.service>
      cluster_telemetry_endpoint: <example.tp.konnect.foo>:443
      cluster_telemetry_server_name: <kong-telemetry-example.service>
      cluster_ca_cert: /etc/secrets/kong-cluster-ca/ca.crt
      cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
      cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key
      lua_ssl_trusted_certificate: /etc/secrets/kong-cluster-ca/ca.crt

    ingressController:
      enabled: false
      installCRDs: false
    ```

    See [Parameters](/konnect/runtime-manager/runtime-parameter-reference) for
    descriptions and the matching fields in {{site.konnect_short_name}}.

6. Apply the `values.yaml`:

    ```bash
    $ helm install my-kong kong/kong -n kong \
      --values ./values.yaml
    ```

7. Clean up:
    ```bash
    $ kubectl delete jobs -n kong --all
    ```

8. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

<div class="alert alert-ee warning">
<b>Important:</b> Certificates expire after 30 days and must be renewed. See
<a href="/konnect/runtime-manager/renew-certificates">Renew Certificates</a>.
</div>

## Access services using the proxy

To proxy traffic through this runtime, you'll need its external IP address.

To find the address, run:

```bash
$ kubectl get service kong-proxy -n kong
```

In the output, the IP in the `EXTERNAL_IP` column is the access point for
your {{site.konnect_saas}} services. Use this IP, along with any routes you set,
to access your services.

_<need output example and validation that this is true - the below is copied from an Enterprise install topic>_

```bash
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
```

For example, using the `EXTERNAL_IP` in the example above, access a service
with the route `/mock` at `35.233.198.16:443/mock`.
