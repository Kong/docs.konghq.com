---
title: Software Bill of Materials
toc: false
---

A software bill of materials (SBOM) is an inventory of all software components (proprietary and open source), open source licenses, and dependencies in a given product. A software bill of materials (SBOM) provides visibility into the software supply chain and any license compliance, security, and quality risks that may exist.

Starting in {{site.mesh_product_name}} 2.7.4, we are generating SBOMs for {{site.mesh_product_name}} and Docker container images.

1. [Download security assets](https://packages.konghq.com/public/kong-mesh-binaries-release/raw/names/security-assets/versions/{{page.version}}/security-assets.tar.gz) for the latest version of {{site.mesh_product_name}}

2. Extract the downloaded `security-assets.tar.gz`

    ```sh
    tar -xvzf security-assets.tar.gz
    ```

3. Access the below SBOMs:

   * `sbom.spdx.json` and `sbom.cyclonedx.json` are the SBOM files for **binaries** built from {{site.mesh_product_name}}
   * `image_<image_name>-*.spdx.json` and `image_<image_name>-*.cyclonedx.json` are the SBOM files for **docker container images** of {{site.mesh_product_name}}
