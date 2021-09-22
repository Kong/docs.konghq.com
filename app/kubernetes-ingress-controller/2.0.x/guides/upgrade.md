---
title: Upgrading from 1.3.x to 2.0.x
---

This guide walks through backwards incompatible changes in the Kong Kubernetes
Ingress Controller (KIC) from v1.3.x to v2.0.x to help operators evaluate if any
changes to their configuration are needed to upgrade, provides
guidance on how to build testing environments to validate the upgrade, and
walks through an upgrade of the Kubernetes Ingress Controller (KIC) using
its [Helm Chart][chart].

## Prerequisites

* [Helm v3][helm] is installed
* You are familiar with Helm `install` and `upgrade` operations. See the [documentation for Helm v3][helm-docs].

> **Note:** Deploying and upgrading via Helm is the supported mechanism for
production deployments of KIC. If you're deploying KIC using Kustomize or
some other mechanism, you need to develop and test your own upgrade strategy
based on the following examples.

[helm]:https://helm.sh/
[chart]:https://github.com/kong/charts
[list-releases]:https://v3.helm.sh/docs/helm/helm_list/
[helm-docs]:https://v3.helm.sh/docs/

## Breaking changes

Mechanically the `helm upgrade` is backwards compatible, but the KIC 2.0.x release
includes some breaking changes for options and controller operations:

