---
title: Konnect API Errors
content-type: reference
---

{% for entry in site.data.konnect_errors %}

<h2>{{ entry.title }}</h2>

{{ entry.description }}

<table style="width:100%; display:table;">
<thead>
  <tr>
    <th>Code</th>
    <th>Information</th>
  </tr>
</thead>
<tbody>
  {% for e in entry.errors %}
  {% assign error = e[1] %}
  <tr id="{{ e[0] }}">
    <td width="25%">
      {{ error.title }}
    </td>
    <td>
      <strong>Description:</strong><br />
      {{ error.description | newline_to_br }}
      <br /><br />
      <strong>Resolution:</strong><br />
      {{ error.resolution | newline_to_br }}
  
      {% if error.link %}
      <br /><br /><a href="{{ error.link.url }}">{{ error.link.text }} &raquo;</a>
      {% endif %}
    </td>
  </tr>
  {% endfor %}
</tbody>
</table>
{% endfor %}
