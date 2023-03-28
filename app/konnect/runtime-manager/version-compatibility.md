---
title: Version Compatibility in Runtime Groups
content_type: reference
---

We recommend running one major version (2.x or 3.x) of a runtime instance per runtime group, unless you are in the middle of version upgrades to the data plane.

If you mix major runtime instance versions, the control plane will support the least common subset of configurations across all the versions connected to the {{site.konnect_short_name}} control plane.
For example, if you are running 2.8.1.3 on one runtime instance and 3.0.0.0 on another, the control plane will only push configurations that can be used by the 2.8.1.3 runtime instance.

If you experience compatibility errors, [upgrade your data planes](/konnect/runtime-manager/runtime-instances/upgrade/) to match the version of the highest-versioned runtime instance in your runtime group.

Possible compatibility errors:

{% assign errors = site.data.tables.version_errors_konnect %}

<table>
  <thead>
      <th>Error code</th>
      <th>Severity</th>
      <th>Description</th>
      <th>Resolution</th>
      <th class="width=25%">References</th>
  </thead>
<tbody>
  {% for message in errors.messages %}
      <tr>
        <td>
          {{ message.ID | markdownify }}
        </td>
        <td>
          {{ message.Severity | markdownify }}
        </td>
        <td>
          {{ message.Description | markdownify }}
        </td>
        <td>
          {{ message.Resolution | markdownify }}
        </td>
        <td>
          {{ message.DocumentationURL | markdownify }}
        </td>
      </tr>
    {% endfor %}
  </tbody>
</table>