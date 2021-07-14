There are two options to install {{site.base_gateway}} on Amazon Linux 1.

<!-- 2.x versions -->
{% if include.version == "2.x" %}

{% navtabs %}
{% navtab Download RPM file %}

1. Go to: [{{ site.links.download }}/gateway-2.x-amazonlinux-1/Packages/k/]({{ site.links.download }}/gateway-2.x-amazonlinux-1/Packages/k/).
2. Click the RPM file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[11].version}}.aws.amd64.rpm`.
3. Copy the RPM file to your home directory on the Amazon Linux 1 system:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[11].version}}.aws.amd64.rpm <amazon user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    [{{ site.links.download }}/gateway-2.x-amazonlinux-1/config.repo]({{ site.links.download }}/gateway-2.x-amazonlinux-1/config.repo)

2. Securely copy the repo file to your home directory on the Amazon
Linux 1 system. For example:

    ```bash
    $ scp config.repo <amazon user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

{% endif %}

<!-- 1.5 versions -->
{% if include.version == "1.5" %}

{% navtabs %}
{% navtab Download RPM file %}

1. Go to: [{{ site.links.download }}/gateway-1.x-amazonlinux-1/Packages/k/]({{ site.links.download }}/gateway-1.x-amazonlinux-1/Packages/k/).
2. Click the RPM file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[7].version}}.aws.amd64.rpm`.
3. Copy the RPM file to your home directory on the Amazon Linux 1 system:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[7].version}}.aws.amd64.rpm <amazon user>@<server>:~
    ```

{% endnavtab %}
{% navtab Download Kong repo file and add to Yum repo %}

1. Download and save the {{site.base_gateway}} RPM repo file as `config.repo`:

    [{{ site.links.download }}/gateway-1.x-amazonlinux-1/config.repo]({{ site.links.download }}/gateway-1.x-amazonlinux-1/config.repo)

2. Securely copy the repo file to your home directory on the Amazon
Linux 1 system. For example:

    ```bash
    $ scp config.repo <amazon user>@<server>:~
    ```

{% endnavtab %}
{% endnavtabs %}

{% endif %}
