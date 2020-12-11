---
title: Running Kong as a Non-Root User
---

After installing {{site.ce_product_name}} on a GNU/Linux system, you can
configure Kong to run as the built-in `kong` user and group instead of `root`.
This makes the Nginx master and worker processes run as the `kong` user and
group, overriding any settings in the
[`nginx_user`](/{{page.kong_version}}/configuration/#nginx_user)
configuration property.

<div class="alert alert-warning">
<i class="fas fa-exclamation-triangle" style="color:orange; margin-right:3px"></i>
  <b>Warning</b>
  <br>The Nginx master process needs to run as <code>root</code> for
  Nginx to execute certain actions (for example, to listen on the privileged
  port 80).
  <br>
  <br>Although running Kong as the <code>kong</code> user
  and group does provide more security, we advise that a system and network
  administration evaluation be performed before making this decision. Otherwise,
  Kong nodes might become unavailable due to insufficient permissions to execute
  privileged system calls in the operating system.
</div>

## Prerequisites

{{site.ce_product_name}} is installed on one of the following Linux distributions:
* [Amazon Linux](/install/aws-linux)
* [CentOS](/install/centos)
* [Debian](/install/debian)
* [RedHat](/install/redhat)
* [Ubuntu](/install/ubuntu)

## Run Kong Gateway as the built-in kong user

When {{site.ce_product_name}} is installed with a package management system such as `APT` or `YUM`, a default `kong` user and a default `kong` group are created. All the files installed by the package are owned by the `kong` user and group.

1. Switch to the built-in `kong` user:

    ```sh
    $ su kong
    ```
2. Start Kong:

    ```sh
    kong start
    ```

## Run Kong Gateway as a custom non-root user

It is also possible running Kong as a custom non-root user. Since all the files installed by the {{site.ce_product_name}} package are owned by the `kong` group, a user that belongs to that group should be permitted to perform the same operations as the `kong` user.

1. Add the user to the `kong` group

    ```sh
    sudo usermod -aG kong your-user
    ```

2. Start Kong:

    ```sh
    kong start
    ```
