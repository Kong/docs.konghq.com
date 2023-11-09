---
title: Securing Kong Gateway database credentials with AWS Secrets Manager
content_type: how-to
badge: enterprise
description: "How to keep your {{site.base_gateway}} database credentials secure using AWS Secrets Manager and vault integrations."
---

Application secrets include sensitive data like passwords, keys, certifications, tokens, and other items
which must be secured. [{{site.base_gateway}}](/gateway/{{page.kong_version}}/) supports
[Secrets Management](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/)
which allows you to store secrets in various secure backend systems and helps you protect them from accidental
exposure.

Traditionally, {{site.base_gateway}} is configured with static credentials for connecting
to its external database. This guide will show you how to configure {{site.base_gateway}} to use
[AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access.html) to
read database credentials securely instead the conventional file or environment variable based solutions.

For this guide, you will run the PostgreSQL and {{site.base_gateway}} locally on Docker.
You will create a secret in the AWS Secrets Manager and deploy {{site.base_gateway}} using a vault reference
to read the value securely.

### Prerequisites

* An [AWS account](https://aws.amazon.com/). Your account must have the proper IAM permissions to allow access to the AWS Secrets Manager service. Permission policy examples can be found in the [AWS Secrets Manager documentation](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_examples.html). Additionally, you must have the following permissions:
  * `secretsmanager:CreateSecret`
  * `secretsmanager:PutSecretValue`
  * `secretsmanager:GetSecretValue`
* The [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configured. You must be able to configure the gateway environment with [AWS CLI environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) because this is the method that {{site.base_gateway}} uses to connect to the Secrets Manager service.

* [Docker](https://docs.docker.com/get-docker/) installed.
* [`curl`](https://curl.se/) is required on your system to send
requests to the gateway for testing. Most systems come with `curl` pre-installed.

### Configure {{site.base_gateway}} to use AWS Secrets Manager

1. Create a Docker network for {{site.base_gateway}} and the database to communicate over:

   ```sh
   docker network create kong-net
   ```

1. Configure and run the database:

   ```sh
   docker run -d --name kong-database \
     --network=kong-net \
     -p 5432:5432 \
     -e "POSTGRES_USER=admin" \
     -e "POSTGRES_PASSWORD=password" \
     postgres:9.6
   ```

   The username and password used above are the PostgreSQL master credentials, *not* the
   username and password you will use to authorize {{site.base_gateway}} with the database.

   {:.note}
   > **Note:** A production deployment can use [AWS RDS for PostgreSQL](https://aws.amazon.com/rds/postgresql/)
   which supports direct integration with AWS Secrets Manager.

1. Create a username and password for {{site.base_gateway}}'s database and store
them in environment variables to use in this guide:

   ```sh
   KONG_PG_USER=kong
   KONG_PG_PASSWORD=KongFTW
   ```

1. Create the {{site.base_gateway}} database user inside the PostgreSQL server container:

   ```sh
   docker exec -it kong-database psql -U admin -c \
     "CREATE USER ${KONG_PG_USER} WITH PASSWORD '${KONG_PG_PASSWORD}'"
   ```

   You should see:
   ```sh
   CREATE ROLE
   ```

1. Create a database named `kong` inside the PostgreSQL container:

   ```sh
   docker exec -it kong-database psql -U admin -c "CREATE DATABASE kong OWNER ${KONG_PG_USER};"
   ```

   You should see:
   ```sh
   CREATE DATABASE
   ```

1. Create a new AWS secret:

   ```sh
   aws secretsmanager create-secret --name kong-gateway-database \
     --description "Kong GW Database credentials"
   ```

1. Update the secret value with the username and password from the variables assigned above.
If you want to update the secret values later, this is the command you would use:

   ```sh
   aws secretsmanager put-secret-value --secret-id kong-gateway-database \
     --secret-string '{"pg_user":"'${KONG_PG_USER}'","pg_password":"'${KONG_PG_PASSWORD}'"}'
   ```

1. Before launching {{site.base_gateway}}, run the following command to perform the database migrations:

   {:.note}
   > **Note:** Currently, the `kong migrations` tool does not support Secrets Management, so this
   step must be done with traditional {{site.base_gateway}} configuration options. In this example,
   we are passing the secrets to Docker via the environment.

   ```sh
   docker run --rm \
     --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "KONG_PG_USER=$KONG_PG_USER" \
     -e "KONG_PG_PASSWORD=$KONG_PG_PASSWORD" \
     kong/kong-gateway:latest kong migrations bootstrap
   ```

1. Launch {{site.base_gateway}} configured to use values it can reference for the
database username and password. To authorize {{site.base_gateway}} to connect to AWS Secrets Manager,
you need to provide IAM security credentials via environment variables.

   You specify the database credentials using the standard `KONG_`
   [environment variable names](/gateway/{{page.kong_version}}/reference/configuration/#environment-variables),
   but instead of providing a static value you use a
   [reference value](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/reference-format/).

   The format looks like this: `{vault://aws/kong-gateway-database/pg_user}`. In this example,
   the reference format contains `aws` as the backend vault type, `kong-gateway-database` matches
   the name of the secret created earlier, and `pg_user` is the JSON field name you want to reference
   in the secret value.

   See the
   [AWS Secrets Manager documentation](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/aws-sm/)
   for more details.

   Assuming you have set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, and `AWS_SESSION_TOKEN` in the current
   environment, start {{site.base_gateway}} like this:

   ```sh
   docker run --rm \
     --network=kong-net \
     -e "KONG_DATABASE=postgres" \
     -e "KONG_PG_HOST=kong-database" \
     -e "AWS_ACCESS_KEY_ID" \
     -e "AWS_SECRET_ACCESS_KEY" \
     -e "AWS_REGION" \
     -e "AWS_SESSION_TOKEN" \
     -e "KONG_PG_USER={vault://aws/kong-gateway-database/pg_user}" \
     -e "KONG_PG_PASSWORD={vault://aws/kong-gateway-database/pg_password}" \
     kong/kong-gateway:{{page.kong_version}}
   ```

   After a moment, {{site.base_gateway}} should be running, which you can verify with the Admin API:

   ```sh
   curl -s localhost:8001
   ```

   You should receive a JSON response with various information from {{site.base_gateway}}.

The [Secrets Management documentation](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/)
contains more information about available backends and configuration details.

### More information

* See the following documentation for supported vault backends that  {{site.base_gateway}} can integrate with:
  * [Environment Variables Vault](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/env/)
  * [AWS Secrets Manager](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/aws-sm/)
  * [Hashicorp Vault](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/hashicorp-vault/)
  * [Google Secrets Management](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/backends/gcp-sm/)
* See [Starting Kong Securely](/gateway/{{page.kong_version}}/production/access-control/start-securely/) for more
security practices with {{site.base_gateway}}
