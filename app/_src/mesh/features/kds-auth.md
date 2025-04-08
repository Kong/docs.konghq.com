---
title: Multi-zone authentication
badge: enterprise
---

To add to the security of your deployments, {{site.mesh_product_name}} provides authentication of zone control planes to the global control plane.
Authentication is based on the Zone Token which is also used to authenticate the zone proxy.
See [zone proxy authentication][zone-proxy] to learn about token characteristics, revocation, rotation, and more.

{{site.mesh_product_name}} introduces additional `cp` scope. Only tokens with `cp` scope can be used to authenticate with the zone control plane.

## Set up tokens

To generate the tokens you need and configure your clusters:

- Generate a token for each zone control plane.
- Add the token to the configuration for each zone.
- Enable authentication on the global control plane.

### Generate token for each zone

On the global control plane, [authenticate][auth] and run the following command:

```sh
kumactl generate zone-token --zone=west --scope=cp --valid-for=720h > /tmp/token
```

View the token:
```sh
cat /tmp/token
```

The generated token looks like:

```
eyJhbGciOiJSUzI1NiIsImtpZCI6IjEiLCJ0eXAiOiJKV1QifQ.eyJab25lIjoid2VzdCIsIlNjb3BlIjpbImNwIl0sImV4cCI6MTY2OTU0NjkzOSwibmJmIjoxNjY2OTU0NjM5LCJpYXQiOjE2NjY5NTQ5MzksImp0aSI6IjZiYWYyYzkwLTBlODYtNGM2Mi05N2E3LTc4MzU4NTU4MzRiYyJ9.DJfA0M6uUfO4oytp8jHtzngiVggQWQR88YQxWVU1ujc0Zv-XStRDwvpdEoFGOzWVn4EUfI3gcv9qS2MxqIzQjJ83k5Jq85w4hkPyLGr-0jNS1UZF6yXz7lB_As8f91gMVHbRAoFuoybV5ndDtfYzwZknyzott7doxk-SjTes2GDvpg0-kFNGc4MBR2EprGl7YKO0vhFxQjln5AyCAhmAA7-PM7WRCzhmS-pUXacfZtP2VulWYhmTAuLPnkJrJN-ZWPkIpnV1MZmsgWbzTpnW-PhmCMQfD5m2im1c_3OlFwa9P9rZQQhdhbTp0ofMvW-cdCAcG_lOJI5j60cqPh2DGg
```

For authentication to the global control plane on Kubernetes, you can port-forward port 5681 to access the API.

### Add token to each zone configuration

{% navtabs %}
{% navtab Kubernetes with kumactl %}

If you install the zone control plane with `kumactl install control-plane`, pass the `--cp-token-path` argument, where the value is the path to the file where the token is stored:

```sh
kumactl install control-plane \
  --mode=zone \
  --zone=<zone name> \
  --cp-token-path=/tmp/token \
  --ingress-enabled \
  --kds-global-address grpcs://`<global-kds-address>`:5685 | kubectl apply -f -
```

{% endnavtab %}
{% navtab Kubernetes with Helm %}

Create a secret with a token in the same namespace where {{site.mesh_product_name}} is installed:

```sh
kubectl create secret generic cp-token -n kong-mesh-system --from-file=/tmp/token
```

Add the following to `Values.yaml`:
```yaml
kuma:
  controlPlane:
    secrets:
      - Env: "KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE"
        Secret: "cp-token"
        Key: "token"
```


{% endnavtab %}
{% navtab Universal %}

Either:

- Set the token as an inline value in a `KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE` environment variable:

