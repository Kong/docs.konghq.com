---
title: Advantages & Use Cases
header_icon: /assets/images/icons/icn-documentation.svg
header_title: Advantages & Use Cases
---

## Advantages

Kong has several advantages compared to other API management platforms and tools. Community favorites include:

- **Open-Source**: No black box. For enterprise or free usage, Kong is entirely open-source, always.
- **Based on Nginx**: Kong is embedded in Nginx and benefits from its amazing proxying performances.
- **Customizable**: Write plugins to cover all your architecture use-cases.
- **Data Ownership**: Kong and its underlying datastore run on **your** servers.
- **Easy to scale**: All Kong nodes are stateless. Spawning new nodes in your cluster is very easy.
- **Integrations**: Many plugins integrate with popular third-party services in the microservices world.

## Use Cases

Because Kong is open-source and highly customizable, you'll have full control over your architecutre. It's perfectly suited for managing *internal* Microservice traffic as well as *partners* or *public* entities.

### Internal

Internal API traffic that connects microservices built inside your organization can originate from teams in different geographic regions, but belong to the same entity. Internal microservices and APIs can be deployed either on bare metal or a cloud provider.

![Internal use-case](/assets/images/internal-use.png)

### Partners

Parters usage is when your software has to communicate with a mission critical third party microservice to offer its key features (and vice-versa). For example a credit card company relies on at least one bank to offer its service. In the past most of those connections would happen via an ESB, nowadays all you need is an API Gateway.

![Partner use-case](/assets/images/partner-use.png)

### Public

Public is when you offer your API with a self-serve onboarding process. Any developer can get a key and access/consume your services. An example of this model is Facebook's Graph API. Common features are authentication, rate limiting, and billing tiers if it's a paid API.

![Public use-case](/assets/images/public-use.png)
