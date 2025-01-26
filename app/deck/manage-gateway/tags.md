---
title: Tags
---

decK can operate on a subset of configuration instead of managing a complete {{ site.base_gateway }} configuration. To do this, decK tags each entity with a value, and ignores any resources that do not have that tag when running `deck gateway dump` or `deck gateway sync` in the future.

Common use cases for splitting your configuration across multiple files include:

* Managing Consumers separately to your service, route and plugin configuration
* Allowing each service owner to manage their own configuration
* Splitting large configuration files to reduce the time it takes to run `deck gateway sync`

When multiple tags are specified in decK, decK ANDs those tags together, meaning only entities containing all the tags will be managed by decK. You can specify a combination of up to 5 tags, but it is recommended to use fewer or only one tag for performance reasons.

## Select Tags

To specify a tag to manage, you can use the `--select-tag` command line flag. This flag may be provided multiple times to specify multiple tags:

```bash
deck gateway dump --select-tag foo-tag --select-tag bar-tag -o kong.yaml
```

This will dump all resources that have the `foo-tag` tag **and** the `bar-tag` tag.

Make some changes to this file, then push them to {{ site.base_gateway }} using:

```bash
deck gateway diff kong.yaml

# Then if the changes are expected, apply the changes
deck gateway sync kong.yaml
```

Notice how the `--select-tag` flags are not required for `deck gateway diff/sync`. This is because `deck gateway dump` added an `_info` section to the declarative configuration file that will automatically add the tags to the sync request.

```yaml
_info:
 select_tags:
 - foo-tag
 - bar-tag
```

The `--select-tag` flag _can_ be used with `deck gateway sync` for situations where the state file does not contain the above information. It is strongly advised that you do not supply select-tags to `sync` and `diff` commands via flags.

## Default Select Tags

decK allows you to specify entity relationships using foreign keys. For example, look at the following files that manage Consumers and Consumer Groups:

```yaml
# consumers.yaml
_format_version: "3.0"
_info:
 select_tags:
 - billing-consumers
consumers:
  - username: alice
    groups:
      - name: finance
    keyauth_credentials:
      - key: hello_world
```

```yaml
# consumer-groups.yaml
_format_version: "3.0"
_info:
 select_tags:
 - billing-groups
consumer_groups:
  - name: finance
    plugins:
      - name: rate-limiting
        config:
          minute: 5
          limit_by: consumer
          policy: local
```

The `consumer-groups.yaml` file syncs as expected as it does not contain any foreign key references. However, you will get an error when syncing `consumers.yaml` as the `finance` consumer group will not be available.

```bash
$ deck gateway sync consumers.yaml
Error: building state: consumer-group 'finance' not found for consumer '093645f9-e189-47ba-bc9e-f4e9b09325eb'
```

You have two options to resolve this issue:

1. Ensure that all resources use the same `select_tags`
1. Use `default_lookup_tags` to load additional resources _without_ including them in your state file.

Update `consumers.yaml` now to specify `default_lookup_tags.consumer_groups`:

```yaml
# consumers.yaml
_format_version: "3.0"
_info:
 select_tags:
 - billing-consumers
 default_lookup_tags:
  consumer_groups:
    - billing-groups
consumers:
  - username: alice
    groups:
      - name: finance
    keyauth_credentials:
      - key: hello_world
```

This loads all `consumer_groups` with the tag `billing-groups` in to memory and decK can successfully resolve the foreign keys used in `consumers.yaml`.

Default lookup tags can be used on services, routes, consumers and consumer groups.