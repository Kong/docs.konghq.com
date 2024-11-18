---
title: Services and Routes
book: kic-get-started
chapter: 2
type: tutorial
purpose: |
  Use the Gateway API and HTTPRoute to configure a service and a route. Explain how the HTTPRoute translates to Kong Gateway entities.
---

A Service inside Kubernetes is a way to abstract an application that is running on a set of Pods. This maps to two objects in Kong: Service and Upstream.

The service object in Kong holds the information of the protocol to use to talk to the upstream service and various other protocol specific settings. The Upstream object defines load-balancing and health-checking behavior.

<!--vale off-->
{% mermaid %}
flowchart LR
    H(Request traffic)
    subgraph Pods
        direction LR
        E(Target)
        F(Target)
        G(Target)
    end

    subgraph Kubernetes Service
        direction TB
        C(Service)
        D(Upstream)
    end
    
    subgraph Ingress rules
        direction LR
        A(Route)
        B(Route)
    end

    A --> C
    B --> C
    C --> D
    D --> E
    D --> F
    D --> G
    H --> A

    classDef lightBlue fill:#cce7ff;
    classDef lightGreen fill:#c4e1c4;
    classDef lightPurple fill:#e6d8eb;
    classDef lightGrey fill:#f5f5f5;

    class A,B lightGreen;
    class C lightBlue;
    class D lightPurple;
    class E,F,G lightGrey;

    linkStyle 6 stroke:#b6d7a8
{% endmermaid %}
<!--vale on-->

Routes are configured using Gateway API or Ingress resources, such as `HTTPRoute`, `TCPRoute`, `GRPCRoute`, `Ingress` and more.

In this tutorial, you will deploy an `echo` service which returns information about the Kubernetes cluster and route traffic to the service.

{% include /md/kic/test-service-echo.md release=page.release %}

{% include /md/kic/http-test-routing.md release=page.release path='/echo' name='echo' service='echo' port='80' skip_host=true %}
