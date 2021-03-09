---
title: Multi-zone authentication
---

Kong Mesh provides a built-in method for authentication of Remote Control Plane.
Endpoints for synchronizing Global with Remote are often exposed across many clouds therefore secure setup is crucial. You should generate a control plane token for each remote control plane in your environment.

The control plane token is a JWT that contains:

- The name of the zone the token is generated for
- The token's serial number, used for token rotation

Here's what to do:

- Generate a token for each remote control plane.
- Add the token to the configuration for each remote zone.
- Enable authentication on the global control plane.

## Generate token for each remote zone

On the global control plane, [authenticate](https://kuma.io/docs/latest/security/certificates/#user-to-control-plane-communication) and run the following command:

```
$ kumactl generate control-plane-token --zone=west > /tmp/token
$ cat /tmp/token
```

The generated token looks like:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ
```

For authentication to the global control plane on Kubernetes, you can port-forward port 5681 port to access the API.

## Add token to each remote configuration

{% navtabs %}
{% navtab Kubernetes with kumactl %}

If you install the remote control plane with `kumactl install control-plane`, pass the `--cp-token-path` argument, where the value is the path to the file where the token is stored:

```
$ kumactl install control-plane \
  --mode=remote \
  --zone=<zone name> \
  --cp-token-path=/tmp/token
  --ingress-enabled \
  --kds-global-address grpcs://`<global-kds-address>` | kubectl apply -f - 
```

{% endnavtab %}
{% navtab Kubernetes with Helm %}

Create a secret with a token in the same namespace where Kong Mesh is installed:

```
$ kubectl create secret generic cp-token -n kong-mesh-system --from-file=/tmp/token
```

Add the following to `Values.yaml`:
```yaml
kuma:
  controlPlane:
    secrets:
      - Env: "KMESH_MULTIZONE_REMOTE_KDS_AUTH_CP_TOKEN_INLINE"
        Secret: "cp-token"
        Key: "token"
```


{% endnavtab %}
{% navtab Universal %}

Either:

- Set the token as an inline value in a `KMESH_MULTIZONE_REMOTE_KDS_AUTH_CP_TOKEN_INLINE` environment variable:

```sh
$ KUMA_MODE=remote \
  KUMA_MULTIZONE_REMOTE_ZONE=<zone-name> \
  KUMA_MULTIZONE_REMOTE_GLOBAL_ADDRESS=grpcs://<global-kds-address> \
  KMESH_MULTIZONE_REMOTE_KDS_AUTH_CP_TOKEN_INLINE="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ" \
  ./kuma-cp run
```

OR

- Store the token in a file, then set the path to the file in a `KMESH_MULTIZONE_REMOTE_KDS_AUTH_CP_TOKEN_PATH` environment variable.
```sh
$ KUMA_MODE=remote \
  KUMA_MULTIZONE_REMOTE_ZONE=<zone-name> \
  KUMA_MULTIZONE_REMOTE_GLOBAL_ADDRESS=grpcs://<global-kds-address> \
  KMESH_MULTIZONE_REMOTE_KDS_AUTH_CP_TOKEN_PATH="/tmp/token" \
  ./kuma-cp run
```

{% endnavtab %}
{% endnavtabs %}

## Enable authentication on the global control plane

{% navtabs %}
{% navtab Kubernetes with kumactl %}

If you install the remote control plane with `kumactl install control-plane`, pass the `--cp-auth` argument with the value `cpToken`:

```sh
$ kumactl install control-plane \
  --mode=global
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

Create and add a new token for each remote control plane. These tokens are automatically created with the signing key that's assigned the highest serial number, so they're created with the new signing key.

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

## Security

By default, a connection from the Remote Control Plane to the Global Control Plane is secured by TLS, but it is recommended to configure Remote Control Plane to verify certificates of Global Control Plane.
Consult `Control Plane to Control Plane communication` section on [Kuma Docs](https://kuma.io/docs/1.0.8/security/certificates/).

## Example token

An example of the Control Plane Token
```
$ kumactl generate control-plane-token --zone=west
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ
$ kumactl generate control-plane-token --zone=west | jwt
To verify on jwt.io:
https://jwt.io/#id_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJab25lIjoid2VzdCIsIlRva2VuU2VyaWFsTnVtYmVyIjoxfQ.kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ
✻ Header
{
  "alg": "HS256",
  "typ": "JWT"
}
✻ Payload
{
  "Zone": "west",
  "TokenSerialNumber": 1
}
✻ Signature kIrS5W0CPMkEVhuRXcUxk3F_uUoeI3XK1Gw-uguWMpQ
```

Control Plane Token is signed by the _Signing Key_ (SHA256) which is autogenerated and kept on Global Control Plane.

```
$ kumactl get global-secrets
NAME                             AGE
control-plane-signing-key-0001   36m
```

