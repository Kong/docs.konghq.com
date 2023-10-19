---
title: Kong Enterprise LTS 2.8 to 3.4 upgrade guide
badge: enterprise
---

Kong has prepared this guide for those customers who are running the latest version of Kong-EE 2.8.x.x LTS and wish to migrate directly to Kong-EE 3.4.x.x LTS.

Kong is committed to a strong LTS offering and we recognize that many customers will want to only upgrade Kong between LTS versions. We are proud to announce this guide tailored to this particular upgrade pattern.

Please see the below steps on how to make your migration successful. It’s very important to understand all the preparation steps and choose the recommended upgrade path based on your deployment type.

## Upgrade journey overview

An important part of any migration is the preparation phase.  There are a number of steps you must complete before you upgrade to Kong 3.4.x.x LTS. This includes items such as any listed prerequisties, backing up your database (if applicable), reviewing the changelog for any breaking changes, choosing the right strategy for upgrading, and testing in a pre-production environment. All recommended actions for preparation can be found in the Preparation section of this document.

Secondly, the execution of the migration will be dependent on the type of deployment you have with Kong. In this guide, we offer a recommendation for the type of strategy to use per supported deployment type. See the Upgrade Strategy section of this document to choose the right strategy for you.

Preparation:
1. Identify the gateway to upgrade
2. Back up data
3. Choose a strategy based on the deployment mode/topology
4. Review gateway changes from 2.8 to 3.4

Perform upgrade:
1. Execute your chose upgrade strategy
2. Move from dev to prod
3. Smoke test
4. Wrap up the upgrade or roll back and try again

## Prerequisites

Please read this document thoroughly to successfully complete the upgrade process, which includes all the necessary operational knowledge for the upgrade.

* If you are using Cassandra. starting from 3.4, Cassandra is not supported. 
You will need to migrate off of Cassandra first and upgrade second.
* Please conduct a thorough examination of the modifications made to the kong.conf file between two LTS.
* KIC upgrade compatibility - ??
* decK upgrade compatibility - ??

## Preparation

The migration pattern described in this document can only happen between two LTS versions, Kong-EE 2.8 LTS and Kong-EE 3.4 LTS. If you apply this document to other release intervals, database modifications may be run in the wrong sequence and leave the database schema in a broken state.

The following instructions lay out how to back up your configuration for each supported deployment type. This is an important step prior to migrating. Each supported deployment mode will have different instructions for backup.

### Backup 
#### DB-less mode backup

In DB-less mode, configuration is managed declaratively, using a tool called decK. Deck allows you to ‘dump’ and ‘sync’ configuration in db-less mode. Backing up your configuration for this mode is simple - use decK to dump the configuration and store the resulting file in a secure location. If you need to roll back, simply change the db-less Kong instance back to 2.8 LTS and sync with your backed up configuration file.

#### Database backup
We recommend the following two methods to back up database data.

1. Direct database operation. Depending on the database in use (e.g. Postgres or Cassandra), a database dump is recommended, so that you can recover the database quickly in a database-native way. Assume Postgres is the database in use, you can dump data in text format, tar format (no compression), or directory format (with compression) by command pg_dump. Here is a quick example:

    ```sh
    pg_dump -U kong -d kong -F d -f kongdb_backup_20230816
    ```

    This backup method is convenient but requires you to be careful, especially when the database serves also other applications other than Kong Gateway.

1. Kong Gateway tool. Kong Gateway supports managing Kong Gateway entities by either deck or kong config CLI in declarative format. deck is more powerful than the “kong config” CLI in that it invalidates Kong cache automatically and overwrite entities in database. Please use deck unless you are sure of the “kong config” CLI, otherwise you might get unexpected outcome. Here is a quick example:

    ```sh
    deck ping
    deck dump --all-workspaces -o /path/to/kong_backup.yaml
    ```

    If you are encountered with deck performance issues (e.g. huge number of entities), please increase the number of deck threads by option “--parallelism”, or utilize deck’s Distributed Configuration feature.

    deck currently does not support DB-less mode, and requires Kong Gateway be online when backing up or restoring data. Additionally, deck does not manage enterprise-only entities, like roles or permissions of RBAC, credentials, keyring, licence, etc. Please configure these security related entities separately. Considering the limitations, backup and restore with deck is just the last resort.

