<!-- instructions for 1.3.x and earlier -->
{% if include.install == "OS" %}
1. To install {{site.base_gateway}} versions 1.3.x and earlier, open a
[support case](https://support.konghq.com/) to request an authenticated time-sensitive URL.

2. Click the URL to download your {{site.base_gateway}} installation package.
{% endif %}

{% if include.install == "docker" %}

1. To install {{site.base_gateway}} versions 1.3.x and earlier, open a
[support case](https://support.konghq.com/) to request a Docker image.
Kong Support will walk you through downloading the image.

2. Once you have the image, look it up locally:

    ```bash
    $ docker images
    ```

2. Tag the image ID for easier use:

    ```bash
    $ docker tag <IMAGE_ID> kong-ee
    ```

    **Note:** Replace `<IMAGE_ID>` with the one matching your repository.
{% endif %}
