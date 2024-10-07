---
nav_title: Overview
---

This plugin allows for secure communication with AWS Lambdas. It signs requests with AWS SIGV4 and temporary credentials obtained from sts.amazonaws.com using an OAuth token. 
This eliminates the need for an AWS API Gateway and simplifies the use of Lambdas as upstreams in Kong. 

However, in order to use this plugin, there is an AWS setup required.
Specifically, you will need to add your token issuer to the "Identity Providers" in your AWS account, this way the plugin can request temporary credentials. 

For more information on the required AWS setup, visit the [plugin repo.](https://github.com/LEGO/kong-aws-request-signing#aws-setup-required)

Once this is done, you can use the plugin to communicate with your Lambda HTTPS endpoint.