Before upgrading, you should at least choose one of the methods, and we highly recommend to back up data in both methods, which offers you recovery flexibility. In case of upgrade failure, try to do a database-level restore first, and otherwise bootstrap a new database and use deck.

#### Keyring materials backup
If you happen to have enabled the Keyring and Data Encryption, you must separately back up and restore keyring materials. If the encryption key is lost, you will permanently lose access to the encrypted Kong configuration data and there is no way to recover it.

For technical details, refer to the manual backup method and the automatic backup method. 

#### kong.conf backup
Last but not least, customers should also back up files listed but not limited to as follows:

1. Kong Gateway configuration file `kong.conf`.
2. Files in Kong Gateway prefix, like key, certificate, “nginx-kong.conf”, etc.
3. Any other files customers created to assist in Kong Gateway deployment.

Although these files do not contain Kong configuration data, without which, we cannot even get Kong Gateway up. To restore these static files, just copy and paste.

### Deployment modes

[image of flow chart]

#### DB-less mode
DB-less mode is special in that each independent Kong node loads a copy of Kong configuration data into memory, without persistent database storage, so failure of some nodes will not spread to others.

Customers in this mode are recommended to adopt the [Rolling Upgrade]. This strategy relies on changes being made to the kong.yaml and then reloading the db-less instance of Kong.

It is highly recommended to take a backup of your current kong.yaml file before starting the upgrade as mentioned above.

#### Traditional mode
Kong is committed to support traditional mode deployments as it used by a large percentage of our customer base. A stable upgrade procedure is critical for traditional mode customers. 

Dual-cluster Upgrade and In-place Upgrade are the recommended strategies. 
Kong's recommendation is to use a dual cluster upgrade if the resources are available.

#### Hybrid Mode

Hybrid mode comprises one or more “control_plane” (CP) nodes, and one or more “data_plane” (DP) nodes. Therefore, the recommended upgrade process is a combination of different upgrade strategies for each type of node, CP or DP.

The major challenge with a hybrid mode upgrade is the communication between CP and DP.

Hybrid mode requires that the CP cannot be running a version of Kong that is older than the DPs. For this reason, customers must upgrade their CPs first, and then the DPs.

The workflow in figure as below, and we will not repeat the exact upgrade steps. With this approach there is no business downtime. This is the best strategy for customers upgrading in hybrid mode.

[diagram]

1. Upgrade CP first in accord with the recommendations in dual-cluster or in-place strategies, while DP nodes are still serving requests. However, the In-place Upgrade strategy is recommended as DPs are still serving traffic.

2. Upgrade DP nodes with exactly the same recommendation in section DB-less Mode. DP should point to new CP after CP is upgraded.

3. There's no kong.yml on DP to backup for.


### Upgrade strategies

#### Dual-cluster upgrade

Upgrading a Kong API Gateway from one LTS (Long-Term Support) version to another LTS version with zero downtime can be achieved through a dual cluster deployment strategy. This approach involves setting up a new cluster running the upgraded version of Kong alongside the existing cluster running the current version.

The process typically involves the following steps:

1. Provision a Same Size Deployment: You need to ensure that the new cluster, which will run the upgraded version of Kong, has the same capacity and resources as the existing cluster. This ensures that both clusters can handle the same amount of traffic and workload.

2. Set up Dual Cluster Deployment: Once the new cluster is provisioned, you can start deploying your APIs and configurations to both clusters simultaneously. The dual cluster deployment allows both the old and new clusters to coexist and process requests in parallel.

3. Data Synchronization: During the dual cluster deployment, data synchronization is crucial to ensure that both clusters have the same data. This can involve migrating data from the old cluster to the new one or setting up a shared data storage solution to keep both clusters in sync.

4. Traffic Rerouting: As the new cluster is running alongside the old one, you can start gradually routing incoming traffic to the new cluster. This process can be done gradually or through a controlled switchover mechanism to minimize any impact on users.

5. Testing and Validation: Before performing a complete switchover to the new cluster, it is essential to thoroughly test and validate the functionality of the upgraded version. This includes testing APIs, plugins, authentication mechanisms, and other functionalities to ensure they are working as expected.

