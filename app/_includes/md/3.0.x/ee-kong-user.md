<!-- Shared between all Enterprise Linux installation topics: Amazon Linux,
Amazon Linux 2, CentOS, Ubuntu, and RHEL -->

<div class="alert alert-ee blue">
<b>Note:</b> When you start Kong, the Nginx master process runs
as <code>root</code>, and the worker processes run as <code>kong</code> by
default. If this is not the desired behavior, you can switch the Nginx master process to run on the built-in
<code>kong</code> user or to a custom non-root user before starting Kong.
For more information, see
<a href="/enterprise/{{include.kong_version}}/deployment/kong-user">Running Kong as a Non-Root User</a>.
</div>
