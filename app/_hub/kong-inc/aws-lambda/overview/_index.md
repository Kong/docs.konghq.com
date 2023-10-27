---
nav_title: Overview
---

This plugin lets you invoke an [AWS Lambda](https://aws.amazon.com/lambda/) function from {{site.base_gateway}}. 
The AWS Lambda plugin can be used in combination with other [request plugins](/hub/?search=request) 
to secure, manage, or extend the function.

Any form parameter sent along with the request is also sent as an argument to the AWS Lambda function.

## Notes

By default, cURL sends payloads with an
`application/x-www-form-urlencoded` MIME type, which will naturally be URL-
decoded by Kong. To ensure special characters that are likely to appear in
your AWS key or secret (like `+`) are correctly decoded, you must
URL-encode them with `--data-urlencode`.
Alternatives to this approach would be to send your payload with a
different MIME type (like `application/json`), or to use a different HTTP client.

If you provide `aws_key` and `aws_secret`, they will be used in the highest priority to
invoke the Lambda function.

If you do not provide an `aws_key` and `aws_secret`, the plugin uses an IAM role inherited
from the instance running Kong.

{% if_plugin_version lte:2.7.x %}

First, the plugin tries ECS metadata to get the role. If no ECS metadata is available,
the plugin falls back on EC2 metadata.

{% endif_plugin_version %}

{% if_plugin_version eq:2.8.x %}

The AWS Lambda plugin automatically fetches the IAM role credential according to the following
precedence order:
1. Fetch from credentials defined in environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
2. Fetch from profile and credential files, defined by `AWS_PROFILE` and `AWS_SHARED_CREDENTIALS_FILE`.
3. Fetch from ECS [container credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html).
4. Fetch from EKS [IAM roles for service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).
5. Fetch from EC2 IMDS metadata (both v1 and v2 are supported).

If you also provide the `aws_assume_role_arn` option, the plugin tries to perform
an additional [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)
action. The AssumeRole action requires the {{site.base_gateway}} process to make an HTTPS request to the AWS STS service API after
configuring AWS access key/secret or fetching credentials automatically from EC2/ECS/EKS IAM roles.
If it succeeds, the plugin fetches temporary security credentials that represent
that the plugin now has the access permission configured in the target assumed role. Then, the plugin will try to invoke the lambda function based on the target assumed role.

{% endif_plugin_version %}

{% if_plugin_version gte:2.8.x %}

The AWS Lambda plugin will automatically fetch the IAM role credential according to the following
precedence order:
- Fetch from the credentials defined in the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables.
- Fetch from the profile and credential file, defined by `AWS_PROFILE` and `AWS_SHARED_CREDENTIALS_FILE`.
- Fetch from the ECS [container credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html).
- Fetch from the EKS [IAM roles for the service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).
- Fetch from the EC2 IMDS metadata. Both v1 and v2 are supported.

If you also provide the `aws_assume_role_arn` option, the plugin will try to perform
an additional [AssumeRole](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html)
action. This requires the Kong process to make a HTTPS request to the AWS STS service API after
configuring the AWS access key/secret or fetching credentials automatically from EC2/ECS/EKS IAM roles.
If it succeeds, the plugin will fetch temporary security credentials that represents
that the plugin now has the access permission configured in the target assumed role. Then the plugin will try to invoke the lambda function based on the target assumed role.

{% endif_plugin_version %}


## AWS region as environment variable

If the plugin configuration `aws_region` is unset, the plugin attempts to obtain the
AWS region through environment variables `AWS_REGION` and `AWS_DEFAULT_REGION`,
with the former taking higher precedence. For example, if both `AWS_REGION` and
`AWS_DEFAULT_REGION` are set, the `AWS_REGION` value is used; otherwise, if only
`AWS_DEFAULT_REGION` is set, its value is used. If neither configuration `aws_region`
nor environment variables are set, a run-time error "no region or host specified"
will be thrown.

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
curl -i -X POST http://localhost:8001/routes \
--data 'name=lambda1' \
--data 'paths[1]=/lambda1'
```

Add the plugin:

```bash
curl -i -X POST http://localhost:8001/routes/lambda1/plugins \
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
curl http://localhost:8000/lambda1
```

You should get a response back with the following headers from Amazon:

```
x-amzn-Remapped-Content-Length, X-Amzn-Trace-Id, x-amzn-RequestId
```

JSON response:

```json
{"response": "yes"}
```

Have fun leveraging the power of AWS Lambda in Kong!