6. Complete Switchover: Once you are confident that the upgraded cluster is fully functional and stable, you can redirect all incoming traffic to the new cluster. This step completes the upgrade process and decommissions the old cluster.

7. By following this dual cluster deployment strategy, you can achieve a smooth and zero-downtime upgrade from one LTS version of Kong to another. This approach helps ensure high availability and uninterrupted service for your users throughout the upgrade process.

#### Actual steps

Dual-cluster strategy refers to the practice that a new Kong cluster of version Y is deployed alongside the current version X, so that two clusters serve requests concurrently during the upgrade process, as illustrated in figure 1.

[image goes here]

Upgrade is achieved by gradually adjusting traffic ratio between the two clusters. The following are the steps required to perform an upgrade using this strategy.

Stop any Kong configuration updates (e.g. Admin API call), which is critical to guarantee the data consistency between cluster X and cluster Y.
Back up data of current version X as instructed in section Backup and Rollback.
Back up the existing database if Kong Gateway is deployed in Traditional Mode or Hybrid mode.
Dump the declarative Kong configuration data, namely “kong.yml” using deck dump.
Back up keyring materials if the Keyring and Data Encryption feature is enabled.
Any other applicable static data (e.g. “kong.conf”).
Evaluate factors that may impact the upgrade, as described in Upgrade Considerations. You may have to consider customization of both “kong.conf” and Kong configuration data.
Deploy a new Kong cluster of version Y.
Install a new Kong cluster of version Y as instructed at Kong Gateway Installation Options.
Install a new database of the same version, with the backup data from step 2 above, and configure cluster Y to point to the new database.
Run “kong migrations up” and “kong migrations finish”, and start cluster Y.
Perform appropriate staging tests against version Y to make sure it works for all use cases. For instance, does the plugin key-auth-enc does authenticate requests properly? If the outcome is not as expected, please validate step 3.
Divert traffic from cluster X to Y. This is usually done gradually and incrementally, depending on the risk profile of the deployment.  Any load balancers that support traffic splitting suffice, like DNS, Nginx, Kubernetes rollout mechanisms, etc.
Actively monitor all proxy metrics.
If any issues are found, rollback by setting all traffic to cluster X, investigate issues and repeat steps above.
Decommission cluster X to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keeps monitoring metrics for a while.

To keep data consistency between the two clusters, you must not execute any write operations through Admin API, Kong Manager or direct database updates. This upgrade strategy is the safest of all available strategies and ensures that there is no planned business downtime during the upgrade process.

This method has limitations on automatically generated runtime metrics. For example, if the Rate-Limiting-Advanced plugin is configured to store request counters in the database, the counters between database X and database Y are not synchronized. The impact scope depends on the “window_size” parameter of the plugin. Similarly, the same limitation applies to Vitals if you have a large amount of buffered metrics in Postgres or Cassandra.

The Dual-cluster upgrade strategy was once named as “DB-clone Upgrade Strategy” from our official document.

#### In-place upgrade

Similar to but unlike the Dual-cluster Upgrade strategy, in-place upgrade as shown in figure 2 reuses the existing database and has to shut down the cluster X first and then configure the new cluster Y to point to the database.

[image goes here]

There is business downtime as cluster X is stopped during the upgrade process. You must carefully review the upgrade considerations in advance. The prescribed steps below are recommended for you.

Stop any Kong configuration updates (e.g. Admin API call), which is critical to guarantee the data consistency between cluster X and cluster Y.
Back up data of current version X as instructed in section Backup and Rollback.
Back up the existing database if Kong Gateway is deployed in Traditional Mode or Hybrid mode.
Dump the declarative Kong configuration data, namely “kong.yml” using deck dump.
Back up keyring materials if the Keyring and Data Encryption feature is enabled.
Any other applicable static data (e.g. “kong.conf”).
Evaluate factors that may impact the upgrade, as described in Upgrade Considerations. you may have to consider customization of both “kong.conf” and Kong configuration data.
Perform appropriate staging tests against version Y to make sure it works for all use cases, which can be done by running Kong Gateway in a docker container. For instance, does the plugin key-auth-enc does authenticate requests properly? If the outcome is not as expected, please validate step 3.
Stop Kong nodes of cluster X but keep the database running.
Install a cluster of version Y and configure it pointing to the existing database. The installation method varies and depends on your favour. Please read instructions at Kong Gateway Installation Options. 
Run “kong migrations up” and “kong migrations finish”, and start cluster Y.
Actively monitoring all proxy metrics.
Rollback if anything is wrong. To speed up, please prioritize the database-level method over the application-level method.
Decommission cluster X to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keeps monitoring metrics for a while.

