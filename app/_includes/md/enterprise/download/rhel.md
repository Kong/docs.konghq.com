
There are two options to install {{site.base_gateway}} on RHEL.

<!-- 2.x versions -->
{% if include.version == "2.x" %}

{% navtabs %}
{% navtab Download RPM file %}

1. Choose your RHEL version:

    * [RHEL 8]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/)
    * [RHEL 7]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/)

2. Click a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition-{{page.kong_versions[10].version}}.rhel8.noarch.rpm`

3. Copy the RPM file to your home directory on the RHEL system.

    For example:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[10].version}}.rhel8.noarch.rpm <rhel user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    * [RHEL 8]({{ site.links.download }}/gateway-2.x-rhel-8/config.repo)
    * [RHEL 7]({{ site.links.download }}/gateway-2.x-rhel-7/config.repo)
    
2. Securely copy the repo file to your home directory on the RHEL system:

    ```bash
    $ scp config.repo <rhel user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

{% endif %}

<!-- 1.5 -->
{% if include.version == "1.5" %}

{% navtabs %}
{% navtab Download RPM file %}

1. Choose your RHEL version:

    * [RHEL 8]({{ site.links.download }}/gateway-1.x-rhel-8/Packages/k/)
    * [RHEL 7]({{ site.links.download }}/gateway-1.x-rhel-7/Packages/k/)
    * [RHEL 6]({{ site.links.download }}/gateway-1.x-rhel-6/Packages/k/)

2. Click a {{site.base_gateway}} version from the list to download it.

    Versions are listed in chronological order.

    For example: `kong-enterprise-edition-{{page.kong_versions[7].version}}.rhel8.noarch.rpm`

3. Copy the RPM file to your home directory on the RHEL system.

    For example:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[7].version}}.rhel8.noarch.rpm <rhel user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    * [RHEL 8]({{ site.links.download }}/gateway-1.x-rhel-8/config.repo)
    * [RHEL 7]({{ site.links.download }}/gateway-1.x-rhel-7/config.repo)
    * [RHEL 6]({{ site.links.download }}/gateway-1.x-rhel-6/config.repo)

2. Securely copy the repo file to your home directory on the RHEL system:

    ```bash
    $ scp config.repo <rhel user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

{% endif %}
