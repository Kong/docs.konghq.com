{% if include.desc == "long" %}
   {:.important}
   > **Important:** The settings below are intended for non-production use **only**, as they override the default `admin_listen` setting to listen for requests from any source. **Do not** use these settings in environments directly exposed to the internet.
   >
   > <br>
   > If you need to expose the `admin_listen` port to the internet in a production environment,
   > {% if_version lte:2.8.x %}[secure it with authentication](/gateway/{{include.release}}/admin-api/secure-admin-api/).{% endif_version %}{% if_version gte:3.0.x %}[secure it with authentication](/gateway/{{include.release}}/production/running-kong/secure-admin-api/).{% endif_version %}


{% endif %}
{% if include.desc == "short" %}
   {:.important}
   > **Important**: If you need to expose the `admin_listen` port to the internet in a production environment,
  > {% if_version lte:2.8.x %}[secure it with authentication](/gateway/{{include.release}}/admin-api/secure-admin-api/).{% endif_version %}{% if_version gte:3.0.x %}[secure it with authentication](/gateway/{{include.release}}/production/running-kong/secure-admin-api/).{% endif_version %}

{% endif %}
