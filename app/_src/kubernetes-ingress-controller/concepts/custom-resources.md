---
title: Custom Resources
type: explanation
purpose: |
  Custom Resources bundled with KIC to configure settings that are specific to Kong
---

[Custom Resources][k8s-crd] in Kubernetes allow controllers to extend Kubernetes-style
declarative APIs that are specific to certain applications.

A few custom resources are bundled with the {{site.kic_product_name}} to
configure settings that are specific to Kong and provide fine-grained control
over the proxying behavior.

The {{site.kic_product_name}} uses the `configuration.konghq.com` API group
for storing configuration specific to Kong.

These CRDs allow users to declaratively configure all aspects of Kong:

- [**KongIngress**](#kongingress)
- [**KongPlugin**](#kongplugin)
- [**KongClusterPlugin**](#kongclusterplugin)
- [**KongConsumer**](#kongconsumer)
{% if_version gte:2.11.x -%}
- [**KongConsumerGroup**](#kongconsumergroup)
{% endif_version -%}
- [**TCPIngress**](#tcpingress)
- [**UDPIngress**](#udpingress)

## KongIngress

{:.note}
> **Note:** Many fields available on KongIngress are also available as
> [annotations](/kubernetes-ingress-controller/{{page.release}}/reference/annotations/).
> You can add these annotations directly to Service and Ingress resources
> without creating a separate KongIngress resource. When an annotation is
> available, it is the preferred means of configuring that setting, and the
> annotation value takes precedence over a KongIngress value if both set
> the same value.

The standard Ingress and Service Kubernetes resources can't express the full
range of Kong's routing capabilities. You can use KongIngress to extend these resources. 

KongIngress is a custom resource that
attaches to Ingresses and Services and allows them
to control all settings on the Kong [routes][kong-route],
[services][kong-service], and [upstreams][kong-upstream] generated for them.
KongIngress is not an alternative to Ingress. It can't be used independently
and only functions when attached to another resource.

Once a KongIngress resource is created, you can use the `konghq.com/override`
annotation to associate the KongIngress resource with an Ingress or a Service
resource.

- **Annotated Ingress resource:** All routes associated with the annotated
  Ingress are updated to use the values defined in the KongIngress's `route` section.
- **Annotated Service resource:** The
  corresponding service and upstream in Kong are updated to use the `proxy` and `upstream`
  blocks as defined in the associated KongIngress resource.

Don't attach a KongIngress that sets values in the `proxy` and
`upstream` sections to an Ingress, as it won't have any effect. These
sections are only honored when a KongIngress is attached to a Service.
Similarly, the `route` section has no effect when attached to a Service, only
when attached to an Ingress.

This diagram shows how the resources are linked with one another.

![Associating Kong Ingress](/assets/images/products/kubernetes-ingress-controller/kong-ingress-association.png "Associating Kong Ingress")

## KongPlugin

Kong is designed around an extensible [plugin][kong-plugin]
architecture and comes with a
wide variety of plugins already bundled inside it.
These plugins can be used to modify the request or impose restrictions
on the traffic.

Once this resource is created, the resource needs to be associated with an
Ingress, Service, or KongConsumer resource in Kubernetes.

This diagram shows how you can link a KongPlugin resource to an
Ingress, Service, or KongConsumer.

|  |  |
:-:|:-:
![](/assets/images/products/kubernetes-ingress-controller/kong-plugin-association1.png)|![](/assets/images/products/kubernetes-ingress-controller/kong-plugin-association2.png)

## KongClusterPlugin

_This resource requires the [`kubernetes.io/ingress.class` annotation](/kubernetes-ingress-controller/{{page.release}}/reference/annotations/)._

KongClusterPlugin resource is exactly same as KongPlugin, except that it is a
Kubernetes cluster-level resources rather than a namespaced resource.
This can help when the configuration of the plugin needs to be centralized
and the permissions to add or update plugin configuration rests with a different
persona other than the application owners.

This resource can be associated with an Ingress, Service, or KongConsumer, 
and can be used in the exact same way as KongPlugin.

A namespaced KongPlugin resource takes priority over a
KongClusterPlugin with the same name.

## KongConsumer

_This resource requires the `kubernetes.io/ingress.class` annotation. Its value
must match the value of the controller's `--ingress-class` argument, which is
`kong` by default._

This custom resource configures consumers in Kong.
Every KongConsumer resource in Kubernetes directly translates to a
[Consumer][kong-consumer] object in Kong.

## TCPIngress

_This resource requires the `kubernetes.io/ingress.class` annotation. Its value
must match the value of the controller's `--ingress-class` argument, which is
`kong` by default._

This Custom Resource is used for exposing non-HTTP
and non-GRPC services running inside Kubernetes to
the outside world through Kong. This proves to be useful when
you want to use a single cloud LoadBalancer for all kinds
of traffic into your Kubernetes cluster.

It is very similar to the Ingress resource that ships with Kubernetes.

## UDPIngress

_This resource requires the `kubernetes.io/ingress.class` annotation. Its value
must match the value of the controller's `--ingress-class` argument, which is
`kong` by default._

This Custom Resource is used for exposing [UDP][udp] services
running inside Kubernetes to the outside world through Kong.

This is useful for services such as DNS servers, Game Servers,
VPN software and a variety of other applications.

{% if_version gte:2.11.x %}

## KongConsumerGroup
{:.badge .enterprise}

{:.note}
> This feature requires {{site.ee_product_name}} 3.4 or higher.
> It is not compatible with the older consumer groups implementation introduced
> in {{site.ee_product_name}} 2.7.

_This resource requires the `kubernetes.io/ingress.class` annotation. Its value
must match the value of the controller's `--ingress-class` argument, which is
`kong` by default._

KongConsumerGroup creates a [consumer group][kong-consumer-group], which
associates KongPlugin resources with a collection of KongConsumers.

KongConsumers have a `consumerGroups` array. Adding a KongConsumerGroup's name
to that array adds that consumer to that consumer group.

Applying a `konghq.com/plugins: <KongPlugin name>` annotation to a KongConsumerGroup 
then executes that plugin on every consumer in the consumer group.

{% endif_version %}

[udp]:https://datatracker.ietf.org/doc/html/rfc768
[k8s-crd]: https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-custom-resource-definitions/
[kong-consumer]: /gateway/api/admin-ee/latest/#/Consumers/list-consumer/
[kong-plugin]: /gateway/api/admin-ee/latest/#/Plugins/list-plugin
[kong-route]: /gateway/api/admin-ee/latest/#/Routes/list-route/
[kong-service]: /gateway/api/admin-ee/latest/#/Services/list-service/
[kong-upstream]: /gateway/api/admin-ee/latest/#/Upstreams/list-upstream/
[kong-consumer-group]: /gateway/latest/kong-enterprise/consumer-groups/
