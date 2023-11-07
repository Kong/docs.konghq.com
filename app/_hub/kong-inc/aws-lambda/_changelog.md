## Changelog

**{{site.base_gateway}} 3.5.x**
* The AWS-Lambda plugin has been refactored by using `lua-resty-aws` as an underlying AWS library.
The refactor simplifies the AWS Lambda plugin code base and adds support for multiple IAM
authenticating scenarios. [#11350](https://github.com/Kong/kong/pull/11350)

* Plugin-level proxy configuration now takes effect when fetching IAM credentials in an EKS environment with IRSA. 
This improvement allows the EKS IRSA credential provider (`TokenFileWebIdentityCredentials`) to correctly route requests through the plugin-level proxy configuration when obtaining credentials from the AWS STS service. 
[#11551](https://github.com/Kong/kong/pull/11551)

* The plugin now caches the AWS ambda service by lambda service related fields. 
[#11821](https://github.com/kong/kong/pulls/11821)

**{{site.base_gateway}} 3.3.x**
* Added the `disable_https` configuration field to support HTTP connections to a lambda service.
  [#9799](https://github.com/Kong/kong/pull/9799)

**{{site.base_gateway}} 3.2.x**
* Added the configuration parameter `aws_imds_protocol_version`, which
lets you select the IMDS protocol version.
This option defaults to `v1` and can be set to `v2` to enable IMDSv2.
[#9962](https://github.com/Kong/kong/pull/9962)

**{{site.base_gateway}} 3.1.x**
* Added a `requestContext` field into `awsgateway_compatible` input data.
  [#9380](https://github.com/Kong/kong/pull/9380)

**{{site.base_gateway}} 3.0.x**
* The `proxy_scheme` configuration parameter has been removed from the plugin.
* The plugin now allows both `aws_region` and `host` to be set at the same time.

**{{site.base_gateway}} 2.8.x**
* The `proxy_scheme` configuration parameter is deprecated and planned to be
removed in 3.x.x.
* {{site.base_gateway}} 2.8.1.3: Added support for cross-account invocation through the `aws_assume_role_arn` and `aws_role_session_name` configuration parameters. [#8900](https://github.com/Kong/kong/pull/8900)
* {{site.base_gateway}} 2.8.4.0: Backported the parameter
`aws_imds_protocol_version` into 2.8.x.
* {{site.base_gateway}} 2.8.4.3: The AWS Lambda plugin has been refactored by using `lua-resty-aws` as an underlying AWS library. The refactor simplifies the AWS Lambda plugin codebase and adds support for multiple IAM authenticating scenarios.

**{{site.base_gateway}} 2.7.x**
* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.aws_key` and `config.aws_secret` parameter values will be encrypted.

**{{site.base_gateway}} 2.6.x**
* The AWS region can now be set with the environment variables: `AWS_REGION` or `AWS_DEFAULT_REGION`.

**{{site.base_gateway}} 2.2.x**
* Added support for `isBase64Encoded` flag in Lambda function responses.

**{{site.base_gateway}} 2.1.x**
* Added `host` configuration to allow for custom Lambda endpoints.
