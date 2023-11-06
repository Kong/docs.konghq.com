---
title: Troubleshooting
type: reference
purpose: |
  How do I figure out what's going wrong? How do I dump broken config?
---

## Debug

Using the flag `--v=XX` it is possible to increase the level of logging.
In particular:

- `--v=3` shows details about the service, Ingress rule, and endpoint changes

## Authentication to the Kubernetes API Server

A number of components are involved in the authentication process and the first step is to narrow
down the source of the problem, namely whether it is a problem with service authentication or with the kubeconfig file.
Both authentications must work:

```text
+-------------+   service          +------------+
|             |   authentication   |            |
+  apiserver  +<-------------------+  ingress   |
|             |                    | controller |
+-------------+                    +------------+

```

## Service authentication

The Ingress controller needs information from API server to configure Kong.
Therefore, authentication is required, which can be achieved in two different ways:

1. **Service Account**: This is recommended
   because nothing has to be configured.
   The Ingress controller will use information provided by the system
   to communicate with the API server.
   See 'Service Account' section for details.
1. **Kubeconfig file**: In some Kubernetes environments
   service accounts are not available.
   In this case, a manual configuration is required.
   The Ingress controller binary can be started with the `--kubeconfig` flag.
   The value of the flag is a path to a file specifying how
   to connect to the API server. Using the `--kubeconfig`
   does not require the flag `--apiserver-host`.
   The format of the file is identical to `~/.kube/config`
   which is used by `kubectl` to connect to the API server.
   See 'kubeconfig' section for details.

## Discovering API server

