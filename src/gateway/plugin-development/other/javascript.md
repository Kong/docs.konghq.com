---
title: Plugins in Other Languages Javascript
content-type: explanation
---

{{site.base_gateway}} support for the JavaScript language is provided by the [JavaScript PDK](https://github.com/Kong/kong-js-pdk).
The library provides a plugin server that provides a runtime for JavaScript bindings for {{site.base_gateway}}.

TypeScript is also supported in the following ways:

- The PDK includes type definitions for PDK functions that allow type checking
when developing plugins in TypeScript.
- Plugins written in TypeScript can be loaded directly to {{site.base_gateway}} and transpiled.

## Install

[JavaScript PDK](https://github.com/Kong/kong-js-pdk) can be installed using `npm`. To install the plugin server binary globally:

```
npm install kong-pdk -g
```

## Development

A valid JavaScript plugin implementation should export the following object:

```javascript
module.exports = {
  Plugin: KongPlugin,
  Schema: [
    { message: { type: "string" } },
  ],
  Version: '0.1.0',
  Priority: 0,
}
```

* The `Plugin` attribute defines the class that implements this plugin.
* The `Schema` defines the configuration schema of the plugin.
* `Version` and `Priority` variables set to the version number and priority of execution.

**Note**: [This repository](https://github.com/Kong/kong-js-pdk/tree/master/examples) contains examples of plugins built with JavaScript.

## Phase handlers

You can implement custom logic to be executed at
various points in the request processing lifecycle. To execute
custom JavaScript code in the access phase, define a function named `access`:

```javascript
class KongPlugin {
  constructor(config) {
    this.config = config
  }
  async access(kong) {
    // ...
  }
}
```

You can implement custom logic during the following phases using the same function signature:

- `certificate`
- `rewrite`
- `access`
- `response`
- `preread`
- `log`

The presence of the `response` handler automatically enables the buffered proxy mode.

## PDK functions

Kong interacts with the PDK through network-based inter-rocess communication.
Each function returns a [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
instance. You can use `async`/`await` keywords in the phase handlers for better readability.

```javascript
class KongPlugin {
  constructor(config) {
    this.config = config
  }
  async access(kong) {
    let host = await kong.request.getHeader("host")
    // do something to host
  }
}
```

Alternatively, use the `then` method to resolve a promise:

```javascript
class KongPlugin {
  constructor(config) {
    this.config = config
  }
  async access(kong) {
    kong.request.getHeader("host")
      .then((host) => {
        // do something to host
      })
  }
}
```

## Plugin dependencies

When using the plugin server, plugins are allowed to have extra dependencies, as long as the
directory that holds plugin source code also includes a `node_modules` directory.

Assuming plugins are stored under `/usr/local/kong/js-plugins`, the extra dependencies are
then defined in `/usr/local/kong/js-plugins/package.json`. Developers also need to
run `npm install` under `/usr/local/kong/js-plugins` to install those dependencies locally
into `/usr/local/kong/js-plugins/node_modules`.

The Node.js version and architecture that runs the plugin server and
the one that runs `npm install` under plugins directory must match.

### Testing

The JavaScript PDK provides a mock framework to test plugin code using [`jest`](https://jestjs.io/).

Install `jest` as a development dependency, then add  the `test` script in `package.json`:

```
npm install jest --save-dev
```

The `package.json` contains information like this:

    {
      "scripts": {
        "test": "jest"
      },
      "devDependencies": {
        "jest": "^26.6.3",
        "kong-pdk": "^0.3.2"
      }
    }

Run the test through npm with:

```
npm test
```

[This repository](https://github.com/Kong/kong-js-pdk/tree/master/examples)
contains examples of writing tests with `jest`.

## More Information
* [PDK Reference](/gateway/latest/plugin-development/pdk/)
* [Plugins with Containers](/gateway/latest/plugin-development/other/plugins-kubernetes)
* [Develop plugins with Python](/gateway/latest/plugin-development/other/python)
* [Develop plugins with Go](/gateway/latest/plugin-development/other/go)