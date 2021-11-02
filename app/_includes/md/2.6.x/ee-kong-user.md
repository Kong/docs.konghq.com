<!-- Shared between all Linux installation topics: Amazon Linux,
Amazon Linux 2, CentOS, Ubuntu, and RHEL -->

{:.note}
> **Note:** When you start Kong, the NGINX master process runs as `root`, and the worker processes
run as `kong` by default. If this is not the desired behavior, you can switch the NGINX master process
to run on the built-in `kong` user or to a custom non-root user before starting {{site.base_gateway}}.
For more information, see
[Running Kong as a Non-Root User](/gateway/{{include.kong_version}}/deployment/kong-user).
