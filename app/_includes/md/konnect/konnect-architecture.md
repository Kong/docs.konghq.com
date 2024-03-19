<!-- Used in Konnect Architecture and Konnect Getting Started Overview-->
The {{site.konnect_product_name}} platform provides several hosted control plane options 
to manage all service configurations. You can use one or more of the following control plane options:
* {{site.base_gateway}}
* {{site.kic_product_name}} 
* {{site.mesh_product_name}}

The control plane propagates those configurations to
the data plane, which is composed of self-managed or fully-managed data plane 
nodes (and proxies in the case of {{site.mesh_product_name}}). The individual nodes can be running either on-premise or in 
cloud-hosted environments, and each data plane node stores the configuration 
in-memory. 