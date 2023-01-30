---
name: Reedelk Transformer

publisher: codecentric AG

categories:
  - transformations

type:
  plugin        

desc: Kong plugin to transform Reedelk requests and responses

description: |
  The Reedelk Transformer plugin transforms the upstream request body or
  downstream response body by invoking a Reedelk REST flow before hitting the
  upstream server, or before sending the downstream response back to the client.
  The plugin can apply both upstream and downstream transformations in the same flow.

support_url: https://github.com/codecentric/kong-plugin-reedelk-transformer/issues
  # (Optional) A specific URL of your own for this extension.
  # Defaults to the url setting in your publisher profile.

source_code: https://github.com/codecentric/kong-plugin-reedelk-transformer

license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

license_url: https://github.com/codecentric/kong-plugin-reedelk-transformer/blob/master/LICENSE.txt

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1.x
      - 2.0.x
      - 1.5.x
  enterprise_edition:
    compatible:
     - 1.5.x

###############################################################################
# END YAML DATA

###############################################################################
# BEGIN MARKDOWN CONTENT
---

## Installation

### Prerequisites

To use the Reedelk plugin for Kong, you must first install the Reedelk IntelliJ
IDEA flow designer plugin using either of the following options:

- **IntelliJ Marketplace**: Go to **IntelliJ Preferences > Plugin > Marketplace**,
  search for `Reedelk`, install the plugin, and restart IntelliJ.

- **Manual install**: From **IntelliJ Preferences > Plugin > Settings icon >
  Install Plugin From Disk**, and restart IntelliJ.

### Install the Reedelk Transformer plugin

1. Clone the `kong-plugin-reedelk-transformer`:

   ```bash
    $ git clone https://github.com/reedelk/kong-plugin-reedelk-transformer.git
    $ cd kong-plugin-reedelk-transformer
   ```

2. Install the module `kong-plugin-reedelk-transformer`:

   ```bash
   $ luarocks install kong-plugin-reedelk-transformer-0.1.0-1.all.rock
   ```

3. Add the custom plugin to `kong.conf`:

   ```
   plugins = ...,reedelk-transformer
   ```

4. [Restart](/2.1.x/cli/#kong-restart) Kong.

   ```
   $ kong restart
   ```

### Build and package the plugin

1. [Install](https://github.com/luarocks/luarocks/wiki/Download){:target="_blank"}{:rel="noopener noreferrer"} the
   [LuaRocks](http://luarocks.org){:target="_blank"}{:rel="noopener noreferrer"} package manager.

2. Clone the `kong-plugin-reedelk-transformer`:

   ```bash
    $ git clone https://github.com/reedelk/kong-plugin-reedelk-transformer.git
    $ cd kong-plugin-reedelk-transformer
   ```

3. Build the plugin locally (based on the `.rockspec` in the current directory):

   ```bash
   $ luarocks make
   ```

4. Package the plugin:

   ```bash
   $ luarocks pack kong-plugin-reedelk-transformer 0.1.0-1
   ```

### Hello World Example

This example uses a prepackaged `kong-reedelk` Docker image with Kong and the
`reedelk-transformer` plugin already installed. You can find the `kong-reedelk`
Docker images on
[Docker Hub](https://hub.docker.com/repository/docker/reedelk/kong-reedelk-transformer-plugin){:target="_blank"}{:rel="noopener noreferrer"}.

The `kong-reedelk` image is preconfigured to use the following `kong.yml` file,
which defines an upstream service mapped on Route `http://localhost:8000/transform`
and invokes a downstream transformer with the `reedelk-transformer` plugin. The
configured downstream transformer integration flow URL is:

```
http://host.docker.internal:8282/api/message
```

#### Prerequisites

- [Docker](https://www.docker.com/) must be [installed](https://www.docker.com/get-started){:target="_blank"}{:rel="noopener noreferrer"}.
- [IntelliJ IDEA IDE](https://www.jetbrains.com/idea/){:target="_blank"}{:rel="noopener noreferrer"} must be
  [installed](https://www.jetbrains.com/idea/download){:target="_blank"}{:rel="noopener noreferrer"}.
- [Reedelk IntelliJ Flow Designer Plugin](https://www.reedelk.com/documentation/intellijplugin){:target="_blank"}{:rel="noopener noreferrer"}
  must be [installed](https://www.reedelk.com/documentation/intellijplugin){:target="_blank"}{:rel="noopener noreferrer"} on
  your IntelliJ distribution.

#### Run the example

In the following steps, you run the `kong-reedelk` docker image, and then create a
new Reedelk project that contains the integration flow invoked by the
downstream transformer.

1. Run the `kong-reedelk` Docker image:

   ```
   $ docker run -d --name kong-reedelk-transformer-plugin \
            -p 8000:8000 \
            -p 8443:8443 \
            -p 127.0.0.1:8001:8001 \
            -p 127.0.0.1:8444:8444 \
            reedelk/kong-reedelk-transformer-plugin:latest
   ```

2. Make sure that Kong is up and running correctly with the `reedelk-transformer`
   plugin installed:

   ```
   $ curl http://localhost:8001/plugins
   ```

3. Open IntelliJ and create a new Reedelk project. The newly created project
   contains a `POST` Hello World flow to use as integration
   flow invoked by the downstream transformer.

4. Start the new Reedelk project by clicking **Play** next to the
   **Reedelk Runtime** run configuration in IntelliJ.

   ![Reedelk Runtime](/assets/images/docs/plugins/reedelk-runtime-start.png)

5. Call the Kong Route with the following URL:

   ```
   $ http://localhost:8000/transform
   ```

   The result should be:

   `Hello World John`

For more information about this example, including testing the IntelliJ Flow
Designer Plugin workflow with [Insomnia](https://insomnia.rest/){:target="_blank"}{:rel="noopener noreferrer"}, see:
* Reedelk [Getting Started](https://www.reedelk.com/documentation/getting-started){:target="_blank"}{:rel="noopener noreferrer"}
documentation.
* [Reedelk plugin documentation](https://github.com/reedelk/kong-plugin-reedelk-transformer#kong-reedelk-transformer-plugin-hello-world){:target="_blank"}{:rel="noopener noreferrer"}
on GitHub.
* [Kong Reedelk Transformer Plugin Demo](https://www.youtube.com/watch?v=c5Aw2XpwKos&amp;feature=youtu.be){:target="_blank"}{:rel="noopener noreferrer"}
video on Youtube.
