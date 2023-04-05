---
name: AWS Lambda
publisher: Kong Inc.
desc: Invoke and manage AWS Lambda functions from Kong
description: |
  Invoke an [AWS Lambda](https://aws.amazon.com/lambda/) function from Kong. The
  AWS Lambda plugin can be used in combination with other request plugins to secure, manage, or
  extend the function.
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

## Sending parameters

Any form parameter sent along with the request is also sent as an
argument to the AWS Lambda function.

---
## Notes

If you provide `aws_key` and `aws_secret`, they will be used in the highest priority to
invoke the Lambda function.

If you do not provide an `aws_key` and `aws_secret`, the plugin uses an IAM role inherited
from the instance running Kong.

{% if_plugin_version lte:2.7.x %}

First, the plugin tries ECS metadata to get the role. If no ECS metadata is available,
the plugin falls back on EC2 metadata.

{% endif_plugin_version %}

{% if_plugin_version gte:2.8.x %}

For example, if you're running Kong on an EC2 instance, the IAM role that attached
to the EC2 will be used, and Kong will fetch the credential from the
[EC2 Instance Metadata service(IMDSv1)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html).
If you're running Kong in an ECS container, the task IAM role will be used, and Kong will fetch the credentials from
the [container credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html).
Note that the plugin will first try to fetch from ECS metadata to get the role, and if no ECS metadata related environment
variables are available, the plugin falls back on EC2 metadata.

If you also provide the `aws_assume_role_arn` option, the plugin will try to perform
an additional [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)
action, which requires the Kong process to make HTTPS request to AWS STS service API, after
configuring AWS access key/secret or fetching credentials automatically from EC2/ECS IAM roles.
If it succeeds, the plugin will fetch a temporary security credentials that represents
that the plugin now has the access permission configured in the target assumed role.

{% endif_plugin_version %}

{% if_plugin_version gte:2.6.x %}
## AWS region as environment variable

If the plugin configuration `aws_region` is unset, the plugin attempts to obtain the
AWS region through environment variables `AWS_REGION` and `AWS_DEFAULT_REGION`,
with the former taking higher precedence. For example, if both `AWS_REGION` and
`AWS_DEFAULT_REGION` are set, the `AWS_REGION` value is used; otherwise, if only
`AWS_DEFAULT_REGION` is set, its value is used. If neither configuration `aws_region`
nor environment variables are set, a run-time error "no region or host specified"
will be thrown.

{% endif_plugin_version %}

{% if_plugin_version lte:2.1.x %}

### Known issues

#### Use a fake upstream service

When using the AWS Lambda plugin, the response will be returned by the plugin
itself without proxying the request to any upstream service. The service
configured for a route is ignored when using this plugin.

Versions of {{site.ce_product_name}} prior to 2.x require a service on all
routes. Even though the service will not be used, you must configure a
placeholder service for routes using this plugin. Versions after 2.x allow you
to omit service configuration.

When using {{site.kic_product_name}}, Kubernetes Ingresses require a service.
Even on {{site.ce_product_name}} versions that support empty services, you must still configure a placeholder service for the Ingress. An [ExternalName
service](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)
for an unresolvable domain (for example, `fake.example`) satisfies this
requirement without requiring a Deployment associated with the service.

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

{% endif_plugin_version %}

---
## Usage

Prerequisite: You must have access to the AWS Console as a user who is
allowed to operate with lambda functions, and create users and roles.

1. First, create an execution role called `LambdaExecutor` for your
lambda function.

    In the IAM Console, create a new Role choosing the AWS Lambda service. There
    will be no policies because the function in this example will simply execute
    itself, returning a hardcoded JSON response without accessing other
    AWS resources.

2. Create a user named `KongInvoker`, used by the Kong API gateway
to invoke the function.

    In the IAM Console, create a new user. Programmatic access must be provided to the user via Access and Secret keys. Then, attach existing policies directly, particularly the predefined `AWSLambdaRole`. After the user creation is confirmed, store the Access Key and Secret Key in a safe place.

3. Next, create the lambda function itself in the N. Virginia Region
(code `us-east-1`).

    In Lambda Management, create a new function `MyLambda`. There will be no blueprint because you are going to paste the code below (which is an example code snippet). For the execution role, choose the `LambdaExecutor` created previously.

    **Note**: The following code snippet is only an example. The Kong AWS Lambda plugin supports all runtimes provided by AWS. See the list of runtimes in the **AWS Lambda** > **Functions** > **Create function** dialog.

    ```python
    import json
    def lambda_handler(event, context):
        """
          If is_proxy_integration is set to true :
          jsonbody='''{"statusCode": 200, "body": {"response": "yes"}}'''
        """
        jsonbody='''{"response": "yes"}'''
        return json.loads(jsonbody)
    ```

    Test the lambda function from the AWS console and make sure the execution succeeds.

4. Set up a route in Kong and link it to the `MyLambda` function you just created.

{% navtabs %}
{% navtab With a database %}

Create the route:

```bash
curl -i -X POST http://<kong_hostname>:8001/routes \
--data 'name=lambda1' \
--data 'paths[1]=/lambda1'
```

Add the plugin:

```bash
curl -i -X POST http://<kong_hostname>:8001/routes/lambda1/plugins \
--data 'name=aws-lambda' \
--data-urlencode 'config.aws_key={KongInvoker user key}' \
--data-urlencode 'config.aws_secret={KongInvoker user secret}' \
--data 'config.aws_region=us-east-1' \
--data 'config.function_name=MyLambda'
```

{% endnavtab %}
{% navtab Without a database %}

Add a route and plugin to the declarative config file:

``` yaml
routes:
- name: lambda1
  paths: [ "/lambda1" ]

plugins:
- route: lambda1
  name: aws-lambda
  config:
    aws_key: {KongInvoker user key}
    aws_secret: {KongInvoker user secret}
    aws_region: us-east-1
    function_name: MyLambda
```

{% endnavtab %}
{% endnavtabs %}

### Test your Lambda with Kong

After everything is created, make the http request and verify the correct
invocation, execution, and response:

```bash
curl http://<kong_hostname>:8000/lambda1
```

Additional headers:

```
x-amzn-Remapped-Content-Length, X-Amzn-Trace-Id, x-amzn-RequestId
```

JSON response:

```json
{"response": "yes"}
```

Have fun leveraging the power of AWS Lambda in Kong!

---
