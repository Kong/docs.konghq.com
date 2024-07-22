---
title: Installation and Distribution
book: plugin_dev
chapter: 11
---

Custom plugins for Kong consist of Lua source files that need to be in the file
system of each of your Kong nodes. This guide will provide you with
step-by-step instructions that will make a Kong node aware of your custom
plugin(s).

These steps should be applied to each node in your Kong cluster, to ensure the
custom plugin(s) are available on each one of them.

## Packaging sources

You can either use a regular packing strategy (e.g. `tar`), or use the LuaRocks
package manager to do it for you. We recommend LuaRocks as it is installed
along with Kong when using one of the official distribution packages.

When using LuaRocks, you must create a `rockspec` file, which specifies the
package contents. For an example, see the [Kong plugin
template][plugin-template]. For more info about the format, see the LuaRocks
[documentation on rockspecs][rockspec].

Pack your rock using the following command (from the plugin repo):

1. Install it locally (based on the `.rockspec` in the current directory):
    ```sh
    luarocks make
    ```

2. Pack the installed rock:

   {:.important}
   > **Important:** `luarocks pack` is dependent on the `zip` utility being installed. More recent images of {{site.base_gateway}} have been hardened, and utilities such as `zip` are no longer available. If this is being performed as part of a custom Docker image, ensure `zip` is installed prior to running this command.


    ```sh
    luarocks pack <plugin-name> <version>
    ```
    Assuming your plugin rockspec is called
    `kong-plugin-my-plugin-0.1.0-1.rockspec`, the above would become;

    ```sh
    luarocks pack kong-plugin-my-plugin 0.1.0-1
    ```

The LuaRocks `pack` command has now created a `.rock` file (this is simply a
zip file containing everything needed to install the rock).

If you do not or cannot use LuaRocks, then use `tar` to pack the
`.lua` files of which your plugin consists into a `.tar.gz` archive. You can
also include the `.rockspec` file if you do have LuaRocks on the target
systems.

The contents of this archive should be close to the following:

```
tree <plugin-name>
<plugin-name>
├── INSTALL.txt
├── README.md
├── kong
│   └── plugins
│       └── <plugin-name>
│           ├── handler.lua
│           └── schema.lua
└── <plugin-name>-<version>.rockspec
```

## Install the plugin

For a Kong node to be able to use the custom plugin, the custom plugin's Lua
sources must be installed on your host's file system. There are multiple ways
of doing so: via LuaRocks, or manually. Choose one of the following paths.

Reminder: regardless of which method you are using to install your plugin's
sources, you must still do so for each node in your Kong cluster.

### Via LuaRocks from the created 'rock'

The `.rock` file is a self contained package that can be installed locally
or from a remote server.

If the `luarocks` utility is installed in your system (this is likely the
case if you used one of the official installation packages), you can
install the 'rock' in your LuaRocks tree (a directory in which LuaRocks
installs Lua modules).

It can be installed by doing:
```sh
luarocks install <rock-filename>
```

The filename can be a local name, or any of the supported methods, e.g.
`http://myrepository.lan/rocks/my-plugin-0.1.0-1.all.rock`

### Via LuaRocks from the source archive

If the `luarocks` utility is installed in your system (this is likely the
case if you used one of the official installation packages), you can
install the Lua sources in your LuaRocks tree (a directory in which
LuaRocks installs Lua modules).

You can do so by changing the current directory to the extracted archive,
where the rockspec file is:

```sh
cd <plugin-name>
```

And then run the following:

```sh
luarocks make
```

This will install the Lua sources in `kong/plugins/<plugin-name>` in your
system's LuaRocks tree, where all the Kong sources are already present.

### Via a Dockerfile or docker run (install and load)

If you are running {{site.base_gateway}} on Docker or Kubernetes, 
the plugin needs to be installed inside the {{site.base_gateway}} container. 
Copy or mount the plugin’s source code into the container.

{:.note}
> **Note:** Official {{site.base_gateway}} images are configured to run 
as the `nobody` user.
When building a custom image, to copy files into the {{site.base_gateway}} image, 
you must temporarily set the user to `root`.

Here's an example Dockerfile that shows how to mount your plugin in 
the {{site.base_gateway}} image:

```dockerfile
FROM kong/kong-gateway:latest

# Ensure any patching steps are executed as root user
USER root

# Add custom plugin to the image
COPY example-plugin/kong/plugins/example-plugin /usr/local/share/lua/5.1/kong/plugins/example-plugin
ENV KONG_PLUGINS=bundled,example-plugin

# Ensure kong user is selected for image execution
USER kong

# Run kong
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
``` 

Or, include the following in your `docker run` command:

```
-v "$custom_plugin_folder:/tmp/custom_plugins/kong" 
-e "KONG_LUA_PACKAGE_PATH=/tmp/custom_plugins/?.lua;;"
-e "KONG_PLUGINS=bundled,example-plugin"
```

### Manually

