---
title: Linting
---

`deck file lint` is a flexible JSON/YAML linter that allows you to build rules to validate any file in these formats.

There are a few key concepts to understand for linting with decK:

*   **Rules** define selectors, functions and the failure severity to apply to the provided file.
*   **Selectors** define a filter to apply to the input file which selects the objects to validate. Selectors are specified in the given keyword on a Rule. Selectors are expressed using JSONPath syntax.
*   **Functions** accept the filtered values and perform a validation returning information when there are violations.
*   **Rulesets** are collections of Rules.

## Example

{{ site.base_gateway }} services are defined in the `services` block in the decK file. Services support a number of configuration values including a protocol field which specifies the communication protocol used between the gateway and the upstream service. To ensure this traffic is secure, you may want to validate that only `https` protocols are used. Here is a sample Ruleset file containing a single Rule that accomplishes this.

```yaml
rules:
  service-https-check:
    description: "Ensure https usage in Kong GW Services"
    given: $.services[*].protocol
    severity: error
    then:
      function: pattern
      functionOptions:
        match: "^https$"
```

The [JSONPath](http://jsonpath.com/) selector specified in `given` reads the `protocol` field in every service under the `services` key from the incoming file. With each of those values, the `pattern` function is applied which evaluates the value against a regular expression pattern specified in the `match` field. In this example, we assert that the string value in the `protocol` field must match the string `https` exactly.

Assume you have the following decK declarative configuration file (`kong.yaml`) that defines a service and a route for a simple task tracking system:

```yaml
_format_version: "3.0"
services:
  - host: tasks.example.com
    name: task-api
    path: /
    protocol: http
    routes:
    - methods:
      - GET
      name: task-api_gettasks
      paths:
      - ~/tasks$
```

Validating this configuration against the example ruleset, stored in `ruleset.yaml`, results in the following violations: 

```bash
deck file lint -s kong.yaml ruleset.yaml
```

```
Linting Violations: 1
Failures: 1

[error][7:15] Ensure https usage in Kong GW Services: `http` does not match the expression `^https$`
```

Modifying the declarative configuration as follows resolves this violation:

```yaml
_format_version: "3.0"
services:
  - host: tasks.example.com
    name: task-api
    path: /
    protocol: https
    routes:
    - methods:
      - GET
      name: task-api_gettasks
      paths:
      - ~/tasks$
```

```bash
deck file lint -s kong.yaml ruleset.yaml; echo $?
```

Result:
```
0
```

Notice that the command results in a `0` (Success) return code. In situations where violations are detected, a non-zero return code is emitted allowing you to abort automated processes and help prevent problematic configurations from leaking into your production codebase and systems.

## Common patterns

### Ensure that configuration files contain `select_tags`

[`select_tags`](/deck/gateway/tags/#select-tags) allows you to segment your configuration so that it can be managed as multiple, independent configurations.

This linting rule ensures that every configuration file has `select_tags` defined.

```yaml
rules:
  select_tags:
    description: "Select Tags should be present."
    given: $._info
    severity: error
    then:
      field: select_tags
      function: defined
  select_tags_length:
    description: "Select Tags should be present."
    given: $._info
    severity: error
    then:
      field: select_tags
      function: schema
      functionOptions:
        schema:
          type: "array"
          minItems: 1
          items:
            type: "string"
```

### Enforce HTTPS only on routes

To force {{ site.base_gateway }} to listen on HTTPs only, ensure that `protocols` is set on every route and it contains a single `https` entry:

```yaml
rules:
  protocols_set:
    description: "Ensure route protocols are set"
    given: $.routes[*]
    severity: error
    then:
      field: protocols
      function: "schema"
      functionOptions:
        schema:
          type: "array"
          minItems: 1
          maxItems: 1
          items:
            type: "string"
  protocols_https_only:
    description: "Ensure https usage in Kong GW Routes"
    given: $.routes[*].protocols[0]
    severity: error
    then:
      function: pattern
      functionOptions:
        match: "^https$"

```