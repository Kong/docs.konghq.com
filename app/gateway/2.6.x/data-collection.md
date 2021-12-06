---
title: Kong Gateway Data Collection
---

{{site.base_gateway}} collects data about your deployment by default. The collected data is sent to Kong servers for storage and aggregation. This page explains what data is collected, and how to disable data collection.

## Disable data collection

You can disable data collection by setting an environment variable, or by editing your `kong.conf` file. Either:

*  Set the following environment variable:

    ```sh
    export KONG_ANONYMOUS_REPORTS=off
    ```

*  In your `kong.conf` file, set:

   ```yaml
   anonymous_reports = off
   ```

## What data is collected

| Data field | Definition | 
|---|---|
| database  | Where your configuration is stored. One of `postgres`, `cassandra`, or `off` (for in-memory datastore).  | 
| dns_hostsfile  | The /etc/hosts file for your deployment. | 
| declarative_config  | Your {{site.base_gateway}} configuration file. | 

Lists of plugins you add to {{site.base_gateway}} services or routes are also collected.