A more conservative way of installing your plugin's sources is
to avoid "polluting" the LuaRocks tree, and instead, point Kong
to the directory containing them.

This is done by tweaking the `lua_package_path` property of your Kong
configuration. Under the hood, this property is an alias to the `LUA_PATH`
variable of the Lua VM, if you are familiar with it.

Those properties contain a semicolon-separated list of directories in
which to search for Lua sources. It should be set like so in your Kong
configuration file:

```
lua_package_path = /<path-to-plugin-location>/?.lua;;
```

Where:

* `/<path-to-plugin-location>` is the path to the directory containing the
  extracted archive. It should be the location of the `kong` directory
  from the archive.
* `?` is a placeholder that will be replaced by
  `kong.plugins.<plugin-name>` when Kong will try to load your plugin. Do
  not change it.
* `;;` a placeholder for the "the default Lua path". Do not change it.

For example, if the plugin `something` is located on the file system and the
handler file is in the following directory:

```
/usr/local/custom/kong/plugins/<something>/handler.lua
```

The location of the `kong` directory is `/usr/local/custom`, so the
proper path setup would be:

```
lua_package_path = /usr/local/custom/?.lua;;
```

#### Multiple plugins

If you want to install two or more custom plugins this way, you can set
the variable to something like:

```
lua_package_path = /path/to/plugin1/?.lua;/path/to/plugin2/?.lua;;
```

* `;` is the separator between directories.
* `;;` still means "the default Lua path".

You can also set this property via its environment variable
equivalent: `KONG_LUA_PACKAGE_PATH`.


## Load the plugin

1. Add the custom plugin's name to the `plugins` list in your
Kong configuration (on each Kong node):

    ```
    plugins = bundled,<plugin-name>
    ```

    Or, if you don't want to include the bundled plugins:

    ```
    plugins = <plugin-name>
    ```

    If you are using two or more custom plugins, insert commas in between, like so:

    ```
    plugins = bundled,plugin1,plugin2
    ```
    Or:
    ```
    plugins = plugin1,plugin2
    ```

    You can also set this property via its environment variable equivalent:
    `KONG_PLUGINS`.

1. Update the `plugins` directive for each node in your Kong cluster.

1. Restart Kong to apply the plugin:

    ```
    kong restart
    ```
    Or, if you want to apply a plugin without stopping Kong, you can use this:

    ```
    kong prepare
    kong reload
    ```

## Verify loading the plugin

You should now be able to start Kong without any issue. Consult your custom
plugin's instructions on how to enable/configure your plugin
on a Service, Route, or Consumer entity.

1. To make sure your plugin is being loaded by Kong, you can start Kong with a
`debug` log level:

    ```
    log_level = debug
    ```
    or:
    ```
    KONG_LOG_LEVEL=debug
    ```
2. Then, you should see the following log for each plugin being loaded:

    ```
    [debug] Loading plugin <plugin-name>
    ```

## Remove a plugin

There are three steps to completely remove a plugin.

1. Remove the plugin from your Kong Service or Route configuration. Make sure
   that it is no longer applied globally nor for any Service, Route, or
   consumer. This has to be done only once for the entire Kong cluster, no
   restart/reload required.  This step in itself will make that the plugin is
   no longer in use. But it remains available and it is still possible to
   re-apply the plugin.

2. Remove the plugin from the `plugins` directive (on each Kong node).
   Make sure to have completed step 1 before doing so. After this step
   it will be impossible for anyone to re-apply the plugin to any Kong
   Service, Route, Consumer, or even globally. This step requires to
   restart/reload the Kong node to take effect.

3. To remove the plugin thoroughly, delete the plugin-related files from
   each of the Kong nodes. Make sure to have completed step 2, including
   restarting/reloading Kong, before deleting the files. If you used LuaRocks
   to install the plugin, you can do `luarocks remove <plugin-name>` to remove
   it.



## Distribute your plugin

Depending on the platform that Gateway is running on, there are different ways of 
distributing custom plugins.

### LuaRocks

