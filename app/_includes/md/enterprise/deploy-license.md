<!-- This file is for deploying an enterprise license to Kong Gateway
and is used in the deploy-license.md file in enterprise > version number
> deployment > licenses folder and the vitals-influx-strategy.md file as well.
It has one parameter include.heading which must be included when used.  -->


You can deploy a license file in one of the following ways:

Method | Supported deployment types
-------|---
 `/licenses` Admin API endpoint | &#8226; Traditional database-backed deployment <br> &#8226; Hybrid mode deployment
File on the node filesystem <br>(`license.json`) | &#8226; Traditional database-backed deployment <br> &#8226; DB-less mode
Environment variable <br>(`KONG_LICENSE_DATA`) | &#8226; Traditional database-backed deployment <br> &#8226; DB-less mode
Environment variable <br>(`KONG_LICENSE_PATH`) | &#8226; Traditional database-backed deployment <br> &#8226; DB-less mode

The recommended method is using the Admin API.

{{ include.heading }} Prerequisites

* You have received a `license.json` file from Kong.
* {{site.base_gateway}} is installed.

{{ include.heading }} Deploy the license

{% navtabs %}
{% navtab Admin API %}

You can use the Kong Admin API to distribute the license in any database-backed
or hybrid mode deployment. We recommend using this method in most deployments.

In hybrid mode, apply the license to the control plane. The control plane
distributes the license to its data plane nodes. This is the only method that
applies the license to data planes automatically.

The license data must contain straight quotes to be considered valid JSON
(`'` and `"`, not `’` or `“`).

`POST` the contents of the provided `license.json` license to your
{{site.base_gateway}} instance:

{:.note}
> **Note:** The following license is only an example. You must use the
following format, but provide your own content.

{% navtabs codeblock %}
{% navtab cURL %}
```bash
$ curl -i -X POST http://localhost:8001/licenses \
  -d payload='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
$ http POST :8001/licenses \
  payload='{"license":{"payload":{"admin_seats":"1","customer":"Example Company, Inc","dataplanes":"1","license_creation_date":"2017-07-20","license_expiration_date":"2017-07-20","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU","product_subscription":"Konnect Enterprise","support_plan":"None"},"signature":"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b","version":"1"}}'
```
{% endnavtab %}
{% endnavtabs %}

Result:
```json
{
  "created_at": 1500508800,
  "id": "30b4edb7-0847-4f65-af90-efbed8b0161f",
  "payload": "{\"license\":{\"payload\":{\"admin_seats\":\"1\",\"customer\":\"Example Company, Inc\",\"dataplanes\":\"1\",\"license_creation_date\":\"2017-07-20\",\"license_expiration_date\":\"2017-07-20\",\"license_key\":\"00141000017ODj3AAG_a1V41000004wT0OEAU\",\"product_subscription\":\"Konnect Enterprise\",\"support_plan\":\"None\"},\"signature\":\"6985968131533a967fcc721244a979948b1066967f1e9cd65dbd8eeabe060fc32d894a2945f5e4a03c1cd2198c74e058ac63d28b045c2f1fcec95877bd790e1b\",\"version\":\"1\"}}",
  "updated_at": 1500508800
}
```

For more detail and options, see the
[Admin API `licenses` endpoint reference](/gateway/latest/licenses/examples).

{% endnavtab %}
{% navtab Filesystem %}

You can provide a license file to {{site.base_gateway}} in any database-backed or DB-less
deployment. This method is not recommended for use in hybrid mode, as you have
to maintain the license on each node manually.

The license data must contain straight quotes to be considered valid JSON
(`'` and `"`, not `’` or `“`).

1. Securely copy the `license.json` file to your home directory on the filesystem
where you have installed
{{site.base_gateway}}.

    ```sh
    $ scp license.json <system_username>@<server>:~
    ```

1. Then, copy the license file again, this time to the `/etc/kong` directory:

    ```sh
    $ scp license.json /etc/kong/license.json
    ```

    {{site.base_gateway}} will look for a valid license in this location.


{% endnavtab %}
{% navtab Environment variable (JSON) %}

You can use the `KONG_LICENSE_DATA` environment variable to apply a license to
{{site.base_gateway}} in any database-backed or DB-less deployment. This method
is not recommended for use in hybrid mode, as you have to maintain the license
on each node manually.

The license data must contain straight quotes to be considered valid JSON
(`'` and `"`, not `’` or `“`).

1. Export the license key to a variable by running the following command,
substituting your own license key.

    {:.note}
    > **Note:** The following license is only an example. You must use the
    following format, but provide your own content.

    ```bash
    $ export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'
    ```

1. Include the license as part of the `docker run` command when starting a {{site.base_gateway}} container:

    {% if_version gte:2.6.x lte:2.8.x %}
    {:.note}
    > **Note:** This is only a snippet. For a full working example, see the instructions to
    [Install {{site.base_gateway}} on Docker](/gateway/{{page.release}}/install-and-run/docker/).

    {% endif_version %}
    {% if_version gte:3.0.x %}
    {:.note}
    > **Note:** This is only a snippet. For a full working example, see the instructions to
    [Install {{site.base_gateway}} on Docker](/gateway/{{page.release}}/install/docker/).

    {% endif_version %}

    ```bash
    docker run -d --name kong-gateway \
     --network=kong-net \
     ...
     -e KONG_LICENSE_DATA \
     kong/kong-gateway:{{page.kong_versions[page.version-index].ee-version}}-alpine
    ```
{% endnavtab %}
{% navtab Environment variable (file path) %}

You can use the `KONG_LICENSE_PATH` environment variable to apply a license to
{{site.base_gateway}} in any database-backed or DB-less deployment. This method
is not recommended for use in hybrid mode, as you have to maintain the license
on each node manually.

Include the license as part of the `docker run` command when starting a
{{site.base_gateway}} container. Mount the path to the file on your
local filesystem to a directory in the Docker container, making the file visible
from the container:

{% if_version gte:2.6.x lte:2.8.x %}
{:.note}
> **Note:** This is only a snippet. For a full working example, see the instructions to
[Install {{site.base_gateway}} on Docker](/gateway/{{page.release}}/install-and-run/docker).

{% endif_version %}
{% if_version gte:3.0.x %}
{:.note}
> **Note:** This is only a snippet. For a full working example, see the instructions to
[Install {{site.base_gateway}} on Docker](/gateway/{{page.release}}/install/docker).

{% endif_version %}

```bash
docker run -d --name kong-gateway \
 --network=kong-net \
 ...
 -v "$(pwd)/kong-license/:/kong-license/" \
 -e "KONG_LICENSE_PATH=/kong-license/license.json" \
 kong/kong-gateway:{{page.kong_versions[page.version-index].ee-version}}-alpine
```

{% endnavtab %}
{% endnavtabs %}