```sh
KUMA_MODE=zone \
KUMA_MULTIZONE_ZONE_NAME=<zone-name> \
KUMA_MULTIZONE_ZONE_GLOBAL_ADDRESS=grpcs://<global-kds-address> \
KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE="eyJhbGciOiJSUzI1NiIsImtpZCI6IjEiLCJ0eXAiOiJKV1QifQ.eyJab25lIjoid2VzdCIsIlNjb3BlIjpbImNwIl0sImV4cCI6MTY2OTU0NjkzOSwibmJmIjoxNjY2OTU0NjM5LCJpYXQiOjE2NjY5NTQ5MzksImp0aSI6IjZiYWYyYzkwLTBlODYtNGM2Mi05N2E3LTc4MzU4NTU4MzRiYyJ9.DJfA0M6uUfO4oytp8jHtzngiVggQWQR88YQxWVU1ujc0Zv-XStRDwvpdEoFGOzWVn4EUfI3gcv9qS2MxqIzQjJ83k5Jq85w4hkPyLGr-0jNS1UZF6yXz7lB_As8f91gMVHbRAoFuoybV5ndDtfYzwZknyzott7doxk-SjTes2GDvpg0-kFNGc4MBR2EprGl7YKO0vhFxQjln5AyCAhmAA7-PM7WRCzhmS-pUXacfZtP2VulWYhmTAuLPnkJrJN-ZWPkIpnV1MZmsgWbzTpnW-PhmCMQfD5m2im1c_3OlFwa9P9rZQQhdhbTp0ofMvW-cdCAcG_lOJI5j60cqPh2DGg" \
./kuma-cp run
```

OR

- Store the token in a file, then set the path to the file in a `KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE` environment variable.
```sh
KUMA_MODE=zone \
KUMA_MULTIZONE_ZONE_NAME=<zone-name> \
KUMA_MULTIZONE_ZONE_GLOBAL_ADDRESS=grpcs://<global-kds-address> \
KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_PATH="/tmp/token" \
./kuma-cp run
```

{% endnavtab %}
{% endnavtabs %}

### Enable authentication on the global control plane

If you are starting from scratch and not securing existing {{site.mesh_product_name}} deployment, you can do this as a first step.

{% navtabs %}
{% navtab Kubernetes with kumactl %}

If you install the zone control plane with `kumactl install control-plane`, pass the `--cp-auth` argument with the value `cpToken`:

```sh
kumactl install control-plane \
  --mode=global \
  --cp-auth=cpToken | kubectl apply -f -
```

{% endnavtab %}
{% navtab Kubernetes with Helm %}

Add the following to `Values.yaml`:

```yaml
kuma:
  controlPlane:
    envVars:
      KMESH_MULTIZONE_GLOBAL_KDS_AUTH_TYPE: cpToken
```

{% endnavtab %}
{% navtab Universal %}

Set `KMESH_MULTIZONE_GLOBAL_KDS_AUTH_TYPE` to `cpToken`:

```sh
KUMA_MODE=global \
KMESH_MULTIZONE_GLOBAL_KDS_AUTH_TYPE=cpToken \
./kuma-cp run
```

{% endnavtab %}
{% endnavtabs %}

Verify the zone control plane is connected with authentication by looking at the global control plane logs:

```
2021-02-24T14:30:38.596+0100	INFO	kds.auth	Zone CP successfully authenticated	{"zone": "cluster-2"}
```

## Additional security

By default, a connection from the zone control plane to the global control plane is secured with TLS. You should also configure the zone control plane to [verify the certificate authority (CA) of the global control plane][certs].

{% if_version lte:2.9.x %}

## Legacy Control Plane Token

You can still authenticate a control plane using the separate [Control Plane Token](/mesh/{{page.release}}/features/kds-auth/), but it is deprecated and will be removed in the future.

{% endif_version %}

<!-- links -->
[zone-proxy]: /mesh/{{page.release}}/production/cp-deployment/zoneproxy-auth
[auth]: /mesh/{{page.release}}/production/secure-deployment/certificates/#data-plane-proxy-to-control-plane-communication
[certs]: /mesh/{{page.release}}/production/secure-deployment/certificates/#control-plane-to-control-plane-multizone
