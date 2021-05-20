There are two options to install {{site.base_gateway}} on CentOS.

<!--2.x versions-->
{% if include.version == "2.x" %}

{% navtabs %}
{% navtab Download RPM file %}

1. Choose your CentOS version:
    * [CentOS 8]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/)
    * [CentOS 7]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/)
    * [CentOS 6]({{ site.links.download }}/gateway-2.x-centos-6/Packages/k/)

2. Click a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition-{{page.kong_versions[11].version}}.el8.noarch.rpm`

3. Copy the RPM file to your home directory on the CentOS system.

    For example:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[11].version}}.el8.noarch.rpm <centos user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    * [CentOS 8]({{ site.links.download }}/gateway-2.x-centos-8/config.repo)
    * [CentOS 7]({{ site.links.download }}/gateway-2.x-centos-7/config.repo)
    * [CentOS 6]({{ site.links.download }}/gateway-2.x-centos-6/config.repo)

2. Securely copy the repo file to your home directory on the CentOS system:

    ```bash
    $ scp config.repo <centos user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

{% endif %}

<!--1.5-->
{% if include.version == "1.5" %}

{% navtabs %}
{% navtab Download RPM file %}

1. Choose your CentOS version:
    * [CentOS 8]({{ site.links.download }}/gateway-1.x-centos-8/Packages/k/)
    * [CentOS 7]({{ site.links.download }}/gateway-1.x-centos-7/Packages/k/)
    * [CentOS 6]({{ site.links.download }}/gateway-1.x-centos-6/Packages/k/)
2. Select a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition-{{page.kong_versions[7].version}}.el8.noarch.rpm`

3. Copy the RPM file to your home directory on the CentOS system.

    For example:

    ```bash
    $ scp config.repo <centos user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    * [CentOS 8]({{ site.links.download }}/gateway-1.x-centos-8/config.repo)
    * [CentOS 7]({{ site.links.download }}/gateway-1.x-centos-7/config.repo)
    * [CentOS 6]({{ site.links.download }}/gateway-1.x-centos-6/config.repo)

2. Securely copy the repo file to your home directory on the CentOS system:

    ```bash
    $ scp config.repo <centos user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

{% endif %}
