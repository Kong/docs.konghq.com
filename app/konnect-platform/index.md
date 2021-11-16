---
title: Kong Konnect
subtitle: The full-stack connectivity platform for cloud-native applications
no_version: true
---

## End-to-end Service Connectivity Platform  
We live in a connected world. Every application we use, whether within or outside
of work, is built on top of dozens, sometimes hundreds of **services** that
enable our digital, connected experiences. For example, think of an application
that allows you to control your garden sprinklers. While it may seem
simple on the surface, underlying that application are likely a dozen or so
services as illustrated below.

![{{site.konnect_product_name}} Overview](/assets/images/docs/konnect/konnect-overview.png)

In the diagram above, each of the red circles represents a
**connectivity end-point**. At each of these points, **connectivity logic** is
required. Connectivity logic addresses concerns such as ensuring that incoming
requests are authenticated, authorized, rate-limited, and logged, or that, as
a new version of a service is introduced, requests from incompatible older
versions of the service’s consumers are routed to the older version.

Most organizations build and manage their connectivity logic from scratch many
times over across each team, application, and service. This Do-It-Yourself
approach is unfortunately not only inefficient, but it also leads to
significantly lowered reliability, speed, and insight across the connected
experiences that form the touchpoints (web apps, mobile apps, APIs) of the
modern organization’s interactions with its customers, partners, and employees.

As a Service Connectivity Platform (SCP), {{site.konnect_short_name}} enables
*reliability*, *speed*, and *insight* by providing common, out-of-the-box
connectivity logic, executed through **connectivity runtimes** and managed
through **functionality modules** across points of connectivity within your
applications.

### Reliability
If connectivity logic fails &mdash; for example, a piece of logic that
authenticates incoming requests &mdash; there could be serious security and
availability consequences. {{site.konnect_short_name}} provides rock-solid,
pre-validated, and tested connectivity logic that can be applied to connectivity
endpoints and executed through highly reliable connectivity runtimes,
minimizing the risks of service failures and security vulnerabilities.

The components of {{site.konnect_short_name}} that enable this reliability
are defined in the following table:

| {{site.konnect_short_name}} Component {:width=20%:} | Description |
|---------------------------------------|-------------|
| [{{site.base_gateway}}](/gateway/)  | High-performance connectivity runtime for executing edge connectivity logic. |
| [Kong Ingress Controller](/kubernetes-ingress-controller/) | High-performance connectivity runtime for executing inter-app connectivity logic within a Kubernetes environment. |
| [{{site.mesh_product_name}}](/mesh/)  | High-performance connectivity runtime for executing in-app connectivity logic. {{site.mesh_product_name}} is built on the Kuma service mesh open-source project. |
| [Kong Plugins](/hub)                        | Secure, tested, and reliable connectivity logic for all connectivity needs applied through the {{site.base_gateway}} and Kong Ingress Controller runtimes. Many plugins are built and supported by {{site.company_name}}, and a wide array of plugins are also built and maintained by the Kong community. |
| [Immunity](/gateway/latest/immunity/) | Functionality module that uses machine learning to analyze traffic patterns in real time to improve security, mitigate breaches, and isolate issues. |
| [Runtime Manager](/konnect/runtime-manager)<br>(Cloud only) | Functionality module that enables provisioning instances of {{site.konnect_short_name}}’s supported runtimes. Runtime Manager provides a unified view of all of these runtimes and their current status. <br><br>**Note:** Currently, the only supported runtime type in the Runtime Manager is a {{site.base_gateway}} data plane. |

### Speed
{{site.konnect_short_name}} provides increased velocity of service development
and faster connectivity runtime performance.

#### Service Development Velocity
The connectivity logic that comes out of the box with
{{site.konnect_short_name}} allows developers to focus on business logic and
not need to rewrite a piece of connectivity logic every time. In turn, this
leads to faster development. {{site.konnect_short_name}} enables developers to
rapidly search for and discover existing services, which they can reuse to
accelerate the development of their applications.

The components of {{site.konnect_short_name}} that enable service development
velocity are defined in the following table:

