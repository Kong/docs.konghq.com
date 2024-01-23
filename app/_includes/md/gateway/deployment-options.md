<!-- Deployment Options section; used in all Enterprise installation topics - except k8s -->
The installation instructions explain how to deploy {{site.base_gateway}} in its entirety on a single node -- with or without a database.

{% if_version lte:2.8.x %}
The instructions are the same for setting up a Control Plane instance in Hybrid mode. After you set up the Control Plane, you set up additional Gateway instances for the Data Planes. See [Hybrid Mode Setup](/gateway/{{include.release}}/plan-and-deploy/hybrid-mode/hybrid-mode-setup/) for details.
{% endif_version %}
{% if_version gte:3.0.x %}
The instructions are the same for setting up a Control Plane instance in Hybrid mode. After you set up the Control Plane, you set up additional Gateway instances for the Data Planes. See [Hybrid Mode Setup](/gateway/{{include.release}}/production/deployment-topologies/hybrid-mode/setup/) for details.
{% endif_version %}
