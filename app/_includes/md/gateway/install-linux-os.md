The quickest way to get started with {{ site.base_gateway }} is using the install script:

{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
bash <(curl -sS https://get.konghq.com/install) -v {{ include.versions_ee }}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
bash <(curl -sS https://get.konghq.com/install) -p kong -v {{ include.versions_ce }}
```
{% endnavtab %}
{% endnavtabs_ee %}

This script detects your operating system and automatically installs the correct package. 
It also installs a PostgreSQL database and bootstraps {{ site.base_gateway }} for you.

If you'd prefer to install just the {{site.base_gateway}} package, see the [Package Install](#package-install) section.

### Verify install

Once the script completes, run the following in the same terminal window:

```bash
curl -i http://localhost:8001
```

You should receive a `200` status code.

### Next steps

Once {{ site.base_gateway }} is running, you may want to do the following:

* Optional: [Add your Enterprise license](/gateway/{{ include.kong_version }}/licenses/deploy)
* Enable Kong Manager:
  * [Kong Manager Enterprise](/gateway/{{ include.kong_version }}/kong-manager/enable/)
  * [Kong Manager OSS](/gateway/{{ include.kong_version }}/kong-manager-oss/)
* [Enable Dev Portal](/gateway/{{ include.kong_version }}/kong-enterprise/dev-portal/enable/)
* [Create services and routes](/gateway/{{ include.kong_version }}/get-started/services-and-routes/)