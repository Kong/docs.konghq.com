---
id: page-install-method
title: Install - Microsoft Azure
header_title: Microsoft Azure
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

## Table of Contents

<!-- FIXME the list below should be an unordered list, but currently those do not render correctly in this section of the Docs site - depends on https://github.com/Kong/docs.konghq.com/issues/917 -->
1. [Running Kong on Azure Container Instances](#running-kong-on-azure-container-instances)
1. [Deploying Kong via the Azure Marketplace](#deploying-kong-via-the-azure-marketplace)
1. [Running PostgreSQL on Azure with Azure Database for PostgreSQL](#running-postgresql-on-azure-with-azure-database-for-postgresql)
1. [Running Cassandra on Azure with Azure Cosmos Db](#running-cassandra-on-azure-with-azure-cosmos-db)

## Running Kong on Azure Container Instances
<a href="https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview" target="blank">Azure Container Instances</a> is a great way to run lightweight containers in a serverless fashion.

Running Kong on Azure Container Instances is super easy:

1. **Provision a data store**

    Provision the data store that you want to use:
    1. [Running Cassandra on Azure with Azure Cosmos Db](#running-cassandra-on-azure-with-azure-cosmos-db)
    1. [Running PostgreSQL on Azure with Azure Database for PostgreSQL](#running-postgresql-on-azure-with-azure-database-for-postgresql)

1. **Open the Cloud Shell or Azure CLI**

1. **Run the migrations**

    ```bash
    $ az container create --name kong-migrations \
                          --resource-group kong-sandbox \
                          --image kong:latest \
                          --restart-policy Never \
                          --environment-variables KONG_PG_HOST="<instance-name>.postgres.database.azure.com" \
                                                  KONG_PG_USER="<username>" \
                                                  KONG_PG_PASSWORD="<password>" \
                          --command-line "kong migrations up"
    ```
    In this example, we are using a PostgreSQL database running on [Azure Database for PostgreSQL](#running-postgresql-on-azure-with-azure-database-for-postgresql).

1. **Start Kong**

    ```bash
    $ az container create --name kong-gateway /
                          --dns-name-label kong-gateway /
                          --resource-group kong-sandbox /
                          --image kong:latest /
                          --port 8000 8443 8001 8444 /
                          --environment-variables KONG_PG_HOST="<instance-name>.postgres.database.azure.com" /
                                                  KONG_PG_USER="<username>" /
                                                  KONG_PG_PASSWORD="<password>" /
                                                  KONG_PROXY_ACCESS_LOG="/dev/stdout" /
                                                  KONG_ADMIN_ACCESS_LOG="/dev/stdout" /
                                                  KONG_PROXY_ERROR_LOG="/dev/stderr" /
                                                  KONG_ADMIN_ERROR_LOG="/dev/stderr" /
                                                  KONG_ADMIN_LISTEN="0.0.0.0:8001, 0.0.0.0:8444 ssl"
    ```

    The `8000`, `8001`, `8443`, and `8444` will be forwarded to the container.

    <div class="alert alert-warning">
      <div class="text-center">
        <strong>Note</strong>: This will expose both the proxy and the Admin API on the default ports. This can have security implications.
      </div>
    </div>

1. **Use Kong**

    That's it - You can now use Kong by browsing to `<dns-label>.westeurope.azurecontainer.io`.

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).

## Deploying Kong via the Azure Marketplace
The Azure Marketplace provides quickstart templates that allow you to very easily install certain technologies.

You can deploy one of the following Kong templates from the marketplace:

1. **Kong Certified by Bitnami**

    Developer Tools software from the leading publisher

    *You can find the template [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.kong).*

1. **Kong Cluster**

    Kong Cluster for production environments - This solution configures a load-balanced Kong cluster with an additional Cassandra cluster for data storage.

    *You can find the template [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.kong-cluster).*

## Running PostgreSQL on Azure with Azure Database for PostgreSQL
Azure Database for PostgreSQL is a great way to use a managed PostgreSQL in the Azure Cloud.

Here are the simple steps to provision one:

1. Go to the <a href="https://portal.azure.com" target="blank">Azure Portal</a>
1. Create a new "Azure Database for PostgreSQL" instance
1. Go to "Connection Security" and enable access to Azure services
1. Create a new database called "kong" by using your favorite tool

<div class="alert alert-warning">
  <div class="text-center">
    <strong>Note</strong>: Before connecting to your new database, make sure your IP address is whitelisted in "Connection Security"
  </div>
</div>

## Running Cassandra on Azure with Azure Cosmos Db
Currently, Azure Cosmos Db is not supported as a Cassandra data store.

<div class="alert alert-info">
  <div class="text-center">
    <strong>Note</strong>: See <a href="https://github.com/Kong/docker-kong/issues/188" target="blank">#188</a> for more information.
  </div>
</div>
