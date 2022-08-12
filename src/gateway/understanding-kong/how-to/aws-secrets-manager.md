---
title: "Securing Kong Gateway database credentials with AWS Secrets Manager"
description: "How-to keep your {{site.base_gateway}} database credentials secure using AWS SecretsManager and Kong vault integrations."
---

Application secrets include sensitive data like passwords, keys, certifications, tokens, and other items
which must be secured. [{{site.base_gateway}}](/gateway/{{page.kong_version}}/) supports
[Secrets Management](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/) 
that allows you to store secrets in various secure backend systems helping you protect them from accidental
exposure.

Traditionally, {{site.base_gateway}} is configured with static credentials for connecting 
to it's external database. This guide will show you how to configure {{site.base_gateway}} to use 
[AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access.html) to 
read database credentials securely instead of using traditional file or environment variable based solutions.

For this guide you are going to run the PostgreSQL and {{site.base_gateway}} services locally 
on Docker. You will create a secret in the AWS Secrets Manager and deploy {{site.base_gateway}} using a vault reference
to read the value securely.

### Prerequisites

* It is assumed you have access to an [AWS account](https://aws.amazon.com/) and have the 
  [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 
  installed and configured.
  
  Your AWS account or assumed role must have proper IAM permissions to allow 
  access to the AWS Secrets Manager service. Permission policy examples can be found in the 
  [AWS Secrets Manager documentation](https://docs.aws.amazon.com/secretsmanager/latest/userguide/auth-and-access_examples.html).
  In order to create a new secret with the AWS CLI, you will need the following permissions:
  * `secretsmanager:CreateSecret`
  * `secretsmanager:PutSecretValue`

  Additionally, {{site.base_gateway}} will connect to Secrets Manager and retrieve the secret value, 
  this requires the `secretsmanager:GetSecretValue` permission.

  You must be able to configure the gateway environment with the well known 
  [AWS CLI environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)
  as this is the method {{site.base_gateway}} uses to connect to the Secrets Manager service.

* [Docker](https://docs.docker.com/get-docker/) will be used to run {{site.base_gateway}} and the supporting database.
* [`curl`](https://curl.se/) is required on your system to send 
requests to the gateway for testing. Most systems come with `curl` pre-installed.

### Steps

Create a Docker network for {{site.base_gateway}} and the database to communicate over:

```sh
docker network create kong-net
```

Configure and run the database: 

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
> **Note:** A production deployment could use [AWS RDS for PostgreSQL](https://aws.amazon.com/rds/postgresql/) 
which supports direct integration with AWS Secrets Manager.

Next, create a username and password for the {{site.base_gateway}} database and store 
them in environment variables to use in this guide:

```sh
KONG_PG_USER=kong
KONG_PG_PASSWORD=KongFTW
```

Create the {{site.base_gateway}} database user inside the PostgreSQL server container:

```sh
docker exec -it kong-database psql -U admin -c \
  "CREATE USER ${KONG_PG_USER} WITH PASSWORD '${KONG_PG_PASSWORD}'"
```

You should see:
```sh
CREATE ROLE
```

Create a database named `kong` inside the PostgreSQL container:

```sh
docker exec -it kong-database psql -U admin -c "CREATE DATABASE kong OWNER ${KONG_PG_USER};"
```

You should see:
```sh
CREATE DATABASE
```

Create a new AWS secret:

```sh
aws secretsmanager create-secret --name kong-gateway-database \
  --description "Kong GW Database credentials"
```

Update the secret value with the username and password from the variables assigned above.
If you want to update the secret values later, this is the command you would use:

```sh
aws secretsmanager put-secret-value --secret-id kong-gateway-database \
  --secret-string '{"pg_user":"'${KONG_PG_USER}'","pg_password":"'${KONG_PG_PASSWORD}'"}'
```

Before launching {{site.base_gateway}}, run the following command to perform the database migrations:

{:.note}
> **Note:** As of the time of publication, the `kong migrations` tool does not support Secrets Management, so this
step must be done with traditional {{site.base_gateway}} configuration options. In this example, 
we are passing the secrets to Docker via the environment:

```sh
docker run --rm \
  --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_USER=$KONG_PG_USER" \
  -e "KONG_PG_PASSWORD=$KONG_PG_PASSWORD" \
  kong/kong-gateway:latest kong migrations bootstrap
```

Now you'll launch the {{site.base_gateway}} service configured to use referenceable values for the
database username and password. In order to authorize the {{site.base_gateway}} to connect to AWS Secrets Manager,
you need to provide IAM security credentials via environment variables. 

You specify the database credentials in the standard `KONG_PG_*` configuration values, 
but instead of providing a static value you use a 
[referenceable value](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/reference-format/).

In this example, the reference format contains `aws` as the backend vault type, `kong-gateway-database` matches 
the name of the secret created earlier, and `pg_password` are the JSON field name you want to reference 
within the secret value.

See the full 
[AWS Secrets Manager documentation](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/aws-sm/) 
for more details.

Assuming you have set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` in the current 
environment, start {{site.base_gateway}} as follows:

```sh
docker run --rm \
  --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "AWS_ACCESS_KEY_ID" \
  -e "AWS_SECRET_ACCESS_KEY" \
  -e "AWS_REGION" \
  -e "KONG_PG_USER={vault://aws/kong-gateway-database/pg_user}" \
  -e "KONG_PG_PASSWORD={vault://aws/kong-gateway-database/pg_password}" \
  kong/kong-gateway:{{page.kong_version}}
```

After a moment, the gateway should be running and you can verify with the Admin API here:

```sh
curl -s localhost:8001
```

You should receive a JSON response with various information from {{site.base_gateway}}.

The [documentation on {{site.base_gateway}}'s support for Secrets Management](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/)
contains more information on available backends and configuration details.

### What's next?

* [Supported Vault Backends](/gateway/{{page.kong_version}}/plan-and-deploy/security/secrets-management/backends/) provides the list
of vault systems {{site.base_gateway}} can integrate with
* See [Starting Kong Securely](/gateway/{{page.kong_version}}/plan-and-deploy/security/start-kong-securely/) for more 
security practices with {{site.base_gateway}}

