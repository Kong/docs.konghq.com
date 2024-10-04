
Any requests that don't specify a workspace target the `default` workspace.

To target a different workspace, prefix any endpoint with the workspace name or ID:

```sh
http://localhost:8001/<WORKSPACE_NAME|ID>/<ENDPOINT>
```

For example, if you don't specify a workspace,
this request retrieves a list of services from the `default` workspace:

```sh
curl -i -X GET http://localhost:8001/services
```

While this request retrieves all services from the workspace `SRE`:

```sh
curl -i -X GET http://localhost:8001/SRE/services
```