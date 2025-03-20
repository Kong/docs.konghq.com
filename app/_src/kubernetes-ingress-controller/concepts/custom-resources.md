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

<!--vale off-->
{% mermaid %}
flowchart TD
    A(apiVersion: configuration.konghq.com/v1<br>kind: KongIngress<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: demo-kong-ingress<br>route: <br>&nbsp;&nbsp;&nbsp;# various route properties can be overridden):::left -->|konghq.com/override annotation-based association| B(apiVersion: extensions/v1beta1<br>kind: Ingress<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: demo-api<br>&nbsp;&nbsp;&nbsp;annotations:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;konghq.com/override: demo-kong-ingress):::left
    B --> C(apiVersion: v1<br>kind: Service<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: echo-svc<br>&nbsp;&nbsp;&nbsp;annotations:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;konghq.com/override: https-upstream):::left
    D(apiVersion: configuration.konghq.com/v1<br>kind: KongIngress<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: https-upstream<br>proxy:<br>&nbsp;&nbsp;&nbsp;protocol: https<br>upstream:<br>&nbsp;&nbsp;&nbsp;# load-balancing and health-check behaviors can be tuned):::left --> C

    classDef left text-align:left;
    classDef lightBlue fill:#cce7ff;
    classDef lightGreen fill:#c4e1c4;

    class B lightGreen;
    class C lightBlue;
{% endmermaid %}
<!--vale on-->

## KongPlugin

Kong is designed around an extensible [plugin][kong-plugin]
architecture and comes with a
wide variety of plugins already bundled inside it.
These plugins can be used to modify the request or impose restrictions
on the traffic.

Once this resource is created, the resource needs to be associated with an
Ingress, Service, HTTPRoute, KongConsumer or KongConsumerGroup resource in Kubernetes.

This diagram shows how you can link a KongPlugin resource to an
Ingress, Service, or KongConsumer.

<!--vale off-->
{% mermaid %}
flowchart TD
    subgraph Link to consumer
        direction TB
        E(apiVersion: configuration.konghq.com/v1<br>kind: KongPlugin<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: custom-api-limit<br>plugin: rate-limiting<br>config:<br>&nbsp;&nbsp;&nbsp;minute: 10):::left
        F(apiVersion: configuration.konghq.com<br>kind: KongConsumer<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: demo-api<br>&nbsp;&nbsp;&nbsp;annotations:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;konghq.com/plugins: custom-api-limit<br>username: special-client):::left
    end
    
    subgraph Link to Ingress and service
        direction TB
        A(apiVersion: configuration.konghq.com/v1<br>kind: KongPlugin<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: reports-api-limit<br>plugin: rate-limiting<br>config: <br>&nbsp;&nbsp;&nbsp;minute: 5):::left 
        B(apiVersion: extensions/v1beta1<br>kind: Ingress<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: demo-api<br>&nbsp;&nbsp;&nbsp;annotations:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;konghq.com/plugins: reports-api-limit):::left
        C(apiVersion: v1<br>kind: Service<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: billing-api<br>&nbsp;&nbsp;&nbsp;annotations:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;konghq.com/plugins: billing-auth):::left
        D(apiVersion: configuration.konghq.com/v1<br>kind: KongPlugin<br>metadata:<br>&nbsp;&nbsp;&nbsp;name: billing-auth<br>plugin: basic auth):::left
    end

    A --> |execute the plugin for any request that matches a rule in the following ingress resource|B
    B --> C
    D --> |execute the plugin for any request that is forwarded to the billing-api service in k8s|C
    E --> |Associated using konghq.com/plugins annotation|F

    classDef left text-align:left;
    classDef lightBlue fill:#cce7ff;
    classDef lightGreen fill:#c4e1c4;
    classDef lightPurple fill:#e6d8eb;

    class B lightGreen;
    class C lightBlue;
    class F lightPurple;
{% endmermaid %}
<!--vale on-->

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
[kong-consumer]: /gateway/api/admin-ee/latest/#/operations/list-consumer
[kong-plugin]: /gateway/api/admin-ee/latest/#/operations/list-plugin
[kong-route]: /gateway/api/admin-ee/latest/#/operations/list-route
[kong-service]: /gateway/api/admin-ee/latest/#/operations/list-service
[kong-upstream]: /gateway/api/admin-ee/latest/#/operations/list-upstream
[kong-consumer-group]: /gateway/latest/kong-enterprise/consumer-groups/
