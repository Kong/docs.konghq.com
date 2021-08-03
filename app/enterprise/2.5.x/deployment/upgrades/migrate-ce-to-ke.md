---
title: Migrating from Kong Community Gateway to Kong Enterprise
toc: true
---

## Migrating from Kong Community Gateway 2.5.x to Kong Enterprise 2.5.x {#migrate-ce-ee}

As of {{site.ee_product_name}} version 2.1.x and later, it is no longer necessary to explicitly
run the `migrate-community-to-enterprise` command parameter to to migrate all
Kong Gateway entities to Kong Enterprise. Running the `kong migrations` commands
performs that migration command on your behalf.

<div class="alert alert-ee blue">
<strong>Important:</strong> You can only migrate to a {{site.ee_product_name}} version that
supports the same {{site.ce_product_name}} version.
</div>

### Prerequisites

<div class="alert alert-red">
     <strong>Warning:</strong> This action is irreversible, therefore it is strongly
     recommended to back up your production data before migrating from
     {{site.ce_product_name}} to {{site.ee_product_name}}.
</div>

* If running a version of {{site.ce_product_name}} earlier than 2.5.x,
  [upgrade to Kong 2.5.x](/gateway-oss/2.5.x/upgrading/) before migrating
  {{site.ce_product_name}} to {{site.ee_product_name}} 2.5.x.

#### Migration steps

The following steps guide you through the migration process.

1. Download {{site.ee_product_name}} 2.5.x and configure it to point to the
   same datastore as your {{site.ce_product_name}} 2.5.x node. The migration
   command expects the datastore to be up-to-date on any pending migration:

   ```shell
   $ kong migrations up [-c configuration_file]
   $ kong migrations finish [-c configuration_file]
   ```
2. Confirm that all of the entities are now available on your
   {{site.ee_product_name}} node.
