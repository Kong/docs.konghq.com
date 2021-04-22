---
title: Generating Kong Declarative Config with Kong Studio
---

Traditionally, Kong Gateway has always required a database, either PostgreSQL or Cassandra, to store entities such as Routes, Services, and Plugins during runtime. The database settings are typically stored in a configuration file called `kong.conf`.

Kong Gateway 1.1 added the ability to run the Gateway without a database. This ability is called *DB-less mode*. Since not having a database would preclude using the Admin API to create entities, the entities must be declared in another configuration file (YAML or JSON). This file is known as the *declarative configuration*, or *declarative config* for short.

DB-less mode and declarative configuration bring a number of benefits over using a database:

* Reduced lookup latency: all data is local to the cluster’s node.
* Reduced dependencies: only the Kong Gateway nodes and configuration are required.
* Single source of truth: entities are stored in a single file which can be source-controlled.
* New deployment models: Kong Gateway can now easily serve as a lightweight node.

![Declarative config](https://s3.amazonaws.com/helpscout.net/docs/assets/59e383122c7d3a40f0ed78e2/images/5ea7f7292c7d3a7e9aebbe3f/file-jTMVWOdyOR.gif)

Now that you’re familiar with the value that DB-less mode and declarative configuration can provide, let’s walk through how Kong Studio's Insomnia Designer can help you go from an OpenAPI spec to Kong Declarative Configuration.

## Prerequisites

* [Insomnia Designer and the Insomnia Designer Kong Plugin Bundle](/enterprise/{{page.kong_version}}/studio/download-install) are installed

## Step 1: Create or import a spec into Insomnia Designer

1. Copy the spec you’d like to convert to declarative config to your clipboard. If you don’t have a spec on hand, you can test it out using the [Petstore specification](https://raw.githubusercontent.com/OAI/OpenAPI-Specification/master/examples/v3.0/petstore.yaml).

1. Navigate to the Documents Listing View and click **Create**, then select **Blank Document** from the dropdown.

    ![Declarative config](https://s3.amazonaws.com/helpscout.net/docs/assets/59e383122c7d3a40f0ed78e2/images/5ea7f7b22c7d3a7e9aebbe48/file-w8220SsiUi.png)

1. Name the document and click **Create**.
1. Inside the Editor field, paste the specification you copied in Step 1. You should now see the specification in the Editor.

## Step 2: Generate a config

Now that you’ve added a specification to Insomnia Designer, you can generate a Kong Declarative Configuration.

1. In the upper right-hand corner of the editor, click **Generate Config**.

2. A modal window appears displaying the generated configuration as YAML. At the bottom of the modal, click the button to **Copy to Clipboard**.

![Generate config](https://s3.amazonaws.com/helpscout.net/docs/assets/59e383122c7d3a40f0ed78e2/images/5ea7f8e82c7d3a7e9aebbe60/file-wQRSDB15e3.png)
