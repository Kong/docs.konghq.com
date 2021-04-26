1. Go to: [{{ site.links.download }}/gateway-2.x.amazonlinux-1/Packages/k]({{ site.links.download }}/gateway-2.x.amazonlinux-1/Packages/k).
2. Click the RPM file to download it.
    For example: `kong-enterprise-edition-{{page.kong_versions[10].version}}.aws.amd64.rpm`.
3. Copy the RPM file to your home directory on the Amazon Linux 2 system:

    ```bash
    $ scp kong-enterprise-edition-{{page.kong_versions[10].version}}.aws.amd64.rpm <amazon user>@<server>:~
    ```
