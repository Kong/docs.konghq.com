<!-- Shared between all Enterprise Linux installation topics: Amazon Linux,
Amazon Linux 2, CentOS, Ubuntu, and RHEL -->

{:.note}
> **Note:** When you start Kong, the Nginx master process runs
as `root`, and the worker processes run as `kong` by
default. If this is not the desired behavior, you can switch the Nginx master process to run on the built-in
`kong` user or to a custom non-root user before starting Kong.
For more information, see [Running Kong as a Non-Root User](/gateway/{{include.release}}/plan-and-deploy/kong-user).
