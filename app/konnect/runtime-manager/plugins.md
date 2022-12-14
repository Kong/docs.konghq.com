---
title: Plugins
content_type: explanation
---

You can extend {{site.konnect_short_name}} by using plugins. Kong provides a set of standard Lua plugins that get bundled with {{site.konnect_short_name}}. The set of plugins you have access to depends on your installation.

## Dynamic plugin ordering

By default, plugins execution order is static. You can override the static priority for any {{site.konnect_short_name}} plugin by using each plugin's
dynamic plugin ordering settings field. This determines plugin ordering during the `access` phase,
and lets you create _dynamic_ dependencies between plugins. 

To configure this setting in {{site.konnect_short_name}}, go to **Runtime Manager > Plugins**, and then select **Configure Dynamic Ordering** from the context menu next to the plugin you want to configure. From the plugin ordering settings, you can configure whether a plugin runs before or after another plugin.

## Plugin execution order

The order in which plugins are executed in {{site.konnect_short_name}} is determined by their
static priority. As the name suggests, this value is _static_ and can't be easily changed by the user. 

The following list includes all plugins bundled with a {{site.konnect_short_name}}
Enterprise subscription.

The current order of execution for the bundled plugins is:

<!-- vale off -->

Plugin                      | Priority
----------------------------|----------
pre-function                | 1000000
app-dynamics                | 999999
correlation-id              | 100001 <!--  CE priority is 1, EE priority is 100001 -->
zipkin                      | 100000
exit-transformer            | 9999
bot-detection               | 2500
cors                        | 2000
jwe-decrypt                 | 1999
session                     | 1900
oauth2-introspection        | 1700
acme                        | 1705
mtls-auth                   | 1600
jwt                         | 1450
key-auth                    | 1250
ldap-auth                   | 1200
ldap-auth-advanced          | 1200
basic-auth                  | 1100
openid-connect              | 1050
hmac-auth                   | 1030
jwt-signer                  | 1020
request-validator           | 999
websocket-size-limit        | 999
websocket-validator         | 999
xml-threat-protection       | 999
grpc-gateway                | 998
tls-handshake-modifier      | 997
tls-metadata-headers        | 996
ip-restriction              | 990
request-size-limiting       | 951
acl                         | 950
opa                         | 920
rate-limiting               | 910
rate-limiting-advanced      | 910
response-ratelimiting       | 900
saml                        | 900
oas-validation              | 850
route-by-header             | 850
jq                          | 811
request-transformer-advanced | 802
request-transformer         | 801
response-transformer-advanced | 800
response-transformer        | 800
route-transformer-advanced  | 780
kafka-upstream              | 751
aws-lambda                  | 750
azure-functions             | 749
upstream-timeout            | 400
proxy-cache-advanced        | 100
proxy-cache                 | 100
graphql-proxy-cache-advanced | 99
forward-proxy               | 50
canary                      | 20
opentelemetry               | 14
prometheus                  | 13
http-log                    | 12
statsd                      | 11
statsd-advanced             | 11
datadog                     | 10
file-log                    | 9
udp-log                     | 8
tcp-log                     | 7
loggly                      | 6
kafka-log                   | 5
syslog                      | 4
grpc-web                    | 3
request-termination         | 2
mocking                     | -1
post-function               | -1000