We do not recommend using this strategy unless the architecture and infrastructure around Kong Gateway remains unaffected when Kong is not able to serve traffic – something that is rare in practice. It can be used under extreme resource constrained environment, which, once again, is rare for Kong deployments.

#### Rolling Upgrade

Rolling Upgrade is an upgrade strategy designated specifically for the DB-less mode or the DP part of Hybrid mode, due to the fact that Kong nodes without database are independent of each other. The upgrade is a process of continuously adding new Kong nodes of version Y, while tearing down current Kong nodes of version X.

The procedure below echoes the illustration in figure 4 for DB-less mode as an example.

Stop any Kong configuration updates, which is critical to guarantee the data consistency between X and Y.
Back up data of current version X as instructed in section Backup and Rollback.
Save a copy of Kong configuration “kong.yml” to a safe place.
Any other applicable static data (e.g. “kong.conf”).
Evaluate factors that may impact the upgrade, as described in Upgrade Considerations. You may have to consider customization of both “kong.conf” and Kong configuration data.
Install a new node of version Y, and perform appropriate staging tests to make sure it works for all use cases. For instance, does the plugin key-auth-enc authenticate requests properly? Please at least run “deck validate” to validate the compatibility of Kong configuration data. If the outcome is not as expected, please validate step 3
Continuously install and launch more Y nodes.
Divert traffic from X to Y. This is usually done gradually and incrementally, depending on the risk profile of the deployment.  Any load balancers that support traffic splitting suffice, like DNS, Nginx, Kubernetes rollout mechanisms, etc.
If any issues are found, rollback by setting all traffic to X nodes, investigate issues and repeat steps above
Decommission X nodes to complete the upgrade. Write updates to Kong can now be performed, though we suggest you keeps monitoring metrics for a while.

[image goes here]

This method is quite robust and straightforward, please do not hesitate to use it.

## Review gateway changes

We have categorized all changelog notices relevant to this migration below. This encapsulates all changes from 2.8.x.x to 3.4.x.x Kong. They are bucketed into five categories.

{% include lts-changes.html %}

### kong.conf changes

**If we're going to list new params here, this table needs _way_ more work.**

2.8 | 3.4
----------------------|-----------------------
`data_plane_config_cache_mode` = unencrypted | Removed in 3.4
`data_plane_config_cache_path` | Removed in 3.4
`admin_api_uri` | Deprecated. Use `admin_gui_api_url` instead
`database` | Accepted values are `postgres` and `off`. All Cassandra options have been removed
`pg_keepalive_timeout = 60000` | Specify the maximal idle timeout (in ms) for the Postgres connections in the pool. If this value is set to 0 then the timeout interval is unlimited. If not specified this value will be the same as `lua_socket_keepalive_timeout`.
`worker_consistency = strict` | `worker_consistency = eventual`
`prometheus_plugin_*` | Disabled Prometheus plugin high-cardinality metrics.
`lua_ssl_trusted_certificate` <br> No default value | Default value: `lua_ssl_trusted_certificate = system`
`pg_ssl_version = tlsv1` | `pg_ssl_version = tlsv1_2 `
 | `allow_debug_header = off` (new parameter)


## Perform upgrade
Perform an upgrade with the strategy choice.

## Troubleshooting

If you run into issues during the upgrade and need to roll back, select a restore method in accordance with the backup method picked.

1. Direct database operation. To restore data in this method is fast and robust. Here is a quick demonstration:

    ```sh
    pg_restore -U kong -d kong --clean kongdb_backup_20230816/
    ```

1. Kong Gateway tool. We recommend only deck. Here is a quick demonstration:

    ```sh
    deck ping
    deck validate --online -s /path/to/kong_backup.yaml
    deck sync -s /path/to/kong_backup.yaml
    ```

    Kong must be online before executing the deck commands.
