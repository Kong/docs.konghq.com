<!-- Used in Konnect Architecture and Konnect Getting Started Overview-->
The {{site.konnect_product_name}} platform provides several hosted control plane options 
to manage all service configurations. You can use one or more of the following control plane options:
* {{site.base_gateway}}
* {{site.kic_product_name}} 
* {{site.mesh_product_name}}

The control plane propagates those configurations to
the data plane group, which is composed of data plane 
nodes (and in the case of {{site.mesh_product_name}} proxies). The individual nodes can be running either on-premise, in 
cloud-hosted environments, or fully managed by {{site.konnect_product_name}} with [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/). Each data plane node retains the configuration in-memory, ensuring efficient and reliable service management across deployment models.