# Ruby Debug

When working on plugins, it's useful to have access to a debugger to inspect the current state and see what data is available.

Instructions are provided for `vscode` users below.

## Environment Configuration

Install the [VSCode rdbg Ruby Debugger](https://marketplace.visualstudio.com/items?itemName=KoichiSasada.vscode-rdbg) plugin.

Install the `debug` gem globally (_not_ through Bundler):

```bash
gem install debug
```

Ensure that you have a `jekyll` binary at `bin/jekyll` in the docs repo. If not, run `bundle binstubs jekyll`.

Create a launch configuration at `.vscode/launch.json` in the docs repo at the same level as `README.md` with the following value:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "rdbg",
      "rdbgPath": "XDG_RUNTIME_DIR=/tmp rdbg",
      "name": "Debug Jekyll",
      "request": "launch",
      "script": "bin/jekyll build --config jekyll.yml",
      "args": [],
      "askParameters": false
    }
  ]
}
```

> The `XDG_RUNTIME_DIR` value is required to prevent a "too long unix socket path" error

Your environment is now configured to debug Jekyll.

## Starting a debug session

When in `vscode`, click in the gutter next to the line numbers and a red circle will appear. This is a breakpoint.

Press `F5`, or run `Debug: Start Debugging` from the command palette to start a debugging session.

Variables that are currently in scope will show in the `Variables` pane, and you can use the `Debug Console` to evaluate arbitrary expressions as required.
