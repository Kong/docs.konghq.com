---
title: Kong Mesh with Windows
---

To install and run {{site.mesh_product_name}} on Windows:

1. [Download {{site.mesh_product_name}}](#1-download-kong-mesh)
2. [Run {{site.mesh_product_name}}](#2-run-kong-mesh)
3. [Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here
and continue your {{site.mesh_product_name}} journey.

Tested on Windows 10 and Windows Server 2019.

{:.note}
> **Note**: Transparent proxying is not supported on Windows.

## 1. Download Kong Mesh

To run Kong Mesh on Windows you can choose among different installation methods:

{% navtabs %}
{% navtab PowerShell Script %}

Run the following script in PowerShell to automatically detect the operating system and download {{site.mesh_product_name}}:

```powershell
Invoke-Expression ([System.Text.Encoding]::UTF8.GetString((Invoke-WebRequest -Uri https://docs.konghq.com/mesh/installer_old.ps1).Content))
```

{% endnavtab %}
{% navtab Manually %}

You can also [download]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.version}}-windows-amd64.tar.gz)
the distribution manually.

Then extract the archive with:

```powershell
tar xvzf kong-mesh-{{page.version}}-windows-amd64.tar.gz
```
{% endnavtab %}
{% endnavtabs %}

## 2. Run Kong Mesh

Once downloaded, you will find the contents of {{site.mesh_product_name}} in the `kong-mesh-{{page.version}}` folder. In this folder, you will find &mdash; among other files &mdash; the bin directory that stores all the executables for {{site.mesh_product_name}}.

Navigate to the `bin` folder:

```powershell
cd kong-mesh-{{page.version}}/bin
```

Then, run the control plane with:

```sh
KMESH_LICENSE_PATH=/path/to/file/license.json kuma-cp run
```

This example will run {{site.mesh_product_name}} in standalone mode for a _flat_
deployment, but there are more advanced [deployment modes][deployments]
like _multi-zone_.

We suggest adding the `kumactl` executable to your `PATH` so that it's always available in every working directory (PowerShell as Administrator):

```powershell
New-Item -ItemType SymbolicLink -Path C:\Windows\kumactl.exe -Target .\kumactl.exe
```

This runs {{site.mesh_product_name}} with a [memory backend][backends],
but you can use a persistent storage like PostgreSQL by updating the `conf/kuma-cp.conf` file.

{% include /md/mesh/install-universal-verify.md %}

{% include /md/mesh/install-universal-quickstart.md %}


<!-- links -->
{% if_version gte:2.0.x %}
[deployments]: /mesh/{{page.kong_version}}/introduction/deployments/
[backends]: /mesh/{{page.kong_version}}/documentation/configuration/
{% endif_version %}

{% if_version lte:1.9.x %}
[deployments]: https://kuma.io/docs/latest/introduction/deployments/
[backends]: https://kuma.io/docs/latest/documentation/configuration/
{% endif_version %}

