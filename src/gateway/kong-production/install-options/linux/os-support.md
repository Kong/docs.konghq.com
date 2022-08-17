---
title: Supported Operating Systems
---

{% assign os_versions = site.data.tables.os_support %}

## Supported

Kong Gateway currently supports the following Linux operating systems:

<table>
  <thead>
      <th>OS version</th>
      <th style="text-align: center">First Enterprise Gateway version</th>
      <th style="text-align: center">First open-source Gateway version</th>
  </thead>
  <tbody>
  {% for item in os_versions %}
    {% if item.status == "active" %}
      <tr>
        <td>
          {{ item.name }}
        </td>
        <td style="text-align: center">
          {% if item.enterprise == true and item.enterprise_versions.first_version != null %}
            {{ item.enterprise_versions.first_version }}
          {% else %}
          Not supported
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if item.oss == true and item.oss_versions.first_version != null %}
            {{ item.oss_versions.first_version }}
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
      <th style="text-align: center">Last Enterprise Gateway version</th>
      <th style="text-align: center">Last open-source Gateway version</th>
  </thead>
  <tbody>
  {% for item in os_versions %}
    {% if item.status == "deprecated" %}
      <tr>
        <td>
          {{ item.name }}
        </td>
        <td>
          <a href="{{ item.eol_link }}">{{ item.deprecation_date }}</a>
        </td>
        <td style="text-align: center">
          {% if item.enterprise == true %}
            {{ item.enterprise_versions.last_version }}
          {% else %}
          Not applicable
          {% endif %}
        </td>
        <td style="text-align: center">
          {% if item.oss == true %}
            {{ item.oss_versions.last_version }}
          {% else %}
          Not applicable
          {% endif %}
        </td>
      </tr>
      {% endif %}
    {% endfor %}
  </tbody>
</table>
