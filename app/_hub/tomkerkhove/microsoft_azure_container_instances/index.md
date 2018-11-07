---
name: Microsoft Azure Container Instances
publisher: Tom Kerkhove

categories:
  - deployment

type: integration

desc: Deploy Kong on Microsoft Azure Container Instances # (required) 1-liner description; max 80 chars
# (required) extended description.
  # Use YAML piple notation for extended entries.
  # EXAMPLE long text format (do not use this entry)
  # description: |
  #   Maintain an indentation of two (2) spaces after denoting a block with
  #   YAML pipe notation.
  #
  #   Lorem Ipsum is simply dummy text of the printing and typesetting
  #   industry. Lorem Ipsum has been the industry's standard dummy text ever
  #   since the 1500s.
description: |
  This guide walks you through deploying and running Kong on Microsoft Azure Container Instances.

  We will be using either Azure Database for PostgreSQL or Cosmos Db to store the gateway configuration.
support_url: https://github.com/tomkerkhove/kong-deployment-on-azure/issues
  # Defaults to the url setting in your publisher profile.

source_url: https://github.com/tomkerkhove/kong-deployment-on-azure
  # (Optional) If your extension is open source, provide a link to your code.

#license_type:
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

#license_url:
  # (Optional) Link to your custom license.

#privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

#privacy_policy_url:
  # (Optional) Link to a remote privacy policy

#terms_of_service:
  # (Optional) Text describing your terms of service.

#terms_of_service_url:
  # (Optional) Link to your online TOS.

# COMPATIBILITY
# In the following sections, list Kong versions as array items.
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be considered to have "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
        - 0.14.x
    #incompatible:
  # enterprise_edition: # optional
    # compatible:
    #incompatible:

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# If you include headers, your headers MUST start at Level 2 (parsing to
# h2 tag in HTML). Heading Level 2 is represented by ## notation
# preceding the header text. Subsequent headings,
# if you choose to use them, must be properly nested (eg. heading level 2 may
# be followed by another heading level 2, or by heading level 3, but must NOT be
# followed by heading level 4)
###############################################################################
# BEGIN MARKDOWN CONTENT
---

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
