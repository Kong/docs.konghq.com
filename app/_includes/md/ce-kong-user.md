<!-- Shared between all Community Linux installation topics: Amazon Linux,
 CentOS, Debian, RedHat, and Ubuntu -->

    **Note:** When you start Kong, the Nginx master process runs
    as `root` and the worker processes as `kong` by default.
    If this is not the desired behavior, you can switch the Nginx master process to run on the built-in
    `kong` user or to a custom non-root user before starting Kong. For more
    information, see [Running Kong as a Non-Root User](/gateway/latest/plan-and-deploy/kong-user).
