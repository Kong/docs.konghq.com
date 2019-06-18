---
title: Kong Service Mesh and Kubernetes
---

## Introduction

Kong `0.15.0` / `1.0.0` added the capability to proxy and route raw `tcp` and `tls`
streams and deploy Kong using a service-mesh sidecar pattern with mutual
`tls` between Kong nodes. This tutorial walks you through setting up a Kong service
mesh on Kubernetes with our [Kubernetes sidecar injector plugin](https://github.com/Kong/kubernetes-sidecar-injector)
