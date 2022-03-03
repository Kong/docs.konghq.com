---
title: Running Kong as a Non-Root User
---

After installing {{site.base_gateway}} on a GNU/Linux system, you can
configure Kong to run as the built-in `kong` user and group instead of `root`.
This makes the Nginx master and worker processes run as the built-in `kong`
user and group, overriding any settings in the
[`nginx_user`](/gateway/{{page.kong_version}}/reference/configuration/#nginx_user)
configuration property. It is also possible to run Kong as a custom non-root user.

{:.important}
> **Important:** The Nginx master process needs to run as `root` for
Nginx to execute certain actions (for example, to listen on the privileged
port 80).
<br><br>
> Although running Kong as the `kong` user and group
does provide more security, we advise that a system and network
administration evaluation be performed before making this decision. Otherwise,
Kong nodes might become unavailable due to insufficient permissions to execute
privileged system calls in the operating system.

## Prerequisites

{{site.ee_product_name}} is installed on one of the following Linux distributions:
* [Amazon Linux 1 or 2](/gateway/{{page.kong_version}}/install-and-run/amazon-linux)
* [CentOS](/gateway/{{page.kong_version}}/install-and-run/centos)
* [RHEL](/gateway/{{page.kong_version}}/install-and-run/rhel)
* [Ubuntu](/gateway/{{page.kong_version}}/install-and-run/ubuntu)

## Run {{site.base_gateway}} as the built-in kong user

When {{site.base_gateway}} is installed with a package management system such as `APT` or `YUM`, a default `kong` user and a default `kong` group are created. All the files installed by the package are owned by the `kong` user and group.

1. Switch to the built-in `kong` user:

    ```sh
    $ su kong
    ```
2. Start Kong:

    ```sh
    kong start
    ```

## Run {{site.base_gateway}} as a custom non-root user

It is also possible to run Kong as a custom non-root user. Since all the files installed by the {{site.base_gateway}} package are owned by the `kong` group, a user that belongs to that group should be permitted to perform the same operations as the `kong` user.

1. Add the user to the `kong` group

    ```sh
    sudo usermod -aG kong your-user
    ```

2. Start Kong:

    ```sh
    kong start
    ```
