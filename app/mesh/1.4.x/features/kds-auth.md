---
title: Multi-zone authentication
---

To add to the security of your deployments, {{site.mesh_product_name}} provides token generation for authenticating remote control planes to the global control plane.

The control plane token is a JWT that contains:

- The name of the zone the token is generated for
- The token's serial number, used for token rotation

The control plane token is signed by a signing key that is autogenerated on the global control plane. The signing key is SHA256 encrypted.

You can check for the signing key:

```
$ kumactl get global-secrets
```

which returns something like:

```
NAME                             AGE
control-plane-signing-key-0001   36m
```

## Set up tokens

To generate the tokens you need and configure your clusters:

- Generate a token for each remote control plane.
- Add the token to the configuration for each remote zone.
- Enable authentication on the global control plane.

### Generate token for each remote zone

On the global control plane, [authenticate](/mesh/latest/production/secure-deployment/certificates/#user-to-control-plane-communication) and run the following command:

```
$ kumactl generate control-plane-token --zone=west > /tmp/token
$ cat /tmp/token
```

The generated token looks like:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ
```

For authentication to the global control plane on Kubernetes, you can port-forward port 5681 to access the API.

### Add token to each zone configuration

{% navtabs %}
{% navtab Kubernetes with kumactl %}

If you install the zone control plane with `kumactl install control-plane`, pass the `--cp-token-path` argument, where the value is the path to the file where the token is stored:

```
$ kumactl install control-plane \
  --mode=zone \
  --zone=<zone name> \
  --cp-token-path=/tmp/token \
  --ingress-enabled \
  --kds-global-address grpcs://`<global-kds-address>` | kubectl apply -f - 
```

{% endnavtab %}
{% navtab Kubernetes with Helm %}

Create a secret with a token in the same namespace where {{site.mesh_product_name}} is installed:

```
$ kubectl create secret generic cp-token -n kong-mesh-system --from-file=/tmp/token
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
$ KUMA_MODE=zone \
  KUMA_MULTIZONE_ZONE_NAME=<zone-name> \
  KUMA_MULTIZONE_ZONE_GLOBAL_ADDRESS=grpcs://<global-kds-address> \
  KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ" \
  ./kuma-cp run
```

OR

- Store the token in a file, then set the path to the file in a `KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE` environment variable.
```sh
$ KUMA_MODE=zone \
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
$ kumactl install control-plane \
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
$ KUMA_MODE=global \
  KMESH_MULTIZONE_GLOBAL_KDS_AUTH_TYPE=cpToken \
  ./kuma-cp run
```

{% endnavtab %}
{% endnavtabs %}

Verify the remote control plane is connected with authentication by looking at the global control plane logs:

```
2021-02-24T14:30:38.596+0100	INFO	kds.auth	Remote CP successfully authenticated using Control Plane Token	{"tokenSerialNumber": 1, "zone": "cluster-2"}
```

## Rotate tokens

If a control plane token or signing key is compromised, you must rotate all tokens.

### Generate new signing key

The signing key is stored as a `GlobalSecret` with a name that looks like `control-plane-signing-key-{serialNumber}`.

Make sure to generate the new signing key with a serial number greater than the serial number of the current signing key.


{% navtabs %}
{% navtab Kubernetes %}

Check what is the current highest serial number.

```sh
$ kubectl get secrets -n kong-mesh-system --field-selector='type=system.kuma.io/global-secret'
NAME                             TYPE                           DATA   AGE
control-plane-signing-key-0001   system.kuma.io/global-secret   1      25m
```

In this case, the highest serial number is `0001`. Generate a new Signing Key with a serial number of `0002`

```sh
$ TOKEN="$(kumactl generate signing-key)" && echo "
apiVersion: v1
data:
  value: $TOKEN
kind: Secret
metadata:
  name: control-plane-signing-key-0002
  namespace: kong-mesh-system
type: system.kuma.io/global-secret
" | kubectl apply -f - 
```

{% endnavtab %}
{% navtab Universal %}

Check what is the current highest serial number.

```sh
$ kumactl get global-secrets
NAME                             AGE
control-plane-signing-key-0001   36m
```

In this case, the highest serial number is `0001`. Generate a new Signing Key with a serial number of `0002`

```sh
echo "
type: GlobalSecret
name: control-plane-signing-key-0002
data: {{ key }}
" | kumactl apply --var key=$(kumactl generate signing-key) -f -
```

{% endnavtab %}
{% endnavtabs %}

### Regenerate control plane tokens

Create and add a new token for each zone control plane. These tokens are automatically created with the signing key that's assigned the highest serial number, so they're created with the new signing key.

Make sure the new signing key is available; otherwise old and new tokens are created with the same signing key and can both provide authentication.

### Remove the old signing key

{% navtabs %}
{% navtab Kubernetes %}

```sh
$ kubectl delete secret control-plane-signing-key-0001 -n kong-mesh-system
```

{% endnavtab %}
{% navtab Universal %}

```sh
$ kumactl delete global-secret control-plane-signing-key-0001
```

{% endnavtab %}
{% endnavtabs %}

All new connections to the global control plane now require tokens signed with the new signing key.

### Restart the global control plane

Restart all instances of the global control plane. All connections are now authenticated with the new tokens.

## Explore an example token

You can decode the tokens to validate the signature or explore details.

For example, run:
```
$ kumactl generate control-plane-token --zone=west
```

which returns:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ
```

Paste the token into the UI at jwt.io, or run

```
$ kumactl generate control-plane-token --zone=west | jwt
```

The result looks like:

![JWT token decoded](/assets/images/docs/mesh/jwt-decoded.png)

## Additional security

By default, a connection from the zone control plane to the global control plane is secured with TLS. You should also configure the zone control plane to [verify the certificate authority (CA) of the global control plane](/mesh/latest/production/secure-deployment/certificates/#control-plane-to-control-plane-multizone){:target="_blank"}.