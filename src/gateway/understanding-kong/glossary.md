---
title: Glossary

---

| Term      | Definition |
| ----------- | ----------- |
|Admin | An Admin is a {{site.base_gateway}} user account capable of accessing the Admin API or Kong Manager. |
|Authentication| Authentication is the process by which a system validates the identity of a user account. |
|Authorization| Authorization is the system of defining access to certain resources. In {{site.base_gateway}}, Role-Based Access Control (RBAC) is the main authorization mode. |
|Beta| [availability stages](/gateway/latest/availability-stages) |
|Catalog| A list of all specs within a portal. This catalog can react to developer permissions, allowing a given developer to see whatever specs their role permits.|
|Client| A Kong Client refers to the downstream client making requests to Kong’s proxy port. It could be another service in a distributed application, a user’s identity, a user’s browser, or a specific device. |
|Consumer| A Consumer object represents the client of a service. A Consumer is also the Admin API entity representing a developer or machine using the API. |
|Credential| A unique string associated with a consumer; also referred to as an API key.      |
|Dev Portal| A web application that functions as a collection of service version specs and documentation objects. The purpose of a portal is to allow registration and consumption of services running through Kong to other teams, developers, and partners.|
|Groups| Sets of role-defined entities.|
|Host | A Host represents the domain hosts (using DNS) intended to receive upstream traffic. In {{site.base_gateway}}, it is a list of domain names that match a route object. |
| Kong plugin|  A plugin developed, maintained, and supported by Kong.|
|Methods| Methods represent the HTTP methods available for requests. It accepts multiple values, for example, `GET`, `POST`, and `DELETE`. Its default value is empty (the HTTP method is not used for routing). |
|Permission| A Permission is a policy representing the ability to create, read, update, or destroy an Admin API entity defined by endpoints.|
|Plugin| Plugins provide advanced functionality and extend the use of {{site.base_gateway}}, allowing you to add new features to your gateway. Plugins can be configured to run in a variety of contexts, ranging from a specific route to all upstreams. Plugins can perform operations in your environment, such as authentication, rate-limiting, or transformations on a proxied request.|
|Proxy| Kong is a reverse proxy that manages traffic between clients and hosts. As a gateway, Kong’s proxy functionality evaluates any incoming HTTP request against configured routes. |
|Rate Limiting| Rate Limiting allows you to restrict how many requests your upstream services receive from your API consumers, or how often each user can call the API. Rate limiting protects the APIs from inadvertent or malicious overuse.|
|Role |A Role is a set of permissions that may be reused and assigned to admins.|
|Route| A route, also referred to as a route object, defines rules to match client requests to upstream services. Each route is associated with a service, and a service may have multiple routes associated with it. routes are entry points to upstream services.|
|Service| A service, also referred to as a service object, is the upstream APIs and microservices that Kong manages. For example, Services could be a data transformation microservice or a billing API. The main attribute of a Service is its URL, the destination where Kong proxies traffic. The URL can be set as a single string, or by specifying its protocol, host, port, and path.  |
|Stable| A Stable release designation in Kong software means the functionality of the version is of high quality, production-ready, and released as general availability (GA). The version has been thoroughly tested, considered reliable to deploy in a production environment, and is fully supported. If updates or bug fixes are required, a patch version or minor release version is issued and fully supported.|
|Super Admin| A super admin, or any role with read and write access to the /admins and /rbac endpoints, creates new Roles and customize permissions. A super admin can invite and disable other admin accounts, assign and revoke roles to admins, create new roles with custom permissions, and create new workspaces.|
|Service configuration| The concrete configuration that a runtime group can be configured with in order to expose the service version’s functionality. At the onset, the only type of implementation that we will support will be a Kong proxy.|
|Spec| A service version can have an optional spec (e.g. OAPI spec for a RESTful service) associated with it.    |
|Tags| Tags are customer-defined labels that let you manage, search for, and filter core entities using the ?tags querystring parameter. Tags can be added when creating or editing most core entities. Each tag must be composed of one or more alphanumeric characters,` \_\`, `-`, . or `~`. |
|Teams| Teams organize developers into working groups.|
|Tech preview |[availability stages](/gateway/latest/availability-stages) |
|Third-party or community plugin| A custom plugin developed, maintained, and supported by an external developer, not by Kong. Kong does not test these plugins, or update their version compatibility.|
|Runtime| A Kuma Mesh or a {{site.base_gateway}}, an infrastructure runtime. Previously known as a Kong data plane node     |
|Service Version| A specific version of a service.|
|Upstream| An upstream object refers to the API or service managed by Kong, to which client requests are forwarded. An upstream object represents a virtual hostname and can be used to load balance incoming requests over multiple services.|
|Workspaces| Workspaces enable an organization to segment objects and admins into namespaces. The segmentation allows teams of admins sharing the same Kong cluster to adopt roles for interacting with specific objects.|