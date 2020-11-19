<!-- Shared between all Enterprise Linux installation topics: Amazon Linux,
Amazon Linux 2, CentOS, Ubuntu, and RHEL -->

<div class="alert alert-ee blue">
<b>Note:</b> When you start Kong, the Nginx master process runs
as <code>root</code>, and the worker processes run as <code>nobody</code> by
default. If this is not the desired behavior, you can switch to the built-in
<code>kong</code> user and group before starting Kong in the following steps.
For more information, see
<a href="/enterprise/{{page.kong_version}}/deployment/kong-user">Running Kong as a Non-Root User</a>.
</div>
