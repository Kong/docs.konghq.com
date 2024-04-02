---
title: Upgrading to Kong 3.x
---

This guide covers the changes required when upgrading an ingress
controller-managed Kong instance from 2.x to 3.x.

## Prerequisites

* [Helm v3][helm] is installed
* You are familiar with Helm `install` and `upgrade` operations. See the [documentation for Helm v3][helm-docs].

{:.note}
> **Note:** Deploying and upgrading via the [Helm chart][chart] is the
supported mechanism for production deployments of KIC. If you're deploying KIC
using Kustomize or some other mechanism, you need to develop and test your own
upgrade strategy based on the following examples.

[helm]:https://helm.sh/
[chart]:https://github.com/kong/charts
[helm-docs]:https://v3.helm.sh/docs/

### Update CRDs

KIC 2.7 includes {{site.base_gateway}} 3.x compatibility changes to the controller CRDs.
Helm does not update CRDs automatically.
You must apply them manually before upgrading KIC:

```bash
kubectl apply -f https://raw.githubusercontent.com/Kong/charts/main/charts/kong/crds/custom-resource-definitions.yaml
```

## Upgrade your KIC version

KIC 2.7 is the first version that supports Kong 3.x. You must upgrade to KIC
2.7 before upgrading to Kong 3.x. See the [KIC Changelog][changelog] for all
changes in this release.

[changelog]:https://github.com/kong/kubernetes-ingress-controller/blob/main/CHANGELOG.md#270

2.7 includes a minor breaking change that affects the `CombinedRoutes` feature
gate, but is otherwise not expected to require changes to the existing
configuration.

Because KIC 2.7 is compatible with all 2.x {{site.base_gateway}} releases, you should upgrade it and
the chart first:

```shell
helm repo update
```

```shell
helm upgrade ${YOUR_RELEASE_NAME} kong/kong \
  --namespace ${YOUR_NAMESPACE} \
  -f ${PATH_TO_YOUR_VALUES_FILE} \
  --version 2.13.0 \
  --set ingressController.image.tag="2.7"
```

2.13 is the first chart version that supports 2.7. You can use later versions
if available.

## Update Ingress regular expression paths for Kong 3.x compatibility

