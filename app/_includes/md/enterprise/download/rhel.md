1. Go to: [{{ site.links.download }}]({{ site.links.download }}).
2. Select the latest Kong version from the list. {{site.ee_product_name}} versions are listed in chronological order.
3. Select the RHEL version appropriate for your environment, such as `rhel-8`.
4. Select `Packages`> `k/`.
5. Click the RPM file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[10].version}}.rhel8.noarch.rpm`
6. Copy the RPM file to your home directory on the RHEL system.
For example:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[10].version}}.rhel8.noarch.rpm <rhel user>@<server>:~
    ```