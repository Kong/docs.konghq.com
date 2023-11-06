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

![translating Kubernetes to Kong](/assets/images/products/kubernetes-ingress-controller/k8s-to-kong.png "Translating k8s resources to Kong")

Routes are configured using Gateway API or Ingress resources, such as `HTTPRoute`, `TCPRoute`, `GRPCRoute`, `Ingress` and more.

In this tutorial, you will deploy an `echo` service which returns information about the Kubernetes cluster and route traffic to the service.

{% include /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include /md/kic/http-test-routing.md kong_version=page.release path='/echo' name='echo' service='echo' port='80' skip_host=true %}