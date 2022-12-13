---
title: Backends
---

As explained in the [Overview](/docs/{{ page.version }}/documentation/overview), when Kuma (`kuma-cp`) is up and running it needs to store data somewhere. The data will include the state, the policies configured, the data plane proxy status, and so on.

Kuma supports a few different backends that we can use when running `kuma-cp`. You can configure the backend storage by setting the `KUMA_STORE_TYPE` environment variable when running the control plane.

{% tip %}
This information has been documented for clarity, but when following the [installation instructions](/install/) these settings will be automatically configured.
{% endtip %}

Following backends are available

## Memory

Kuma stores all the state in-memory. This means that restarting Kuma will delete all the data. Only recommend when playing with Kuma locally. For example:

```sh
KUMA_STORE_TYPE=memory kuma-cp run
```

This is the **default** memory store if `KUMA_STORE_TYPE` is not being specified.

## Kubernetes

Kuma stores all the state in the underlying Kubernetes cluster. Used when running in Kubernetes mode. For example:

```sh
KUMA_STORE_TYPE=kubernetes kuma-cp run
```

## Postgres

Kuma stores all the state in a PostgreSQL database. Used when running in Universal mode. You can also use a remote PostgreSQL database offered by any cloud vendor. For example:

```sh
KUMA_STORE_TYPE=postgres \
  KUMA_STORE_POSTGRES_HOST=localhost \
  KUMA_STORE_POSTGRES_PORT=5432 \
  KUMA_STORE_POSTGRES_USER=kuma-user \
  KUMA_STORE_POSTGRES_PASSWORD=kuma-password \
  KUMA_STORE_POSTGRES_DB_NAME=kuma \
  kuma-cp run
```

### Migrations

To provide easy upgrades between Kuma versions there is a migration system of Postgres DB schema.

When upgrading to new version of Kuma, run `kuma-cp migrate up` so the new schema is applied.
```sh
KUMA_STORE_TYPE=postgres \
  KUMA_STORE_POSTGRES_HOST=localhost \
  KUMA_STORE_POSTGRES_PORT=5432 \
  KUMA_STORE_POSTGRES_USER=kuma-user \
  KUMA_STORE_POSTGRES_PASSWORD=kuma-password \
  KUMA_STORE_POSTGRES_DB_NAME=kuma \
  kuma-cp migrate up
```

Kuma CP at start will check if the current DB schema is compatible with the version of Kuma you are trying to run.
Information about current newest migration is stored in `schema_migration` table.
