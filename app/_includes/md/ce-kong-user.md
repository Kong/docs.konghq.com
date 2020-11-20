<!-- Shared between all Community Linux installation topics: Amazon Linux,
 CentOS, Debian, RedHat, and Ubuntu -->

    **Note:** When you start Kong, the Nginx master process runs
    as `root` and the worker processes as `nobody` by default.
    If this is not the desired behavior, you can switch to the built-in
    `kong` user and group before starting Kong. For more information, see
    [Running Kong as a Non-Root User](/latest/kong-user).
