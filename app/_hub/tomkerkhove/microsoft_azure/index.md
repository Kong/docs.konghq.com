---
name: Microsoft Azure
publisher: Tom Kerkhove

categories:
  - deployment

type: integration

desc: Deploy Kong on Microsoft Azure # (required) 1-liner description; max 80 chars
description: #|
  This guide walks you through the options to run Kong on Microsoft Azure.
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
        # - 0.34-x
        # - 0.33-x
        # - 0.32-x
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

## Deploying Kong via the Azure Marketplace
The Azure Marketplace provides quickstart templates that allow you to very easily install certain technologies.

You can deploy one of the following Kong templates from the marketplace:

1. **Kong Certified by Bitnami**

    Developer Tools software from the leading publisher

      You can find the template [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.kong).

1. **Kong Cluster**

    Kong Cluster for production environments - This solution configures a load-balanced Kong cluster with an additional Cassandra cluster for data storage.

    You can find the template [here](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.kong-cluster).

## Running Kong on Azure Container Instances

For more information, see [Running Kong on Azure Container Instances](./../microsoft_azure_container_instances).

## Storing Kong metadata in Microsoft Azure
### Running PostgreSQL on Azure with Azure Database for PostgreSQL
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

### Running Cassandra on Azure with Azure Cosmos Db
Currently, Azure Cosmos Db is not supported as a Cassandra data store.

<div class="alert alert-info">
  <div class="text-center">
    <strong>Note</strong>: See <a href="https://github.com/Kong/docker-kong/issues/188" target="blank">#188</a> for more information.
  </div>
</div>
