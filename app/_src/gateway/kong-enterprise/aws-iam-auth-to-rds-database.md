---
title: Use AWS IAM Authentication to connect to RDS database in Kong Gateway Enterprise
badge: enterprise
content_type: reference
---

Starting in version 3.3, {{site.base_gateway}} can be set up to use the AWS IAM Authentication to connect to the AWS RDS database(Postgres). This document describes the details about how to use this feature to secure your database configurations and database connections.


## How does it work

The AWS RDS database provides the ability to allow you to use the AWS Identity and Access Management(IAM) to authenticate and connect.
With this feature enabled, you don't need to use a password when you connect to a DB instance. Instead, you use a temporary authentication token, which is a unique string of characters that generates on request. The authentication still goes through the standard database authentication, and you don't need to store user credentials in the database, because the authentication is managed externally using IAM. If you're a Kong Enterprise user in the AWS cloud environment, you can apply this feature with proper IAM configuration to your running cluster, so that you don't need to store any database user credentials on both Kong side and the RDS database side.

## Prerequisition

Before enabling the AWS IAM Authentication feature, you need to check the following items are properly configured on both your AWS RDS database and your AWS IAM role that Kong instance uses.

- **Enable the IAM database authentication on your DB instance**. This configuration is disabled by default. You can follow the AWS documentation step by step to enable the IAM database authentication on your RDS instance: [https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Enabling.html](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Enabling.html).
  You can check the "Configuration" page on your database cluster details. Make sure the value of "IAM DB authentication" is "Enabled".

{:.note}
> **Note:** You must enable SSL connection on your Postgres DB instance, which is usually done by setting `ssl` parameter value to 1 in the parameter group. After enabling the IAM database authentication, you cannot disable the SSL connection.

- **Ensure your Kong instance have been assigned an IAM role**. If your Kong cluster are deployed without a proper IAM role, you must assign one first. For example, if your Kong instance is running on an EC2 machine, you can assign EC2 IAM role on your EC2 machine; if you're running Kong in the ECS cluster, you can assign a IAM role as a task role to your ECS service task definition; if you're running Kong in the EKS cluster, you can configure a kubernetes service account that can assume to your assigned role, and configure your pods to use the service account. The Kong instance can discover and fetch the AWS credential to use the assigned IAM role automatically, just like the AWS SDK. For now, it supports fetching through the following ways(in order of precedence):
  - Use Environment variables like `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
  - Use credential file provided by the environment variable `AWS_SHARED_CREDENTIALS_FILE`.
  - Use [ECS Task IAM role](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-iam-roles.html) automatically when the Kong instance is running inside an ECS container
  - Use [IAM role defined by serviceaccount](https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html) inside EKS pod
  - Use [EC2 IAM role](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html) inside EC2 environment

{:.warning}
> You **cannot** change the value of the environment variables that used to provide the AWS Credential after Kong instance boot up. The change will be ignored and **will not take effect** inside Kong instance.

- **Ensure the IAM role you assinging to Kong has proper IAM policy**. Below is a simple example policy allows a user "john" to connect to a RDS instance "db-ABCDEFGHIJKL01234" by using the IAM database authentication:

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
             "rds-db:connect"
         ],
         "Resource": [
             "arn:aws:rds-db:us-east-2:1234567890:dbuser:db-ABCDEFGHIJKL01234/john"
         ]
      }
   ]
}
```

For more details, please check the AWS documentation: [https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.IAMPolicy.html](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.IAMPolicy.html)

- **Ensure you have the database account created in the RDS**. You need to create the database user and then grant them the `rds_iam` role as shown in the following example:

```text
CREATE USER john;
GRANT rds_iam TO john;
```

You can use `\du` in your RDS database to check you have the database account created:

```text
kong=> \du
                                                               List of roles
    Role name    |                         Attributes                         |                          Member of
-----------------+------------------------------------------------------------+-------------------------------------------------------------
 john            |                                                            | {rds_iam}
```

{:.note}
> **Note:** The database user with `rds_iam` role granted cannot authenticate in the normal username/password way, you must use the IAM Database authentication instead.

## Getting started

Enabling the AWS IAM Authentication feature is quite simple. You can enable it by using the environment variable or using the configuration file. Also, don't forget to remove the `pg_password` or `pg_ro_password` after switching to use the AWS IAM Authentication. You'll also need to check your `pg_user` or `pg_ro_user` is the same username defined in the IAM policy and created in the Postgres RDS database.

You can either enable this feature on both read only connection and read write connection, or just enable it on the read only connection. Enabling the feature on readonly will make Kong ignore `pg_ro_password` config property, but it does not influence on the read-write related configs, which means that `pg_user` and `pg_password` will work as normal.

### Environment variable

You can enable by setting the `KONG_PG_IAM_AUTH` environment variable to `on`. Accordingly, if you only want to enable it on the readonly mode of Postgres connections, you can set `KONG_PG_RO_IAM_AUTH` environment variable to `on`.

```bash
# Set KONG_PG_IAM_AUTH if you want to enable the feature on both read and write
KONG_PG_IAM_AUTH=on
# Set KONG_PG_RO_IAM_AUTH if you only want to enable on the read only connection
KONG_PG_RO_IAM_AUTH=on
```

### Configuration file

The `kong.conf` file contains the property `pg_iam_auth` and `pg_ro_iam_auth`.
Just like the environmen variable, you can set them to `on` accordingly, if you want to enable the IAM Authentication on both read and write connection, or just read-only connection to the RDS Postgres database.

```text
# Set pg_iam_auth if you want to enable the feature on both read and write
pg_iam_auth=on
# Set pg_ro_iam_auth if you only want to enable on the read only connection
pg_ro_iam_auth=on
```


## Limitations

The AWS IAM Authentication also has some limitations, some are from the AWS service and some are within the Kong runtime. Be sure to go through them one by one before you start to use this feature in your production environment.

- According to the AWS documentation, the AWS IAM Authentication to the RDS will work "when your application requires fewer than 200 new IAM database authentication connections per second". Establishing database connections more than that number in every second may result in connection throttling, controlled by the IAM service. Note that this does not affect the total number of keep-alive connections from Kong to the database, it only affects the connection establishment. Especially if you're using a traditional cluster(in which every Kong node needs to connect to the database) deployment with many Kong nodes, make sure that your number of connection establish action in your whole cluster is lower than the maximum value of 200.
- Enabling the AWS IAM Authentication feature requires mandatory SSL connection to the database, which needs you to configure both your RDS cluster properly, and provide correct ssl related configs on Kong's side. Enabling SSL will also introduce some performance overhead(but not much) if you do not use SSL connection to your database in the old time.
- Since the Postgres RDS does not support mTLS, enabling mTLS between the Kong and the Postgres RDS database is not allowed when using this feature.
- After enabling this feature on the read/write mode or on the read-only mode, the `pg_password` or `pg_ro_password` configuration will be ignored accordingly when establishing connections.
- As said in the Prerequisition section, you **cannot** change the value of the environment variables that used to provide the AWS Credential after Kong instance boot up. The change will be ignored and **will not take effect** inside Kong instance.
- As said in the Prerequisition section, a database user with `rds_iam` role granted cannot authenticate in the normal username/password way, you must use the IAM Database authentication instead.
