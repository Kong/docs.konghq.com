---
title: Upgrades and Migrations
---

# Upgrades and Migrations
## Upgrades of Kong Enterprise Edition (EE)

An upgrade (or update) is the process of changing the version of the software currently deployed to a more recent one, there is no difference with concept of update. We suggest following the below steps to perform an effective upgrade; notice, however, that this approach will require downtime, in case you need high availability review the Blue/Green Deployment section below.

1. Download the version of Kong you are interested in upgrading to.
2. Make a backup copy of the production database.
3. Review the [changelog](https://docs.konghq.com/enterprise/changelog/) for the version you are upgrading to.
4. Prepare the preproduction environment with the copy of the database taken from production.
5. Install the newer package in preproduction.
6. Apply any breaking changes to your preproduction environment.
7. Run the command `kong migrations up`.
8. Start Kong and validate the upgrade in preproduction.
9. Schedule the maintenance window for the upgrade in production.
10. Backup your production database in case of rollback.
11. Install the package downloaded at step 1.
12. Adapt your infrastructure, kong configuration file and eventual custom nginx template according with your previous experience in preproduction.
13. Run the `kong migrations up` command and start Kong.

Once a new version is available, you will be advised by a distribution list email or via your designated Customer Success Engineer (Premium subscription only). The newer version will be available in the same repository in Bintray.

Although you may already have backup processes in place, a most recent backup of your database prior upgrade is needed due the fact that will represent the most recent versions of your entities and other metrics which need to be preserved while upgrading. After such backup any changes applied via the Admin API wont appear in the destination environment, therefore we suggest not making any modifications on the Admin API during the upgrade process.
 For database backups you can use specific tools for each database such as `pg_dump` for Postgres or `nodetool snapshot` for Cassandra, however we recommend to always refer to an experienced DBA.

Once you got the package you will need to review the change log to understand whether anything in your infrastructure needs to be upgraded consequentially, particular attention must be made around the supported database versions which may fall into a “no more supported state” due addition which Kong developers leverage to make queries and operation more efficient in the DAO and database level.
Installing the newer package will update core libraries, plugins and you will have an updated `kong.conf.default` which you can review to take in account newer or changes to configuration properties, those are normally documented in the changelog as well.
Following the changelog itself is important to review any breaking changes and adapt your deployment process, kong configurations files, custom nginx template and anything else may be affected.

**When performing upgrades in a solution with multiple kong nodes running, always shut down the other nodes and perform the upgrade operation one node at the time.**

Running the `kong migrations up` command will update the existing schema to the newer version, old kong packages running on updated database schemas are not guaranteed to work correctly.
At this stage, you want to validate the upgrade and smoke test your preproduction environment.
One smart way of doing so is verifying the behaviour with the application of the canary plugin on a low priority api/service entity in preproduction redirecting it to correspondent entity in the upgraded production (if you setup allows doing so) and you may want to add also request termination plugin in the source environment, or doing so entirely with a reverse-proxy hard redirect for specifics low priority routes, if you have any in your infrastructure, nevertheless using the old school postman or curl commands.
Once preproduction is validated you can go ahead and perform the same upgrade in production according to with your experience in preproduction following your business processes.

## Notes for rollbacks
Although Kong provides a `kong migrations down` command we suggest to rollback using a copy of the database taken before the upgrade (step 10), uninstalling the latest package version and reinstalling the previous version connected to the database with the old schema pre-upgrade.

## Notes for Migrations to different infrastructure
Indeed Kong is platform agnostic, however, there are other elements of the solutions that may differ between platform, specific examples can be Identity Providers, DNS servers etc.
When migrating to different infrastructure or Cloud Provider always keep the same version and upgrade only after being comfortable with the new elements of the infrastructure.
Always consider that kong configuration values that work well despite being left to default or omitted in the source infrastructure may be explicit and tweaked in the destination infrastructure.

## Blue/Green Deployments
When no downtime and high availability is required during upgrades and migrations we recommend to follow the Blue/Green deployment technique.
With Blue/Green deployments a new copy of the application (Green) is deployed alongside the existing one (Blue). The load balancer, reverse proxy or ingress is then updated to accomplish the switch over to the Green deployment after validation. Once no more requests are being processed by the Blue deployment such can be dismissed, left for rollback or as QA environment until the next upgrade where the switchover will be performed the other way around using the old Blue deployment as a newer destination.
Although this technique is recognised by the industry as highly efficient, there are some specific notes that must be considered when applied to Kong API Gateway.
In some Kong configurations there is data being sent continuously to the database, those are manly rate-limiting counters (when cluster strategy is used) and Vitals metrics, keep in consideration that after the database duplication for the Green deployment you will not have updated counters for the specific rate-limiting window in which the switch-over is performed and Vitals metrics collected during this time gap won't be available. For additional information about this technique, we suggest digging deeper into common Continuous Delivery processes and resources.

## Kubernetes and containerisation specifics
Container orchestrators provide that additional level of abstraction and a real stateless deployment you can leverage in order to transition to a newer deployment.
Whether you are using the Kubernetes ingress controller provided by Kong or your own, you will need to leverage an additional Deployment resource to generate the Green deployment.
