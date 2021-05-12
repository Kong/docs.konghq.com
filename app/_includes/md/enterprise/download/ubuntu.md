<!-- 2.x versions -->
{% if include.version == "2.x" %}

1. Choose your Ubuntu version:
    * [Xenial]({{ site.links.download }}/gateway-2.x-ubuntu-xenial/pool/all/k/kong-enterprise-edition/)
    * [Focal]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong-enterprise-edition/)
    * [Bionic]({{ site.links.download }}/gateway-2.x-ubuntu-bionic/pool/all/k/kong-enterprise-edition/)
2. Select a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition_{{page.kong_versions[10].version}}_all.deb`

6. Copy the `.deb` file to your home directory on the Ubuntu system. For example:

    ```bash
    $ scp kong-enterprise-edition_{{page.kong_versions[10].version}}_all.deb <ubuntu_user>@<server>:~
    ```

{% endif %}

<!-- 1.5 versions -->
{% if include.version == "1.5" %}

1. Choose your Ubuntu version:
    * [Xenial]({{ site.links.download }}/gateway-1.x-ubuntu-xenial/pool/all/k/kong-enterprise-edition/)
    * [Bionic]({{ site.links.download }}/gateway-1.x-ubuntu-bionic/pool/all/k/kong-enterprise-edition/)
2. Select a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition_{{page.kong_versions[7].version}}_all.deb`

6. Copy the `.deb` file to your home directory on the Ubuntu system. For example:

    ```bash
    $ scp kong-enterprise-edition_{{page.kong_versions[7].version}}_all.deb <ubuntu_user>@<server>:~
    ```

{% endif %}
