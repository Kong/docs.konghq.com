<!-- Deployment Options section; used in all Enterprise installation topics - except k8s -->
The installation instructions assume that you are deploying {{site.base_gateway}} in [classic embedded mode](/gateway/{{include.kong_version}}/plan-and-deploy/deployment-options).

If you want to run {{site.base_gateway}} in Hybrid mode, the instructions in this topic will walk you though setting up a Control Plane instance. Afterward, you will need to bring up additional gateway instances for the Data Planes, and perform further configuration steps. See [Hybrid Mode Setup](/gateway/{{include.kong_version}}/plan-and-deploy/hybrid-mode-setup) for details.
