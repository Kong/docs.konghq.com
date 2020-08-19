---
title: Breaking Changes for Custom Entities and Plugins
toc: true
---

Custom entities and plugins have breaking changes for 2.1.x:
  - The `run_on` parameter was removed. Delete the field from your
    plugin schema.

  - `select_all` has been removed. The recommended fix path is to
    iterate all entities using `:each` and filter entities in
    lua. This works well for low cardinality (less than 5k
    entities). For higher cardinality entities, the recommendation is
    to write the queries in custom dao code. Also, your use cases
    might be a good fit for `select_for` or `each_for`, that will work
    using database indices. Those methods are able to filter by a
    foreign key relation.

  - Workspaceable entities and plugin entities need a migration. Kong
    2.1.x will not start if it finds an entity that is marked as
    workspaceable but doesn't comply with the latest data format
    needed. In that case, a list of the tables that should be migrated
    will be printed.

    Kong 2.1.x provides a migration helper command `kong migrations
    upgrad-workspace-table [table-name]` that will print a temptative
    migration file for that entity. This feature is best effort, so it
    should be tested in non-production environments with backup data.

    The migration snipped should be added as a new migration for the
    entity like any other migration.


    A workspaceable entity in 2.1.x+ using Postgres has to:
    - have a `ws_id` field of type UUID
    - the `ws_id` field is a foreign key to `workspaces.id`
    - unique fields don't have the `<workspace_name>:` prefix
          anymore so it should be removed.

    A workspaceable entity in 2.1.x+ using Cassandra has to:
    - have a `ws_id` field of type UUID
    - unique fields have the `<workspace_id>:` prefix
        instead of `<workspace_name:>`.
