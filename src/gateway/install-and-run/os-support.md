---
title: Supported Operating Systems
---

{% assign os_versions = site.data.tables.os_support %}

## Supported

Kong Gateway currently supports the following Linux operating systems:

<table>
  <thead>
      <th>OS version</th>
      <th>First Enterprise version</th>
      <th>First open-source version</th>
  </thead>
  <tbody>
  {% for os_version in os_versions %}
    {% if os_version.status == "active" %}
      <tr>
        <td>
          {{ os_version.name }}
        </td>
        <td style="text-align: center">
          {% if os_version.enterprise == true and os_version.enterprise_versions.first_version != null %}
            {{ os_version.enterprise_versions.first_version }}
          {% else %}
          Not supported
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if os_version.oss == true and os_version.oss_versions.first_version != null %}
            {{ os_version.oss_versions.first_version }}
          {% else %}
          Not supported
          {% endif %}
        </td>
      </tr>
      {% endif %}
    {% endfor %}
  </tbody>
</table>

## Deprecated

The following versions have reached end of life (EoL) and are no longer
supported by Kong:

<table>
  <thead>
      <th>OS version</th>
      <th>End of Life</th>
      <th>Last Enterprise version</th>
      <th>Last open-source version</th>
  </thead>
  <tbody>
  {% for os_version in os_versions %}
    {% if os_version.status == "deprecated" %}
      <tr>
        <td>
          {{ os_version.name }}
        </td>
        <td>
          <a href="{{ os_version.eol_link }}">{{ os_version.deprecation_date }}</a>
        </td>
        <td style="text-align: center">
          {% if os_version.enterprise == true %}
            {{ os_version.enterprise_versions.last_version }}
          {% else %}
          Not applicable
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if os_version.oss == true %}
            {{ os_version.oss_versions.last_version }}
          {% else %}
          Not applicable
          {% endif %}
        </td>
      </tr>
      {% endif %}
    {% endfor %}
  </tbody>
</table>
