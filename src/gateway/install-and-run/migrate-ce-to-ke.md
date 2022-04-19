---
title: Migrating from Kong Gateway (OSS) to Kong Gateway
toc: true
---

As of {{site.ee_product_name}} version 2.1.x and later, it is no longer necessary to explicitly
run the `migrate-community-to-enterprise` command parameter to to migrate all
{{site.ce_product_name}} entities to {{site.ee_product_name}}. Running the `kong migrations` commands
performs that migration command on your behalf.

{:.note}
> **Important:** You can only migrate to a {{site.ee_product_name}} version that
supports the same {{site.ce_product_name}} version.

## Prerequisites

{:.warning}
> **Warning:** This action is irreversible, therefore it is strongly
   recommended to back up your production data before migrating from
   {{site.ce_product_name}} to {{site.ee_product_name}}.

* If running a version of {{site.ce_product_name}} earlier than 2.8.x,
  [upgrade to Kong 2.8.x](/gateway/{{page.kong_version}}/install-and-run/upgrade-oss/) before migrating
  {{site.ce_product_name}} to {{site.ee_product_name}} 2.8.x.

## Migration steps

The following steps guide you through the migration process.

1. Download {{site.ee_product_name}} 2.8.x and configure it to point to the
   same datastore as your {{site.ce_product_name}} 2.8.x node. The migration
   command expects the datastore to be up-to-date on any pending migration:

   ```shell
   kong migrations up [-c configuration_file]
   kong migrations finish [-c configuration_file]
   ```

2. Confirm that all of the entities are now available on your
   {{site.ee_product_name}} node.
