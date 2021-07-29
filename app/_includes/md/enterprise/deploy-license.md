<!-- This file is for deploying an enterprise license to Kong Gateway
and is used in the deploy-license.md file in enterprise > version number
> deployment > licenses folder and the vitals-influx-strategy.md file as well.
It has one parameter include.heading which must be included when used.  -->


You can deploy a license file in one of the following ways:

* Through the `/licenses` Admin API endpoint.
* As a file on the node filesystem.

The recommended method is using the Admin API.

{{ include.heading }} Prerequisites

* You have received a `license.json` file from Kong.
* {{site.base_gateway}} is installed.

{{ include.heading }} Deploy the license

{% navtabs %}
{% navtab Admin API %}

`POST` the contents of the provided `license.json` license to your
{{site.base_gateway}} instance:

<div class="alert alert-ee blue">
<b>Note:</b>
The following license is only an example. You must use the following format,
but provide your own content.
</div>

{% navtabs codeblock %}
{% navtab cURL %}
```bash
$ curl -i -X POST http://<hostname>:8001/licenses \
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
[Admin API `licenses` endpoint reference](/enterprise/{{page.kong_version}}/admin-api/licenses/examples/).

{% endnavtab %}
{% navtab Filesystem %}

Securely copy the `license.json` file to your home directory on the filesystem
where you have installed
{{site.base_gateway}}:

```sh
$ scp license.json <system_username>@<server>:~
```

Then, copy the license file again, this time to the `/etc/kong` directory:

```sh
$ scp license.json /etc/kong/license.json
```

{{site.base_gateway}} will look for a valid license in this location.


{% endnavtab %}
{% navtab Environmental variable %}

Export the license key to a variable by running the following command,
substituting your own license key.

The license data must contain straight quotes to be considered valid JSON
(`'` and `"`, not `’` or `“`).

<div class="alert alert-ee blue">
<b>Note:</b>
The following license is only an example. You must use the following format,
but provide your own content.
</div>

```bash
$ export KONG_LICENSE_DATA='{"license":{"signature":"LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tClZlcnNpb246IEdudVBHIHYyCgpvd0did012TXdDSFdzMTVuUWw3dHhLK01wOTJTR0tLWVc3UU16WTBTVTVNc2toSVREWk1OTFEzVExJek1MY3dTCjA0ek1UVk1OREEwc2pRM04wOHpNalZKVHpOTE1EWk9TVTFLTXpRMVRVNHpTRXMzTjA0d056VXdUTytKWUdNUTQKR05oWW1VQ21NWEJ4Q3NDc3lMQmorTVBmOFhyWmZkNkNqVnJidmkyLzZ6THhzcitBclZtcFZWdnN1K1NiKzFhbgozcjNCeUxCZzdZOVdFL2FYQXJ0NG5lcmVpa2tZS1ozMlNlbGQvMm5iYkRzcmdlWFQzek1BQUE9PQo9b1VnSgotLS0tLUVORCBQR1AgTUVTU0FHRS0tLS0tCg=","payload":{"customer":"Test Company Inc","license_creation_date":"2017-11-08","product_subscription":"Kong Enterprise","admin_seats":"5","support_plan":"None","license_expiration_date":"2017-11-10","license_key":"00141000017ODj3AAG_a1V41000004wT0OEAU"},"version":1}}'
```

Apply the license to your {{site.base_gateway}} Docker container and reload the
gateway:

```sh
echo "-e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" \
kong reload exit" | docker exec -i <kong-container-id> /bin/sh \
```
{% endnavtab %}
{% endnavtabs %}
