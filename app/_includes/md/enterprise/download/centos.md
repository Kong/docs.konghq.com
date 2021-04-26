1. Go to: [{{ site.links.download }}]({{ site.links.download }}).
2. Select the latest Kong version from the list. {{site.ee_product_name}} versions are listed in chronological order.
3. Click the folder matching your target Centos OS version. For example, select `gateway-2.x-centos-7`.
4. Select `packages` >`k/`.
5. Click the RPM file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[10].version}}.el7.noarch.rpm` 
6. Copy the RPM file to your home directory on the CentOS system.
For example:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[10].version}}.el7.noarch.rpm <centos user>@<server>:~
    ```
    