One way to do so is to use [LuaRocks](https://luarocks.org/), a
package manager for Lua modules. It calls such modules "rocks". **Your module
does not have to live inside the Kong repository**, but it can be if that's
how you'd like to maintain your Kong setup.

By defining your modules (and their eventual dependencies) in a [rockspec]
file, you can install those modules on your platform via LuaRocks. You can
also upload your module on LuaRocks and make it available to everyone!

Here is an [example rockspec][example-rockspec] using the `builtin`
build type to define modules in Lua notation and their corresponding file.

For more information about the format, see the LuaRocks
[documentation on rockspecs][rockspec].

### OCI Artifacts

Many users will have access to an OCI-compliant registry like Docker Hub or Amazon ECR.
Kong Plugins can be packaged as generic OCI artifacts and uploaded to one of these 
registries for versioning, storage, and distribution. 

The advantage of distributing plugins as OCI artifacts is that users can make use of 
a number of ecosystem benefits including tooling around building, pushing and pulling, and 
signing (for secure provenance attestation) of these artifacts. The steps below 
illustrate a sample flow for packaging, distributing, and verifying a Kong custom plugin 
as an OCI artifact.

On the machine where the plugin is developed, or as part of an automated workflow, run the following 
steps:

1. Package the plugin according to the [Packaging Sources](#packaging-sources) section above.

    ```bash
    tar czf my-plugin.tar.gz ./my-plugin-dir
    ```

2. Use the OSS [Cosign tool][cosign-install] to generate a key pair for use signing and verifying plugins:

    ```bash
    cosign generate-key-pair
    ```

    The private key (`cosign.key`) should be kept secure and is used for signing the plugin artifact. The public key
    (`cosign.pub`) should be distributed and used by target machines to validate the downloaded plugin later in the flow. 

    There are also key-less methods for signing and verifying artifacts with Cosign. More information 
    is available in their [documentation][cosign-signing].

3. Login to your OCI-compliant registry. In this case we'll use Docker Hub:

    ```bash
    cat ~/foo_password.txt | docker login --username foo-user --password-stdin
    ```

4. Upload the plugin artifact to the OCI registry using Cosign. This is the equivalent of running 
`docker push <image>` when pushing a local Docker image up to a registry.

    ```bash
    cosign upload blob -f my-plugin.tar.gz docker.io/foo-user/my-plugin
    ```

    The `cosign upload` command will return the digest of the artifact if it's successfully uploaded.

5. Sign the artifact with the key pair generated in step 1:

    ```bash
    cosign sign --key cosign.key index.docker.io/foo-user/my-plugin@sha256:xxxxxxxxxx
    ```

    The command may prompt for the private key passphrase. It also may prompt to confirm that you consent 
    to the signing information being permanently recorded in Rekor, the transparency log. For more information 
    on Sigstore tooling and flows visit the [documentation][rekor-docs].

Then, on the machines where the plugin should be installed (the Gateway data plane nodes), run the following 
steps (which can also be automated):

6. Ensure the `cosign.pub` public key is available. Verify the signature of the plugin artifact that you want to
pull:

    ```bash
    cosign verify --key cosign.pub index.docker.io/foo-user/my-plugin@sha256:xxxxxxxxxx
    ```

    The command should succeed if the artifact was verified.

7. Use the OSS [Crane][crane] tool to pull the plugin artifact to the machine:

    ```bash
    crane pull index.docker.io/foo-user/my-plugin@sha256:xxxxxxxxxx my-downloaded-plugin.tar.gz
    ```

    The command should pull the artifact and save it to the working directory.

8. Unpackage the plugin. The download `.tar.gz` file will container a manifest file and 
another nested `.tar.gz`. This nested archive contains the plugin directory.

    ```bash
    tar xvf my-downloaded-plugin.tar.gz
    tar xvf xxxxxxxxxxxxxxxxxxxxx.tar.gz
    ```

9. Copy the plugin directory to the correct location according to the [install manually](#manually) section above. If you have not set a custom `KONG_LUA_PACKAGE_PATH`, copy the plugin in to `/usr/local/share/lua/5.1/kong/plugins`.

10. Update Kong's configuration to load the custom plugin by configuring `plugins=bundled,my-downloaded-plugin` in `kong.conf` or set the `KONG_PLUGINS` environment variable to `plugins=bundled,my-downloaded-plugin`

## Troubleshooting

Kong can fail to start because of a misconfigured custom plugin for several
reasons:

`plugin is in use but not enabled`
: You configured a custom plugin from
  another node, and that the plugin configuration is in the database, but the
  current node you are trying to start does not have it in its `plugins`
  directive. To resolve, add the plugin's name to the node's `plugins`
  directive.

`plugin is enabled but not installed`
: The plugin's name is present in the `plugins` directive, but Kong can't load
the `handler.lua` source file from the file system. To resolve, make sure that
the [`lua_package_path`](/gateway/{{page.release}}/reference/configuration/#development-miscellaneous-section)
directive is properly set to load this plugin's Lua sources.

`no configuration schema found for plugin`
: The plugin is installed and enabled in the `plugins` directive, but Kong is
unable to load the `schema.lua` source file from the file system. To resolve,
make sure that the `schema.lua` file is present alongside the plugin's
`handler.lua` file.

[rockspec]: https://github.com/keplerproject/luarocks/wiki/Creating-a-rock
[plugin-template]: https://github.com/Kong/kong-plugin
[example-rockspec]: https://github.com/Kong/kong-plugin/blob/master/kong-plugin-myplugin-0.1.0-1.rockspec
[cosign-install]: https://docs.sigstore.dev/system_config/installation/
[cosign-signing]: https://docs.sigstore.dev/signing/overview/
[rekor-docs]: https://docs.sigstore.dev/logging/overview/
[crane]: https://github.com/google/go-containerregistry/tree/main/cmd/crane