Kong 3.x includes a number of its own [breaking changes](/gateway/changelog/#breaking-changes-and-deprecations),
but most don't affect its interactions with KIC, or are handled automatically
by 2.7 changes. You should still review the changelog for changes that don't
interact with KIC, such as changes to `kong.conf` or environment variable settings,
and changes to the PDK that affect custom plugins.

Kong 3.x includes changes to regular expression path handling, which _do_ require
manual updates to Ingress configuration. In Kong 2.x, Kong applied a heuristic based
on the presence of special characters in a route path to determine if a path
was a regular expression. This heuristic was imperfect and {{site.base_gateway}} 3.x removed
it, and instead requires that any regular expression begins with a `~` prefix.
Ingress does not allow paths that begin with any character other than `/`,  so Ingress rules with a regular expression path must begin with `/~`
instead.

Ingress rule paths have no way to indicate that a path is a regular expression.
The `ImplementationSpecific` path type can contain either regular expression or
non-regular expression paths. If you have existing Ingresses with regular
expression paths, those paths will break if you upgrade
to 3.x without updating configuration.

{:.important}
> **Important**: `Prefix` and `Exact` rules [must never use regular expressions](/kubernetes-ingress-controller/{{page.release}}/concepts/ingress-versions/#networkingk8siov1).
Only use regular expressions in `ImplementationSpecific` rules.

The new 3.x paths are also incompatible with 2.x. Adding the `/~` prefix to
Ingress rules directly breaks incremental upgrades. To smooth the migration
process and allow users to update rules gradually, KIC 2.7 includes the
`enableLegacyRegexDetection` option to continue applying the 2.x regular
expression heuristic on KIC's end.

If the following sets of rules are met, KIC creates a Kong route path with
the `~` prefix:

* The `enableLegacyRegexDetection` option is enabled
* The Kong version is 3.0 or higher
* A path matches the 2.x heuristic

or:

* The path begins with `/~`

This allows for a mixture of paths that have and have not been migrated to
3.x-style configuration. The heuristic is never applied to paths that already
begin with `/~`.

{:.note}
> **Note:** If you have paths that require a Kong route that actually begins
with `/~`, set the `konghq.com/regex-prefix` annotation on their Ingress. This
overrides the default prefix. For example, setting `konghq.com/regex-prefix:
/@` will replace leading `/@` sequences with `~` in their Kong route, while
leading `/~` sequences will be preserved as-is in the Kong route.

To enable legacy regex detection, create an IngressClassParameters resource
with `enableLegacyRegexDetection=true` and attach it to your IngressClass. The
option _is not_ enabled for IngressClasses by default.

```bash
echo '
apiVersion: configuration.konghq.com/v1alpha1
kind: IngressClassParameters
metadata:
  name: 2x-heuristic
spec:
  enableLegacyRegexDetection: true
' | kubectl apply -n kong -f -
```

```bash
kubectl patch ingressclass kong --patch '
{"spec":
		{"parameters":
				{
				"apiGroup": "configuration.konghq.com",
				"kind": "IngressClassParameters",
				"name": "2x-heuristic",
				"namespace": "kong",
				"scope": "Namespace"
				}
		}
}'
```

If you use a non-standard namespace or Ingress class, you will need to
replace the `kong` Ingress class name and `kong` namespace with values
appropriate to your environment.

After you have upgraded to Kong 3.x, update all of your regular expression paths
to include the `/~` prefix in the Ingress itself at your earliest convenience.
The heuristic is only intended for decreasing downtime during upgrades, so
it behaves exactly like the version included in Kong 2.8.x, bugs
included. Once you added the prefix to all regular expression paths, you can
disable `enableLegacyRegexDetection`.

{:.important}
> **Important**: The `enableLegacyRegexDetection` option is meant to be **temporary**.
Only use it for migration.

The Gateway API HTTPRoute resources are not affected by this problem. They
do have a dedicated regular expression path type, and KIC inserts the `~`
prefix automatically for these.

## Testing environment

To avoid issues with the upgrade, run it in a test environment before
deploying it to production. Create a [Kubernetes][k8s] cluster
using the same tools that deployed your production cluster, or use
a local development cluster such as [minikube][minikube] or [kind][kind].

Using Helm, check the deployed chart version:

{% navtabs codeblock %}
{% navtab Command %}

```shell
helm list -A
```

{% endnavtab %}
{% navtab Response %}

```shell
NAME               NAMESPACE   STATUS   CHART       APP VERSION
ingress-controller kong-system deployed kong-2.13.0 2.7
```

{% endnavtab %}
{% endnavtabs %}

In the above example, `kong-2.13.0` is the currently deployed chart version.

Using the existing chart version and the `values.yaml` configuration for
your production environment, deploy a copy to your test cluster
with the `--version` flag:

```shell
helm install kong-upgrade-testing kong/kong \
  --version ${YOUR_VERSION} \
  -f ${PATH_TO_YOUR_VALUES_FILE}
```

{:.note}
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
helm repo add kong https://charts.konghq.com
```

Update the repository to pull the latest repository updates:

{% navtabs codeblock %}
{% navtab Command %}

```shell
helm repo update
```

{% endnavtab %}
{% navtab Response %}

```
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kong" chart repository
Update Complete. ⎈Happy Helming!⎈
```

{% endnavtab %}
{% endnavtabs %}

### Perform the upgrade

Run the following command, specifying the old release name, the namespace where
you've configured {{site.base_gateway}}, and the existing `values.yaml` configuration file:

```shell
helm upgrade ${YOUR_RELEASE_NAME} kong/kong \
  --namespace ${YOUR_NAMESPACE} \
  -f ${PATH_TO_YOUR_VALUES_FILE} \
  --set image.tag="3.0"
```

After the upgrade completes, there is a brief period of time before the new
resources are online. You can wait for the relevant Pod resources to complete
by watching them in your release namespace:

```shell
kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

Once the new pods are in a `Ready` state, the upgrade is complete. Update your
`values.yaml` file to use the new Kong and {{site.kic_product_name}} image
versions to continue using these through future upgrades.

### Rollback

If you run into problems during or after the upgrade, Helm provides a
rollback mechanism to revert to a previous revision of the release:

```shell
helm rollback --namespace ${YOUR_RELEASE_NAMESPACE} ${YOUR_RELEASE_NAME}
```

You can wait for the rollback to complete by watching the relevant Pod
resources:

```shell
kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

After a rollback, if you ran into issues in production,
consider using a [testing environment](#testing-environment) to
identify and correct these issues, or reference the
[troubleshooting documentation][troubleshooting].

[troubleshooting]:/kubernetes-ingress-controller/{{page.release}}/troubleshooting/