| {{site.konnect_short_name}} Component {:width=20%:} | Description |
|------------------------------|-------------|
| [Insomnia](https://support.insomnia.rest/) | API debugging, design, and testing tool for developers. Allows developers to rapidly explore and consume existing services of different protocols (spawning REST, GraphQL, and gRPC), design services using a spec-based approach, and write and build a suite of tests while collaborating with other developers. <br><br> Using Insomnia, you can generate {{site.base_gateway}} and Kong Ingress Controller runtime configurations directly from their API specs. Developers can rapidly map their API designs to connectivity logic that exposes those designs within a connectivity runtime.  |
| Dev Portal <br><br>[Cloud docs](/konnect/dev-portal) <br>[Self-hosted docs](/gateway/latest/developer-portal) | Functionality module that enables the formal publishing of API docs to an API catalogue through which developers (typically external to an application team) can discover and formally register to use the API. |
| [ServiceHub](/konnect/servicehub)<br>(Cloud only) | Functionality module that enables the cataloging of all services into a single system of record. This catalog represents the single source of truth for your organization’s service inventory and their dependencies. By leveraging ServiceHub, application developers can search, discover, and consume existing services to accelerate their time-to-market, while enabling a more consistent end-user experience across the organization’s applications. |

#### Connectivity Runtime Performance
Any unnecessary latency incurred in the execution of connectivity logic is
compounded across each of the dozens to hundreds of connectivity endpoints
underlying modern applications. All of {{site.konnect_short_name}}’s
out-of-the-box high performance connectivity logic and connectivity runtimes are
optimized to minimize this latency.

### Insight
Connectivity endpoints provide sources of insight across three different dimensions:

* At the service level: for example, how many versions of Service A are there
and what does each version's interface look like?
* At the application level: for example, what is the overall uptime of the
Device App?
* At the business level: for example, which device types use our applications
the most?

{{site.konnect_short_name}} captures this insight and provides tools that make
it easily accessible to any stakeholders. The components of
{{site.konnect_short_name}} that enable service development velocity are
defined in the following table:

| {{site.konnect_short_name}} Component {:width=20%:} | Description |
|---------------------------------------|-------------|
| Vitals <br><br>[Cloud docs](/konnect/vitals) <br>[Self-hosted docs](/gateway/latest/vitals/) | Functionality module that enables the capture and generation of service usage and health monitoring data. This module's capabilities can be enhanced with {{site.konnect_short_name}} plugins that enable monitoring metrics to be streamed to third-party analytics providers such as Datadog and Prometheus. |
| [ServiceHub](/konnect/servicehub) <br>(Cloud only) | Functionality module that enables the cataloging all of all services into a single system of record that represents the single source of truth of your organization’s service inventory and their dependencies. By leveraging ServiceHub, enterprise architects can attain a better understanding of the organization’s inventory of services, in terms of the level of reuse, usage, and operational health of services across different teams and environments. |

#### Cloud-native Service Lifecycle
As the number of connectivity endpoints and runtimes increases, the automation
of their lifecycles becomes more critical, as automation allows for a high
velocity of change in a reliable manner. {{site.konnect_short_name}} is designed
from the ground up to enable this level of automation across both legacy
environments and more modern, containerized infrastructure. It provides all
capabilities through CLIs, declarative configuration interfaces, and
well-defined APIs.

The components of {{site.konnect_short_name}} that enable this cloud-native
lifecycle are as follows:

| {{site.konnect_short_name}} Component {:width=20%:}| Description |
|------------------------------|-------------|
| [decK](/deck)                         | decK is a tool that allows for the management of {{site.base_gateway}}’s configuration in a declarative fashion. It can sync configuration to a running cluster, diff configuration to detect any drift or manual changes, and back up {{site.base_gateway}}'s configuration. It also can manage the configuration in a distributed way using tags, helping you split configuration across various teams. |
| [Kong Ingress Controller CRDs](/kubernetes-ingress-controller/latest/concepts/custom-resources) | The Kong Ingress Controller runtime’s lifecycle can be managed entirely through Kubernetes CRD manifests, which can be applied through the Kubernetes `kubectl` command line. |
| [{{site.base_gateway}}’s Admin API](/gateway/latest/admin-api) | The {{site.base_gateway}} runtime provides an internal REST-based Admin API. Requests to the Admin API can be sent from any node in the cluster, and {{site.konnect_short_name}} will keep the configuration consistent across all nodes. |
| [Inso command line](https://support.insomnia.rest/collection/105-inso-cli) | Inso is a CLI for Insomnia that exposes Insomnia’s application functionality to be invoked via a terminal or within a CI/CD pipeline for automation of API debugging, testing, and configuration generation. |
| [{{site.konnect_saas}} Admin API](/konnect/reference/konnect-api) | {{site.konnect_short_name}} provides a REST-based Cloud API that exposes all of the functionality of its Cloud web interfaces. |
