---
title: Authenticate your Kong Gateway Amazon RDS database with AWS IAM
badge: enterprise
content_type: how-to
---

Starting in {{site.base_gateway}} 3.3.x, you can use AWS Identity and Access Management (IAM) authentication to connect to the AWS RDS database that you use for {{site.base_gateway}}. This page describes how to use this feature to secure your database configurations and database connections.

When you enable this feature, you don't need to use a password when you connect to a database instance. Instead, you use a temporary authentication token. Because AWS IAM manages the authentication externally, the database doesn't store user credentials. If you use AWS RDS for {{site.base_gateway}}'s database, you can enable this feature on your running cluster. This ensures that you don't have to store database user credentials on both the {{site.base_gateway}} (`pg_password`) and RDS database side. 

## AWS IAM authentication limitations

AWS IAM authentication also has some limitations. Go through each one before you use this feature in your production environment:

* For a traditional {{site.base_gateway}} cluster or single traditional nodes, only use IAM database authentication if {{site.base_gateway}} requires less than 200 new IAM database authentications per second. Establishing more connections per second can result in throttling. Authentication only happens on each connection's initialization part after the connection is successfully established; the following queries and communication don't authenticate. Check the TPS of the connection establishment on your database to ensure you aren't encountering this limitation. Traditional clusters are more likely to encounter this limitation because each node needs to establish connections to the database. For more information, see [Recommendations for IAM database authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html#UsingWithRDS.IAMDBAuth.ConnectionsPerSecond) in the Amazon RDS user guide. 
* Enabling AWS IAM authentication requires SSL connection to the database. To do this, you must configure your RDS cluster correctly and provide the correct SSL-related configurations on {{site.base_gateway}}'s side. Enabling SSL also results in some performance overhead if you didn't previously use it. Currently, TLSv1.3 isn't supported by AWS RDS.
- Since the Postgres RDS does not support mTLS, you can't enable mTLS between the {{site.base_gateway}} and the Postgres RDS database when AWS IAM authentication is enabled.
- You **can't** change the value of the environment variables that you use for the AWS credential after booting {{site.base_gateway}}.

For additional recommendations and limitations, see [IAM database authentication for MariaDB, MySQL, and PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html) in the Amazon RDS user guide. 

## Prerequisites

Before you enable the AWS IAM authentication, you must configure your AWS RDS database and the AWS IAM role that {{site.base_gateway}} uses.

- **Enable the IAM database authentication on your database instance.** For more information, see [Enabling and disabling IAM database authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Enabling.html) in the Amazon RDS user guide.
- **Assign an IAM role to your {{site.base_gateway}} instance.** {{site.base_gateway}} can automatically discover and fetch the AWS credentials to use for the IAM role.
   - If you use an EC2 environment, use the [EC2 IAM role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).
   - If you use an ECS cluster, use a [ECS task IAM role](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-iam-roles.html).
   - If you use an EKS cluster, configure a Kubernetes service account that can annotate your assigned role and configure the pods to use an [IAM role defined by `serviceaccount`](https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html). 
   
      Using an IAM role defined by `serviceaccount` requires a request to the AWS STS service, so you also need to make sure that your Kong instance inside the Pod can access the AWS STS service endpoint. 
   
      If you're using STS regional endpoints, make sure you have `AWS_STS_REGIONAL_ENDPOINTS` defined in your environment variables.
   - If you run {{site.base_gateway}} locally, use the environment variables, like access key and secret key combination by using `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, or profile and credential file combination by using `AWS_PROFILE` and `AWS_SHARED_CREDENTIALS_FILE`
   
   {:.warning}
   > **Warning:** You **can't** change the value of the environment variables you used to provide the AWS credential after booting {{site.base_gateway}}. Any changes are ignored.

- **Assign an IAM policy to the {{site.base_gateway}} IAM role**. For more information, see [Creating and using an IAM policy for IAM database access](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.IAMPolicy.html) in the Amazon RDS documentation.

- **Ensure you create the database account in the RDS**. For more information, see [Using IAM authentication with PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.DBAccounts.html#UsingWithRDS.IAMDBAuth.DBAccounts.PostgreSQL) in the Amazon RDS documentation. 

   {:.note}
   > **Notes:** 
   > * The database user assigned to the `rds_iam` role can only use the IAM database authentication.
   > * Make sure to create the database and grant the correct permissions to the database user you just created. See [Using a database](/gateway/latest/install/linux/debian/#using-a-database) for more information.

## Enabling AWS IAM authentication

You can enable AWS IAM authentication by using an environment variable or using the {{site.base_gateway}} configuration file. You can either enable this feature in both read-only and read-write mode, or just enable it in read-only mode. 

{:.note}
> **Note:** When the AWS IAM authentication is enabled, {{site.base_gateway}} will ignore the related password configs. Enabling the authentication only in read-only mode will not influence the read-write related configs, so `pg_user` and `pg_password` function normally. 

Before you enable AWS IAM authentication, you must do the following in the `kong.conf` file:
* Remove `pg_password` or `pg_ro_password`.
* Check that `pg_user` or `pg_ro_user` matches the username you defined in the IAM policy and created in the Postgres RDS database.

### Enable AWS IAM authentication with environment variables

To enable AWS IAM authentication in read-write and read-only mode, set the `KONG_PG_IAM_AUTH` environment variable to `on`: 

```bash
KONG_PG_IAM_AUTH=on
```

To enable AWS IAM authentication in read-only mode, you can set the following:

```bash
KONG_PG_IAM_AUTH=off # This line can be omitted because off is the default value
KONG_PG_RO_IAM_AUTH=on
```

### Enable AWS IAM authentication in the configuration file

The [`kong.conf` file](/gateway/{{page.release}}/production/kong-conf/) contains the `pg_iam_auth` and `pg_ro_iam_auth` properties.
Just like the environment variable, you can set them to `on` accordingly, if you want to enable the IAM Authentication on both read and write connection, or just read-only connection to the RDS Postgres database.

To enable AWS IAM authentication in read-write mode, set `pg_iam_auth` to `on`:

```text
pg_iam_auth=on
```

To enable AWS IAM authentication in read-only mode, set `pg_ro_iam_auth` to `on`:
```text
pg_ro_iam_auth=on
```

{:.note}
> **Note:** If you enable AWS IAM authentication in the configuration file, you must specify the configuration file with the feature property on when you run the migrations command. For example, `kong migrations bootstrap -c /path/to/kong.conf`.