- Several controller manager flags were [removed or changed](#flag-changes)
- The [format of controller manager logs](#logging-differences) has changed, 
and logs are now produced by multiple controllers instead of one
- The admission webhook now requires clients that support TLS 1.2 or later.
See the [KIC Changelog][changelog] for all changes in this release.

[changelog]:https://github.com/kong/kubernetes-ingress-controller/blob/main/CHANGELOG.md

### Flag Changes

If you don't have a heavily customized KIC deployment (for example,
if you use standard `values.yaml` options and flags for your Helm deployment
of the KIC), then the following flag changes likely have no impact on you.

However, if you previously set custom arguments for the controller with
options like `ingressController.args`, pay careful attention to the following
sections and make adjustments to your config.

#### Removed flags

The following general purpose flags have been removed from the controller manager:

- `--version`
- `--alsologtostderr`
- `--logtostderr`
- `--v`
- `--vmodule`

Support for deprecated `classless` ingress types has been removed:

- `--process-classless-ingress-v1beta1`
- `--process-classless-ingress-v1`
- `--process-classless-kong-consumer`

#### Changed flags

The following `Ingress` controller toggles have been replaced:

- `--disable-ingress-extensionsv1beta1` has been replaced by `--enable-controller-ingress-extensionsv1beta1=false`
- `--disable-ingress-networkingv1` has been replaced by `--enable-controller-ingress-networkingv1=false`
- `--disable-ingress-networkingv1beta1` has been replaced by `--enable-controller-ingress-networkingv1beta1=false`

If you're affected by these flag changes, review the
[Independent Controller Toggling](#independent-controller-toggling) section for more context.

The `--dump-config` flag is now a boolean:

- `true` replaces the old `enabled` value
- `false` replaces the old `disabled` value
- `true` with the additional new `--dump-sensitive-config=true` flag replaces the old `sensitive` value

### Logging Differences

In versions of the KIC prior to v2.0.0 logging output included a large startup
header and the majority of logs were produced by a single logging entity. For example:

```
-------------------------------------------------------------------------------
Kong Ingress controller
-------------------------------------------------------------------------------

W0825 14:48:18.084560       1 client_config.go:614] Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
time="2021-08-25T14:48:18Z" level=info msg="version of kubernetes api-server: 1.21" api-server-host="https://10.96.0.1:443" git_commit=5e58841cce77d4bc13713ad2b91fa0d961e69192 git_tree_state=clean git_version=v1.21.1 major=1 minor=21 platform=linux/amd64
time="2021-08-25T14:48:19Z" level=info msg="kong version: 2.5.0" kong_version=2.5.0
time="2021-08-25T14:48:19Z" level=info msg="datastore strategy for kong: off"
time="2021-08-25T14:48:19Z" level=info msg="chosen Ingress API version: networking.k8s.io/v1"
time="2021-08-25T14:48:55Z" level=info msg="started leading" component=status-syncer
time="2021-08-25T14:48:55Z" level=info msg="syncing configuration" component=controller
time="2021-08-25T14:48:55Z" level=info msg="no configuration change, skipping sync to kong" component=controller
```

This previous architecture had a single controller that was responsible for all
supported resources (for example, `Ingress` or `TCPIngress`) and logged for them.

In addition to increasing logging output to help identify problems
and conditions during the controller manager runtime, v2.0.0 introduced
individual controllers for each supported API type. There is
now logging metadata specific to these components. For example:

```
time="2021-08-25T15:01:37Z" level=info msg="Starting EventSource" logger=controller-runtime.manager.controller.ingress reconciler group=networking.k8s.io reconciler kind=Ingress
time="2021-08-25T15:01:53Z" level=info msg="updating the proxy with new Ingress" NetV1Ingress="{\"Namespace\":\"default\",\"Name\":\"httpbin-ingress-v1beta1\"}" logger=controllers.Ingress.netv1 name=httpbin-ingress-v1beta1 namespace=default
time="2021-08-25T15:01:54Z" level=info msg="successfully synced configuration to kong." subsystem=proxy-cache-resolver
```

In these example log entries, note the `logger=controllers.Ingress.netv1` component.
This helps identify specific components so that operators can more
easily search for these components when reviewing logs.

If you and your team depend on logging output as a significant
component of KIC administration in your organization, we recommend deploying v2.0.x
in a non-production environment before upgrading. Set up a
[testing environment](#testing-environment) and familiarize yourself with the new
logging characteristics.

### Independent Controller Toggling

In v2.0.x, KIC separates its single monolithic controller into several
independent ones focused on specific APIs.

With the v2.0.x release, these independent controllers can be individually
enabled or disabled with the new `--enable-controller-{NAME}` flags provided
for the controller manager.

Autonegotiation of the Ingress API version (for example, `extensions/v1beta1` or
`networking/v1`) has been disabled and you now have to set
**exactly one** option for these specific controllers:

- `--enable-controller-ingress-extensionsv1beta1`
- `--enable-controller-ingress-networkingv1`
- `--enable-controller-ingress-networkingv1beta1`

In most cases, and with versions of Kubernetes greater than `v1.19.x`, you can use
the default value of `networking/v1`.

See the [CLI Arguments Reference][flags] for a full list of these new options
and their default values.

[flags]:/kubernetes-ingress-controller/{{page.kong_version}}/references/cli-arguments/


## Testing environment

To avoid issues with the upgrade, run it in a test environment before
deploying it to production. Create a [Kubernetes][k8s] cluster
using the same tools that deployed your production cluster, or use
a local development cluster such as [minikube][minikube] or [kind][kind].

Using Helm, check the deployed chart version:

{% navtabs codeblock %}
{% navtab Command %}

```shell
$ helm list -A
```

{% endnavtab %}
{% navtab Response %}

```shell
NAME               NAMESPACE   STATUS   CHART      APP VERSION
ingress-controller kong-system deployed kong-2.3.0 2.5
```

{% endnavtab %}
{% endnavtabs %}

In the above example, `kong-2.3.0` is the currently deployed chart version.

Using the existing chart version and the `values.yaml` configuration for
your production environment, deploy a copy to your test cluster
with the `--version` flag:

```shell
$ helm install kong-upgrade-testing kong/kong \
  --version ${YOUR_VERSION} \
  -f ${PATH_TO_YOUR_VALUES_FILE}
```
> **Note:** You may need to adjust your chart further to work in a development or
staging environment. See the [Helm chart documentation][chart-docs].
Use this testing environment to walk through the following
[upgrade steps](#upgrade) and ensure there are no problems during the
upgrade process. Once you're satisfied everything is ready,
switch to the production cluster and work through the upgrade steps again.

[k8s]:https://kubernetes.io
[minikube]:https://github.com/kubernetes/minikube
[kind]:https://github.com/kubernetes-sigs/kind
[chart-docs]: https://helm.sh/docs/topics/charts/
## Upgrade

### Configure Helm repository

Check the local `helm` installation to make sure it has the
[Kong Charts Repository][chart] loaded:

{% navtabs codeblock %}
{% navtab Command %}

```shell
helm repo list
```

{% endnavtab %}
{% navtab Response %}

```shell
NAME    URL
kong    https://charts.konghq.com
```

{% endnavtab %}
{% endnavtabs %}

If the repository is not present, add it:

```shell
$ helm repo add kong https://charts.konghq.com
```

Update the repository to pull the latest repository updates:

{% navtabs codeblock %}
{% navtab Command %}

```shell
helm repo update
```

{% endnavtab %}
{% navtab Response %}

```shell
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kong" chart repository
Update Complete. ⎈Happy Helming!⎈
```

{% endnavtab %}
{% endnavtabs %}

### Perform the upgrade

Run the following command, specifying the old release name, the namespace where
you've configured Kong Gateway, and the existing `values.yaml` configuration file:

```shell
$ helm upgrade ${YOUR_RELEASE_NAME} kong/kong \
  --namespace ${YOUR_NAMESPACE} \
  -f ${PATH_TO_YOUR_VALUES_FILE}
```

After the upgrade completes there is a brief period of time before the new
resources are online. You can wait for the relevant Pod resources to complete
by watching them in your release namespace:

```shell
$ kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

Once the new pods are in a `Ready` state, the upgrade is complete.

### Rollback

If you run into problems during or after the upgrade, Helm provides a
rollback mechanism to revert to a previous revision of the release:

```shell
$ helm rollback --namespace ${YOUR_RELEASE_NAMESPACE} ${YOUR_RELEASE_NAME}
```

You can wait for the rollback to complete by watching the relevant Pod
resources:

```shell
$ kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

After a rollback, if you ran into issues in production,
consider using a [testing environment](#testing-environment) to
identify and correct these issues, or reference the
[troubleshooting documentation][troubleshooting].

[troubleshooting]:/kubernetes-ingress-controller/{{page.kong_version}}/troubleshooting/
