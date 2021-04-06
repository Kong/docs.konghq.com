---
name: corsha-kong-plugin
publisher: Corsha

categories:
  - authentication

type: plugin

desc: Corsha API Authentication Plugin for Kong Konnect
description: Corsha has developed a plugin to drop into Kong Konnect and integrate seamlessly with Corsha's API Security Platform

support_url: https://corsha.com/contact-us/

kong_version_compatibility:
  community_edition:
    compatible:
      - 0.14.x
    incompatible:
  enterprise_edition:
    compatible:
      - 0.34-x
    incompatible:

params:
  name: corsha-kong-plugin
  api_id: true
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: authServerProxyURL
      required: true
      default:
      description: URL to Corsha Auth Server's Proxy endpoint
    - name: authServerClientKey
      required: true
      default:
      description: MTLS client key for communicating with the Corsha Auth Server
    - name: authServerClientCert
      required: true
      default:
      description: MTLS client cert for communicating with the Corsha Auth Server
---
Corsha has developed a plugin to drop into Kong Konnect and integrate seamlessly with Corsha's API Security Platform. Corsha's platform provides a novel way to provide zero-trust for machine-to-machine API communication - a dynamic, fully automated multi-factor authentication (MFA) for APIs.  The platform can be deployed to secure APIs in diverse architectures at the scale and speed of automated cloud and edge computing. The platform brings to APIs the same MFA security guarantees that have proven successful with human users – dynamic and continuous verification, a key element of zero-trust strategies.

Corsha’s platform tightly couples a lightweight authenticator with each API client. Once deployed, the authenticator starts developing a dynamic authentication stream out-of-band in Corsha’s Distributed Ledger Network (DLN). Corsha has built this DLN on top of a fully orchestrated Kubernetes platform allowing for seamless horizontal and vertical scaling.  This private, permissioned DLN collects this unique authentication stream for each endpoint over time.  When the API client is ready to make a call, it now has a fresh, one-time-use Corsha Credential to provide  alongside any other primary authentication factors.  This Corsha plugin for Kong allows Corsha to smoothly integrate into any Kong-powered architecture.  Konnect Administrators are able to configure specific or all API services managed by Konnect to expect Corsha MFA credentials from trusted API clients.

The combined solution pins API access to only trusted machines, giving an organization fine-grained control over its API exposure.  

Key Benefits:

* Automated, continuous protection against API exploits, i.e. man-in-the-middle attacks (MitM), API credential stuffing, and machine spoofing
* Simple integration and management that relieves burden on DevSecOps teams
* A dynamic machine identity for each  API client
* Via Corsha's central administrative console, a single pane of glass view of all machines in a hybrid deployment across clouds and legacy datacenters
* Control of all API access into enterprise applications on a machine-by-machine basis
