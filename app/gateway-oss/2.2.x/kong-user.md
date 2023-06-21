---
title: Running Kong as a Non-Root User
---

After installing {{site.ce_product_name}} on a GNU/Linux system, you can
configure Kong to run as the built-in `kong` user instead of the `root` user.
This makes the Nginx master and worker processes use the built-in `kong` user and group credentials, overriding any settings in the
[`nginx_user`](/gateway-oss/{{page.kong_version}}/configuration/#nginx_user)
configuration property. It is also possible to run Kong as a custom non-root user.

<div class="alert alert-warning">
<i class="fas fa-exclamation-triangle" style="color:orange; margin-right:3px"></i>
  <b>Warning</b>
  <br>The Nginx master process needs to run as <code>root</code> for
  Nginx to execute certain actions (for example, to listen on the privileged
  port 80).
  <br>
  <br>Although running Kong as the <code>kong</code> user
  does provide more security, we advise that a system and network
  administration evaluation be performed before making this decision. Otherwise,
  Kong nodes might become unavailable due to insufficient permissions to execute
  privileged system calls in the operating system.
</div>

## Prerequisites

{{site.ce_product_name}} is installed on one of the following Linux distributions:
* [Amazon Linux](/gateway/latest/install/linux/amazon-linux/)
* [Debian](/gateway/latest/install/linux/debian/)
* [Red Hat](/gateway/latest/install/linux/rhel/)
* [Ubuntu](/gateway/latest/install/linux/ubuntu/)
* CentOS

## Run {{site.ce_product_name}} as the built-in kong user

When {{site.ce_product_name}} is installed with a package management system such as `APT` or `YUM`, a default `kong` user and a default `kong` group are created. All the files installed by the package are owned by the `kong` user and group.

1. Switch to the built-in `kong` user:

    ```sh
    $ su kong
    ```
2. Start Kong:

    ```sh
    kong start
    ```

## Run {{site.ce_product_name}} as a custom non-root user

It is also possible to run Kong as a custom non-root user. Since all the files installed by the {{site.ce_product_name}} package are owned by the `kong` group, a user that belongs to that group should be permitted to perform the same operations as the `kong` user.

1. Add the user to the `kong` group

    ```sh
    sudo usermod -aG kong your-user
    ```

2. Start Kong:

    ```sh
    kong start
    ```
