---
title: How to Configure Data Plane Resilience
badge: enterprise
content_type: how-to
toc: false
---

Starting in version 3.2, {{site.base_gateway}} can be configured to support configuring new data planes in the event of a control plane outage. This feature works by designating a backup node and allowing it read/write access to a data store. This backup node will automatically push valid {{site.base_gateway}} configurations to the data store. In the event of a control plane outage when a new node is created, it will pull the latest {{site.base_gateway}} configuration from the data store, configure itself, and start proxying requests. 

This option is only recommended for customers who have to adhere to strict availability SLAs, because it requires a larger maintenance load. 

{% navtabs %}
{% navtab Amazon S3 %}
## Prerequisites
 
* An Amazon S3 bucket
* Read and write credentials for the bucket


## Configuration

In this setup, you need to designate one backup node. 
The backup node must have read and write access to the S3 bucket, and the data plane nodes that are provisioned must have read access to the same S3 bucket. 
This node is responsible for communicating the state of the {{site.base_gateway}} `kong.conf` configuration file from the control plane to the S3 bucket.

Nodes are initialized with fallback configs via environment variables, including `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION`. If associating with an IAM role and if the backup node does not reside on the AWS platform then an additional environment variable `AWS_SESSION_TOKEN` may be necessary. 

A backup node should not be used to proxy traffic. A single backup node is sufficient for all deployments. For more information about the data that is set in the environment variables, review the [AWS environment variable configuration documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).

Using Docker Compose, you can configure the backup node:

```yaml
kong-exporter:
    image: 'kong/kong-gateway:latest'
    ports:
      - '8000:8000'
      - '8443:8443'
    environment:
      <<: *other-kong-envs
      AWS_REGION: 'us-east-2'
      AWS_ACCESS_KEY_ID: <access_key_write>
      AWS_SECRET_ACCESS_KEY: <secret_access_key_write>
      KONG_CLUSTER_FALLBACK_CONFIG_STORAGE: s3://test-bucket/test-prefix
      KONG_CLUSTER_FALLBACK_CONFIG_EXPORT: "on"

```

This node is responsible for writing to the S3 bucket when it receives a new configuration. The file structure will be automatically created inside of the bucket, these should not be created manually. If the node version is `3.2.0.0` using the example above, the key name will be `test-prefix/3.2.0.0/config.json`. Both the control plane and data plane can be configured to export configurations.

You can configure new data planes to load a configuration from the S3 bucket if the control plane is unreachable using the following environment variables: 

```yaml
kong-dp-importer:
    image: 'kong/kong-gateway:latest'
    ports:
      - '8000:8000'
      - '8443:8443'
    environment:
      <<: *other-kong-envs
      AWS_REGION: 'us-east-2'
      AWS_ACCESS_KEY_ID: <access_key_read>
      AWS_SECRET_ACCESS_KEY: <secret_access_key_read>
      KONG_CLUSTER_FALLBACK_CONFIG_STORAGE: s3://test-bucket/test-prefix
      KONG_CLUSTER_FALLBACK_CONFIG_IMPORT: "on"

```



{% endnavtab %}
{% navtab GCP Cloud Storage %}
## Prerequisites

* A GCP cloud storage bucket
* Read & write credentials for the bucket


## Configuration

In this setup, you will need to designate one backup node. The backup node must have read & write access to the GCP cloud storage bucket and the data plane nodes that are provisioned must have read access to the same GCP cloud storage bucket. This node is responsible for communicating the state of the {{site.base_gateway}} `kong.conf` configuration file from the control plane to the GCP cloud storage bucket.

Credentials are passed via the environment variable `GCP_SERVICE_ACCOUNT`. For more information about credentials review the [GCP credentials documentation](https://developers.google.com/workspace/guides/create-credentials).

A backup node should not be used to proxy traffic. A single backup node is sufficient for all deployments.

Using Docker Compose, you can configure the backup node:

```yaml
kong-dp-exporter:
    image: 'kong/kong-gateway:latest'
    ports:
      - '8000:8000'
      - '8443:8443'
    environment:
      <<: *other-kong-envs
      GCP_SERVICE_ACCOUNT: <GCP_JSON_STRING_WRITE>
      KONG_CLUSTER_FALLBACK_CONFIG_STORAGE: gcs://test-bucket/test-prefix
      KONG_CLUSTER_FALLBACK_CONFIG_EXPORT: "on"
```

This node is responsible for writing to the GCP bucket when it receives a new configuration. The file structure will be automatically created inside of the bucket, these should not be created manually. If the node version is `3.2.0.0` using the example above, the key name will be `test-prefix/3.2.0.0/config.json`. Both the control plane and data plane can be configured to export configurations.


You can configure new data planes to load a configuration from the GCP cloud storage bucket if the control plane is unreachable using the following environment variables: 

```yaml
  kong-dp-importer:
    image: 'kong/kong-gateway:latest'
    ports:
      - '8000:8000'
      - '8443:8443'
    environment:
      <<: *other-kong-envs
      GCP_SERVICE_ACCOUNT: <GCP_JSON_STRING_READ>
      KONG_CLUSTER_FALLBACK_CONFIG_STORAGE: gcs://test-bucket/test-prefix
      KONG_CLUSTER_FALLBACK_CONFIG_IMPORT: "on"
```



{% endnavtab %}


{% navtab S3 object storage%}
Non-AWS S3 compatible object storage can be configured. The process is similar to the AWS S3 process, but requires an additional parameter `AWS_CONFIG_STORAGE_ENDPOINT`, which should be set to the endpoint of your object storage provider. 

The example below uses MinIO to demonstrate configuring a backup node: 

```yaml
  kong-exporter:
    image: 'kong/kong-gateway:latest'
    ports:
      - '8000:8000'
      - '8443:8443'
    environment:
      <<: *other-kong-envs
      AWS_REGION: 'us-east-2'
      AWS_ACCESS_KEY_ID: <access_key_write>
      AWS_SECRET_ACCESS_KEY: <secret_access_key_write>
      KONG_CLUSTER_FALLBACK_CONFIG_EXPORT: "on"
      KONG_CLUSTER_FALLBACK_CONFIG_STORAGE: s3://test-bucket/test-prefix
      AWS_CONFIG_STORAGE_ENDPOINT: http://minio:9000/
```

{% endnavtab %}
{% endnavtabs %}



## More Information

* [Data plane resilience FAQ](/gateway/latest/kong-enterprise/cp-outage-handling-faq/)
* [Hybrid Mode](/gateway/latest/production/deployment-topologies/hybrid-mode/)
