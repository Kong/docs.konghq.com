<!-- Shared between all Linux installation topics: Amazon Linux, CentOS, Ubuntu, and RHEL 
located in the app/gateway/{version}/install folder.

Included in the setup.md include located in this folder - in two sections - Using a yaml declarative config file
and Seed Super Admin.
-->

{:.note}
> **Note:** When you start {{site.base_gateway}}, the NGINX master process runs as `root`, and the worker processes
run as `kong` by default. If this is not the desired behavior, you can switch the NGINX master process
to run on the built-in `kong` user or to a custom non-root user before starting {{site.base_gateway}}.
For more information, see
[Running Kong as a Non-Root User](/gateway/{{include.kong_version}}/plan-and-deploy/kong-user).
