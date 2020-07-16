---
title: Deploying Kong Enterprise in Hybrid Mode
beta: true
---

## Prerequisites
To get started with a Hybrid mode deployment, first install an instance of
{{site.ee_product_name}} with TLS to be your Control Plane (CP) node. See the
[installation documentation](/enterprise/{{page.kong_version}}/deployment/installation/overview)
for details.

We will bring up any subsequent Data Plane (DP) instances in this topic.

> Note: For a Hybrid mode deployment on Kubernetes, see [Hybrid mode](https://github.com/Kong/charts/blob/master/charts/kong/README.md#hybrid-mode)
in the `kong/charts` repository.

## Step 1: Generate a certificate/key pair
In Hybrid mode, a mutual TLS handshake (mTLS) is used for authentication so the
actual private key is never transferred on the network, and communication
between CP and DP nodes is secure.

Before using Hybrid mode, you need to generate a shared certificate/key pair.
This certificate/key pair is shared by both CP and DP nodes.

<div class="alert alert-warning">
  <i class="fas fa-exclamation-triangle" style="color:orange; margin-right:3px"></i>
  <strong>Protect the Private Key.</strong> Ensure the private key file can only be accessed by
  Kong nodes belonging to the cluster. If the key is compromised, you must
  regenerate and replace certificates and keys on all CP and DP nodes.
</div>

1. On an existing {{site.base_gateway}} instance, create a certificate/key pair:
    ```
    $ kong hybrid gen_cert
    ```
    This will generate `cluster.crt` and `cluster.key` files and save them to
    the current directory. By default, the certificate/key pair is valid for three
    years, but can be adjusted with the `--days` option. See `kong hybrid --help`
    for more usage information.

2. Copy the `cluster.crt` and `cluster.key` files to the same directory
on all Kong CP and DP nodes; e.g., `/cluster/cluster`.
    Set appropriate permissions on the key file so it can only be read by Kong.

## Step 2: Set up the Control Plane
Next, give the Control Plane node the `control_plane` role, and set
certificate/key parameters to point at the location of your `cluster.crt`
and `cluster.key`.

{% navtabs %}
{% navtab Using Docker %}

1. In your Docker container, set the following environment variables:

    ```bash
    KONG_ROLE=control_plane
    KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt
    KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key
    ```
    By setting the role of the node to `control_plane`, this node will listen on port
    `0.0.0.0:8005` by default for Data Plane connections. The `8005` port on the
    Control Plane will need to be accessible by all Data Planes it controls through
    any firewalls you may have in place.

    If you need to change the port that the Control Plane listens on, set:
    ```bash
    KONG_CLUSTER_LISTEN=0.0.0.0:<port>
    ```

2. Next, start Kong, or reload Kong if it's already running:
    ```
    $ kong start
    ```
    ```
    $ kong reload
    ```

{% endnavtab %}
{% navtab Using kong.conf %}
1. In `kong.conf`, set the following configuration parameters:
    ```
    role = control_plane
    cluster_cert = /<path-to-file>/cluster.crt
    cluster_cert_key = /<path-to-file>/cluster.key
    ```
    By setting the role of the node to `control_plane`, this node will listen on port
    `0.0.0.0:8005` by default for Data Plane connections. The `8005` port on the
    Control Plane will need to be accessible by all Data Planes it controls through
    any firewalls you may have in place.

    If you need to change the port that the Control Plane listens on, set:
    ```bash
    cluster_listen=0.0.0.0:<port>
    ```
2. Restart Kong for the settings to take effect:
    ```
    $ kong restart
    ```
{% endnavtab %}
{% endnavtabs %}

Note that the Control Plane still needs a database (Postgres or Cassandra) to
store the central configurations, although the database never needs to
be accessed by Data Plane nodes. You may run multiple Control Plane nodes to
provide load balancing and redundancy, as long as they all point to the same
backend database.

>**Note:** Control Plane nodes cannot be used for proxying.

## Step 3: Install and start Data Planes
Now that the Control Plane is running, you can attach Data Plane nodes to it to
start serving traffic.

In this step, you will give all Data Plane nodes the `data_plane` role,
point them to the Control Plane, set certificate/key parameters to point at
the location of your `cluster.crt` and `cluster.key`, and ensure the database
is disabled.

<div class="alert alert-warning">
<i class="fas fa-exclamation-triangle" style="color:orange; margin-right:3px"></i>
<b>Important:</b> Data Plane nodes receive updates from the Control Plane via a format
similar to declarative config, therefore the storage property has to be
set to <code>memory</code> for Kong to start up properly.
</div>

{% navtabs %}
{% navtab Using Docker %}
1. Using the [Docker installation documentation](/enterprise/{{page.kong_version}}/deployment/installation/docker),
follow the instructions to:
    1. [Download {{site.ee_product_name}}](/enterprise/{{page.kong_version}}/deployment/installation/docker#pull-image).
    2. [Create a Docker network](/enterprise/{{page.kong_version}}/deployment/installation/docker/#create-network).
    3. [Export the license key to a variable](/enterprise/{{page.kong_version}}/deployment/installation/docker/#license-key).

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. Bring up your Data Plane container with the following settings:

    ```bash
    $ docker run -d --name kong-ee-dp1 --network=kong-ee-net \
    -e "KONG_ROLE=data_plane" \
    -e "KONG_DATABASE=off" \
    -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
    -e "KONG_CLUSTER_CONTROL_PLANE=control-plane.<admin-hostname>.com:8005" \
    -e "KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt" \
    -e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key" \
    -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=/<path-to-file>/cluster.crt" \
    --mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
    -p 8000:8000 \
    kong-ee-dp1
    ```
    Where:
    * `KONG_CLUSTER_CONTROL_PLANE` is the address and port of the Control Plane
    (port `8005` by defaut).
    * `KONG_DATABASE` specifies whether this node connects directly to a database.
    * `KONG_LUA_SSL_TRUSTED_CERTIFICATE` lists the file as trusted by OpenResty.
    If you have already specified a different `lua_ssl_trusted_certificate`, then
    adding the content of `cluster.crt` into that file will achieve the same result.
    * `<path-to-file>` and `target=<path-to-keys-and-certs>` are the same path
    pointing to the location of the `cluster.key` and `cluster.crt` files.


3. If needed, bring up any subsequent Data Planes using the same settings.

{% endnavtab %}
{% navtab Using kong.conf %}

1. Find the documentation for [your platform](/enterprise/{{page.kong_version}}/deployment/installation),
and follow the instructions in Steps 1 and 2 **only** to download
{{site.ee_product_name}} and the Enterprise license, then install Kong.

    > **Note:** for Docker, see the **Docker** tab above. For Kubernetes, see the
    [Hybrid mode documentation](https://github.com/Kong/charts/blob/master/charts/kong/README.md#hybrid-mode)
    in the `kong/charts` repository.

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. In `kong.conf`, set the following configuration parameters:

    ```
    role = data_plane
    database = off
    cluster_control_plane = control-plane.<admin-hostname>.com:8005
    cluster_cert = /<path-to-file>/cluster.crt
    cluster_cert_key = /<path-to-file>/cluster.key
    lua_ssl_trusted_certificate = /<path-to-file>/cluster.crt
    ```

    Where:
    * `cluster_control_plane` is the address and port of the Control Plane
    (port `8005` by defaut).
    * `database` specifies whether this node connects directly to a database.
    * `lua_ssl_trusted_certificate` lists the file as trusted by OpenResty.
    If you have already specified a different `lua_ssl_trusted_certificate`, then
    adding the content of `cluster.crt` into that file will achieve the same result.
    * `<path-to-file>` is the location of the `cluster.key` and `cluster.crt` files.

3. Restart Kong for the settings to take effect:
    ```
    $ kong restart
    ```
{% endnavtab %}
{% endnavtabs %}

## Step 4: Verify that nodes are connected

Use the Control Plane’s Cluster Status API to monitor your Data Planes. It provides:
* The name of the node
* The last time the node synced with the Control Plane
* The version of the config currently running on each Data Plane

To check whether the CP and DP nodes you just brought up are connected, run the
following on a Control Plane:
{% navtabs %}
{% navtab Using cURL %}
```
$ curl -i -X GET http://<admin-hostname>:8001/clustering/status
```
{% endnavtab %}
{% navtab Using HTTPie %}
```bash
$ http :8001/clustering/status
```
{% endnavtab %}
{% endnavtabs %}
The output shows all of the connected Data Plane instances:

```bash
{
    "a08f5bf2-43b8-4f1c-bdf5-0a0ffb421c21": {
        "config_hash": "64d661f505f7e1de5b4c5e5faa1797dd",
        "hostname": "data-plane-2",
        "ip": "192.168.10.3",
        "last_seen": 1571197860
    },
    "e1fd4970-6d24-4dfb-b2a7-5a832a5de6e1": {
        "config_hash": "64d661f505f7e1de5b4c5e5faa1797dd",
        "hostname": "data-plane-1",
        "ip": "192.168.10.4",
        "last_seen": 1571197866
    }
}
```

## Next steps

Now, you can start managing the cluster using the Control Plane. Once
all instances are set up, use the Admin API on the Control Plane as usual, and
these changes will be synced and updated on the Data Plane nodes automatically
within seconds.
