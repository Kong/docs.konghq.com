---
title: Running Kong as a Non-Root User
---

After installing {{site.ee_product_name}} on a GNU/Linux system, you can
configure Kong to run as the built-in `kong` user instead of the `root` user.
This makes the Nginx master and worker processes use the built-in `kong` user and group credentials, overriding any settings in the
[`nginx_user`](/enterprise/{{page.kong_version}}/property-reference/#nginx_user)
configuration property. It is also possible to run Kong as a custom non-root user.

{:.important}
> **Important:** The Nginx master process needs to run as `root` for
Nginx to execute certain actions (for example, to listen on the privileged
port 80).
<br><br>
> Although running Kong as the `kong` user
does provide more security, we advise that a system and network
administration evaluation be performed before making this decision. Otherwise,
Kong nodes might become unavailable due to insufficient permissions to execute
privileged system calls in the operating system.

## Prerequisites

{{site.ee_product_name}} is installed on one of the following Linux distributions:
* [Amazon Linux](/enterprise/{{page.kong_version}}/deployment/installation/amazon-linux)
* [Amazon Linux 2](/enterprise/{{page.kong_version}}/deployment/installation/amazon-linux-2)
* [CentOS](/enterprise/{{page.kong_version}}/deployment/installation/centos)
* [RHEL](/enterprise/{{page.kong_version}}/deployment/installation/rhel)
* [Ubuntu](/enterprise/{{page.kong_version}}/deployment/installation/ubuntu)

## Run {{site.ee_product_name}} as the built-in kong user

When {{site.ee_product_name}} is installed with a package management system such as `APT` or `YUM`, a default `kong` user and a default `kong` group are created. All the files installed by the package are owned by the `kong` user and group.

1. Switch to the built-in `kong` user:

    ```sh
    $ su kong
    ```
2. Start Kong:

    ```sh
    kong start
    ```

## Run {{site.ee_product_name}} as a custom non-root user

It is also possible to run Kong as a custom non-root user. Since all the files installed by the {{site.ee_product_name}} package are owned by the `kong` group, a user that belongs to that group should be permitted to perform the same operations as the `kong` user.

1. Add the user to the `kong` group

    ```sh
    sudo usermod -aG kong your-user
    ```

2. Start Kong:

    ```sh
    kong start
    ```
