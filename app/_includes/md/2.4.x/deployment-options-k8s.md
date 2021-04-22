<!-- Deployment Options section; used in all Enterprise k8s installation topics-->
The following instructions assume that you are deploying {{site.base_gateway}} in [classic embedded mode](/enterprise/{{page.kong_version}}/deployment/deployment-options).

If you would like to run {{site.base_gateway}} in Hybrid mode, the instructions in this topic will walk you though setting up a Control Plane instance. Afterward, you will need to bring up additional gateway instances for the Data Planes, and perform further configuration steps. See [Hybrid Mode setup documentation](https://github.com/Kong/charts/blob/main/charts/kong#hybrid-mode) for details.