Using this flag `--apiserver-host=http://localhost:8080`,
it is possible to specify an unsecured API server or
reach a remote Kubernetes cluster using
[kubectl proxy](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#using-kubectl-proxy).
Please do not use this approach in production.

In the diagram below you can see the full authentication flow with all options, starting with the browser
on the lower left hand side.

```text

Kubernetes                                                  Workstation
+---------------------------------------------------+     +------------------+
|                                                   |     |                  |
|  +-----------+   apiserver        +------------+  |     |  +------------+  |
|  |           |   proxy            |            |  |     |  |            |  |
|  | apiserver |                    |  ingress   |  |     |  |  ingress   |  |
|  |           |                    | controller |  |     |  | controller |  |
|  |           |                    |            |  |     |  |            |  |
|  |           |                    |            |  |     |  |            |  |
|  |           |  service account/  |            |  |     |  |            |  |
|  |           |  kubeconfig        |            |  |     |  |            |  |
|  |           +<-------------------+            |  |     |  |            |  |
|  |           |                    |            |  |     |  |            |  |
|  +------+----+      kubeconfig    +------+-----+  |     |  +------+-----+  |
|         |<--------------------------------------------------------|        |
|                                                   |     |                  |
+---------------------------------------------------+     +------------------+
```

## Service Account

If using a service account to connect to the API server, Dashboard expects the file
`/var/run/secrets/kubernetes.io/serviceaccount/token` to be present. It provides a secret
token that is required to authenticate with the API server.

Verify with the following commands:

```shell
# start a container that contains curl
$ kubectl run test --image=tutum/curl -- sleep 10000

# check that container is running
$ kubectl get pods
NAME                   READY     STATUS    RESTARTS   AGE
test-701078429-s5kca   1/1       Running   0          16s

# check if secret exists
$ kubectl exec test-701078429-s5kca ls /var/run/secrets/kubernetes.io/serviceaccount/
ca.crt
namespace
token

# get service IP of master
$ kubectl get services
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   10.0.0.1     <none>        443/TCP   1d

# check base connectivity from cluster inside
$ kubectl exec test-701078429-s5kca -- curl -k https://10.0.0.1
Unauthorized

# connect using tokens
$ TOKEN_VALUE=$(kubectl exec test-701078429-s5kca -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)
$ echo $TOKEN_VALUE
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3Mi....9A
$ kubectl exec test-701078429-s5kca -- curl --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt -H  "Authorization: Bearer $TOKEN_VALUE" https://10.0.0.1
{
  "paths": [
    "/api",
    "/api/v1",
    "/apis",
    "/apis/apps",
    "/apis/apps/v1alpha1",
    "/apis/authentication.k8s.io",
    "/apis/authentication.k8s.io/v1beta1",
    "/apis/authorization.k8s.io",
    "/apis/authorization.k8s.io/v1beta1",
    "/apis/autoscaling",
    "/apis/autoscaling/v1",
    "/apis/batch",
    "/apis/batch/v1",
    "/apis/batch/v2alpha1",
    "/apis/certificates.k8s.io",
    "/apis/certificates.k8s.io/v1alpha1",
    "/apis/extensions",
    "/apis/extensions/v1beta1",
    "/apis/policy",
    "/apis/policy/v1alpha1",
    "/apis/rbac.authorization.k8s.io",
    "/apis/rbac.authorization.k8s.io/v1alpha1",
    "/apis/storage.k8s.io",
    "/apis/storage.k8s.io/v1beta1",
    "/healthz",
    "/healthz/ping",
    "/logs",
    "/metrics",
    "/swaggerapi/",
    "/ui/",
    "/version"
  ]
}
```

If it is not working, there are two possible reasons:

1. The contents of the tokens are invalid.
    Find the secret name:

    ```bash
    kubectl get secrets --field-selector=type=kubernetes.io/service-account-token
    ```
    Delete the secret:

    ```bash
    kubectl delete secret {SECRET_NAME}
    ```

    It will automatically be recreated.
1. You have a non-standard Kubernetes installation
   and the file containing the token may not be present.

The API server will mount a volume containing this file,
but only if the API server is configured to use
the ServiceAccount admission controller.
If you experience this error,
verify that your API server is using the ServiceAccount admission controller.
If you are configuring the API server by hand,
you can set this with the `--admission-control` parameter.
Please note that you should use other admission controllers as well.
Before configuring this option, please read about admission controllers.

More information:

- [User Guide: Service Accounts](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- [Cluster Administrator Guide: Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)

## Kubeconfig

If you want to use a kubeconfig file for authentication,
follow the deploy procedure and
add the flag `--kubeconfig=/etc/kubernetes/kubeconfig.yaml` to the deployment.

## Dumping generated Kong configuration

If the controller generates configuration that it cannot apply to Kong
successfully, reviewing the generated configuration manually and/or applying it
in a test environment can help locate potential causes.

Under normal operation, the controller does not store generated configuration;
it is only sent to Kong's Admin API. The `--dump-config` flag enables a
diagnostic mode where the controller also saves generated configuration to a
temporary file. To use the diagnostic mode:

1. Set the `--dump-config` flag (or `CONTROLLER_DUMP_CONFIG` environment
   variable) to `true`. Optionally set the `--dump-sensitive-config` flag to
   `true` to include un-redacted TLS certificate keys and credentials.

   If you're deploying with the Helm chart, add the following to your
   `values.yaml` file:

   ```yaml
   ingressController:
    env:
      dump_config: "true"
      dump_sensitive_config: "true"
    ```
1. (Optional) Make a change to a Kubernetes resource that you know will
   reproduce the issue. If you are unsure what change caused the issue
   originally, you can omit this step.
1. Port forward to the diagnostic server:
   ```bash
   kubectl port-forward -n CONTROLLER_NAMESPACE CONTROLLER_POD 10256:10256
   ```
1. Retrieve successfully- and/or unsuccessfully-applied configuration:
   ```bash
   curl -svo last_good.json localhost:10256/debug/config/successful
   curl -svo last_bad.json localhost:10256/debug/config/failed
   ```

Once you have dumped configuration, take one of the following
approaches to isolate issues:

- If you know of a specific Kubernetes resource change that reproduces the
  issue, diffing `last_good.json` and `last_bad.json` will show the change
  the controller is trying to apply unsuccessfully.
- You can apply dumped configuration via the `/config` Admin API endpoint
  (DB-less mode) or using decK (DB-backed mode) to a test instance not managed
  by the ingress controller. This approach lets you review requests
  and responses (passing `--verbose 2` to decK will show all requests) and
   add debug Kong Lua code when controller requests result in an
  unhandled error (500 response).
- To run a DB-less {{ site.base_gateway }} instance with Docker for testing
  purposes, run `curl https://get.konghq.com/quickstart | bash -s -- -D`.

  Once this image is running, run `curl http://localhost:8001/config @last_bad.json`
  to try applying the configuration and see any errors.

## Inspecting network traffic with a tcpdump sidecar

Inspecting network traffic allows you to review traffic between the ingress
controller and Kong admin API and/or between the Kong proxy and upstream
applications. You can use this in situations where logged information does not
provide you sufficient data on the contents of requests and you wish to see
exactly what was sent over the network.

Although you cannot install and use tcpdump within the controller
or Kong containers, you can add a tcpdump sidecar to your Pod's containers. The
sidecar will be able to sniff traffic from other containers in the Pod. You can
edit your Deployment (to add the sidecar to all managed Pods) or a single Pod
and add the following under the `containers` section of the Pod spec:

```yaml
- name: tcpdump
  securityContext:
    runAsUser: 0
  image: corfr/tcpdump
  command:
    - /bin/sleep
    - infinity
```

```bash
kubectl patch --type=json -n kong deployments.apps ingress-kong -p='[{
  "op":"add",
  "path":"/spec/template/spec/containers/-",
  "value":{
    "name":"tcpdump",
    "securityContext":{
        "runAsUser":0
    },
    "image":"corfr/tcpdump",
    "command":["/bin/sleep","infinity"]
  }
}]'
```

If you are using the Kong Helm chart, you can alternately add this to the
`sidecarContainers` section of values.yaml.

Once the sidecar is running, you can use `kubectl exec -it POD_NAME -c tcpdump`
and run a capture. For example, to capture traffic between the controller and
Kong admin API:

```bash
tcpdump -npi any -s0 -w /tmp/capture.pcap host 127.0.0.1 and port 8001
```

or between Kong and an upstream application with endpoints `10.0.0.50` and
`10.0.0.51`:

```bash
tcpdump -npi any -s0 -w /tmp/capture.pcap host 10.0.0.50 or host 10.0.0.51
```

Once you've replicated the issue, you can stop the capture, exit the
container, and use `kubectl cp` to download the capture from the tcpdump
container to a local system for review with
[Wireshark](https://www.wireshark.org/).

Note that you will typically need to temporarily disable TLS to inspect
application-layer traffic. If you have access to the server's private keys you
can [decrypt TLS](https://wiki.wireshark.org/TLS#TLS_Decryption), though this
does not work if the session uses an ephemeral cipher (neither the controller
nor Kong proxy have support for dumping session secrets).

## Gathering profiling data

The controller provides access to [the Golang
profiler](https://pkg.go.dev/net/http/pprof), which provides diagnostic
information on memory and CPU consumption within the program.

To enable profiling and access it, set `CONTROLLER_PROFILING=true` in the
controller container environment (`ingressController.env.profiling: true` using
the Helm chart), wait for the Deployment to restart, run `kubectl
port-forward <POD_NAME> 10256:10256`, and visit `http://localhost:10256/debug/pprof/`.

## Identify and fix an invalid configuration

Kubernetes resources can request configuration that {{site.kic_product_name}}
can't translate into a valid {{site.base_gateway}} configuration. While the
[admission webhook](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/admission-webhook/)
can reject some invalid configurations during creation and the controller can
fix some invalid configurations on its own, some configuration issues require
you to review and fix them. When such issues arise, {{site.kic_product_name}}
creates Kubernetes Events to help you identify problem resources and understand
how to fix them.

To determine if there are any translation failures that you might want to fix, you
can monitor the `ingress_controller_translation_count` [Prometheus metric](/kubernetes-ingress-controller/{{page.kong_version}}/production/observability/prometheus/).

### Monitor for issues that require manual fixes

{{site.kic_product_name}}'s [Prometheus metrics](/kubernetes-ingress-controller/{{page.kong_version}}/production/observability/prometheus/)
include `ingress_controller_translation_count` and
`ingress_controller_configuration_push_count` counters. Issues that require
human intervention add `success=false` tallies to these counters.

{{site.kic_product_name}} also generates error logs with a `could not update
kong admin` for configuration push failures.

### Finding problem resource Events

{{ site.kic_product_name }} provides Kubernetes Events to help understand the state of your system. Events occur when an invalid configuration is rejected by {{ site.base_gateway }} (`KongConfigurationApplyFailed`) or when an invalid configuration such as an upstream service that does not exist is detected (`KongConfigurationTranslationFailed`)..

For more information, see [Events](/kubernetes-ingress-controller/{{ page.release }}/production/observability/events/).