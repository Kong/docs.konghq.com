1. Go to: [{{ site.links.download }}]({{ site.links.download }}).
2. Select the latest Kong version from the list. {{site.ee_product_name}} versions are listed in chronological order.
3. Click the folder matching your target Ubuntu OS version. For example, select `gateway-2.x-ubuntu-bionic` for the Ubuntu Bionic Beaver release.
4. Select `pool/` > `all/` > `k/` > `kong-enterprise-edition`.
5. Click the `.deb` file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[10].version}}.all.deb`
6. Copy the `.deb` file to your home directory on the Ubuntu system. For example:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[10].version}}.all.deb <ubuntu_user>@<server>:~
    ```
