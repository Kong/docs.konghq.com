<!-- vale off -->

{% if include.edition == "oss" %}

Plugin                      | Priority
----------------------------|----------
pre-function                | 1000000
correlation-id <span class="badge free"></span> | 100001
zipkin                      | 100000
bot-detection               | 2500
cors                        | 2000
session                     | 1900
acme                        | 1705
jwt                         | 1450
oauth2                      | 1400
key-auth                    | 1250
ldap-auth                   | 1200
basic-auth                  | 1100
hmac-auth                   | 1030
grpc-gateway                | 998
ip-restriction              | 990
request-size-limiting       | 951
acl                         | 950
rate-limiting               | 910
response-ratelimiting       | 900
request-transformer         | 801
response-transformer        | 800
aws-lambda                  | 750
azure-functions             | 749
upstream-timeout            | 400
proxy-cache                 | 100
opentelemetry               | 14
prometheus                  | 13
http-log                    | 12
statsd                      | 11
datadog                     | 10
file-log                    | 9
udp-log                     | 8
tcp-log                     | 7
loggly                      | 6
syslog                      | 4
grpc-web                    | 3
request-termination         | 2
correlation-id <span class="badge oss"></span> | 1
post-function               | -1000

{% endif %}

{% if include.edition == "enterprise" %}

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
degraphql                   | 1500
jwt                         | 1450
oauth2                      | 1400
vault-auth                  | 1350
key-auth                    | 1250
key-auth-enc                | 1250
ldap-auth                   | 1200
ldap-auth-advanced          | 1200
basic-auth                  | 1100
openid-connect              | 1050
hmac-auth                   | 1030
jwt-signer                  | 1020
saml                        | 1010
request-validator           | 999
websocket-size-limit        | 999
websocket-validator         | 999
xml-threat-protection       | 999
grpc-gateway                | 998
tls-handshake-modifier      | 997
tls-metadata-headers        | 996
application-registration    | 995
ip-restriction              | 990
request-size-limiting       | 951
acl                         | 950
opa                         | 920
rate-limiting               | 910
rate-limiting-advanced      | 910
graphql-rate-limiting-advanced | 902
response-ratelimiting       | 900
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

{% endif %}
