---
title: Generating Kong Declarative Config with Kong Studio
---

![Declarative config](https://doc-assets.konghq.com/studio/1.2/declarative-config.gif)

Traditionally, Kong Gateway has always required a database, either PostgreSQL or Cassandra, to store entities such as Routes, Services, and Plugins during run time. The database settings are typically stored in a configuration file called kong.conf.

Kong Gateway 1.1 added the ability to run the Gateway without a database. This ability is called *DB-less mode*. Since not having a database would preclude using the Admin API to create entities, the entities must be declared in another configuration file (YAML or JSON). This file is known as the *declarative configuration*, or *declarative config* for short.

DB-less mode and declarative configuration bring a number of benefits over using a database:

* Reduced lookup latency: all data is local to the cluster’s node.
* Reduced dependencies: only the Kong Gateway nodes and configuration are required.
* Single Source of Truth: entities are stored in a single file, that can be source controlled.
* New deployment models: Kong Gateway can now easily serve as a lightweight node.

Now that you’re familiar with the value that DB-less mode and declarative configuration can provide, let’s walk through how Kong Studio can help you go from an OpenAPI spec to Kong Declarative Configuration.

## Step 1: Create or Import your specification into Kong Studio

Start by importing or starting a new specification in Kong Studio. Copy the specification you’d like to convert to declarative config to your clipboard. If you don’t have a specification on hand, you can test it out using the [Petstore specification](https://raw.githubusercontent.com/OAI/OpenAPI-Specification/master/examples/v3.0/petstore.yaml).

1. Click on the **Workspace Dropdown** menu and select **Create Workspace**

    ![Declarative config](https://doc-assets.konghq.com/studio/1.2/ws-dropdown.png)

1. Name the Workspace and click **Create**

    ![Create workspace](https://doc-assets.konghq.com/studio/1.2/ws-dropdown.png)

1. Inside the Editor field, paste the specification you copied in Step 1. You should now see the specification in the Editor.

## Step 2: Click “Generate Config” in upper right hand corner

Now that you’ve added your specification to Kong Studio, let’s generate your Kong Declarative Configuration. Once you click **Generate Config**, a modal window appears displaying the generated configuration as YAML, along with a button to copy the configuration to your clipboard.

![Generate config](https://doc-assets.konghq.com/studio/1.2/gen-conf.png)

*On Error:* Configuration generation can occasionally fail. If any errors occur during the generation process, a modal window displays the errors encountered.

![Config error](https://doc-assets.konghq.com/studio/1.2/error-conf.png)
