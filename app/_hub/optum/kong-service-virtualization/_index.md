### Overview
This plugin will enable mocking virtual API request and response pairs through Kong Gateway.

### Explanation

`kong-service-virtualization` schema `virtual_tests` arguments:

```
[
     {
           "name": "TestCase1",           
           "requestHttpMethod": "POST",
           "requestHash": "0296217561490155228da9c17fc555cf9db82d159732f3206638c25f04a285c4",
           "responseHttpStatus": "200",
           "responseContentType": "application/json",
           "response": "eyJtZXNzYWdlIjogIkEgQmlnIFN1Y2Nlc3MhIn0="
    },
    {         
           "name": "TestCase2",           
           "requestHttpMethod": "GET",
           "requestHash": "e2c319e4ef41706e2c0c1b266c62cad607a014c59597ba662bef6d10a0b64a32",
           "responseHttpStatus": "200",
           "responseContentType": "application/json",
           "response": "eyJtZXNzYWdlIjogIkFub3RoZXIgU3VjY2VzcyEifQ=="
    }
]
```

Where `TestCase1` and `TestCase2` are the names of the virtual test cases and must be passed in as a header value:

`X-VirtualRequest: TestCase1`

or

`X-VirtualRequest: TestCase2`

The `requestHash` arg is a Sha256(HTTP Request as query parameters or HTTP Body).
The `response` arg is a Base64 encoded format of the response HTTP Body.

So the above plugin equates to these pseudo requests:

```
https://gateway.company.com/virtualtest

POST:
{
   "virtual": "test"
}
Response : {"message": "A Big Success!"} as base64 encoded in plugin

GET:
hello=world&service=virtualized
Response : {"message": "Another Success!"} as base4 encoded in plugin

```

In the event you do not successfully match on request you will receive a Sha256 comparison for you own personal debugging:

```
Status Code: 404 Not Found
Content-Length: 207
Content-Type: application/json; charset=utf-8

{"message":"No virtual request match found, your request yielded: 46c4b4caf0cc3a5a589cbc4e0f3cd0492985d5b889f19ebc11e5a5bd6454d20f expected 0296217561490155228da9c17fc555cf9db82d159732f3206638c25f04a285c4"}
```

If the test case specified in the header does not match anything found stored within the plugin your error would be like so:
Passing `X-VirtualRequest: TestCase3` in header yields:

```
Status Code: 404 Not Found
Content-Length: 49
Content-Type: application/json; charset=utf-8

{"message":"No matching virtual request found!"}
```

### Installation
Recommended:

```bash
$ luarocks install kong-service-virtualization
```

Optional:

```bash
$ git clone https://github.com/Optum/kong-service-virtualization
$ cd /path/to/kong/plugins/kong-service-virtualization
$ luarocks make *.rockspec
```

### Maintainers
[jeremyjpj0916](https://github.com/jeremyjpj0916){:target="_blank"}{:rel="noopener noreferrer"}  
[rsbrisci](https://github.com/rsbrisci){:target="_blank"}{:rel="noopener noreferrer"}  

Feel free to [open issues](https://github.com/Optum/kong-service-virtualization/issues){:target="_blank"}{:rel="noopener noreferrer"}, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-service-virtualization/blob/master/CONTRIBUTING.md){:target="_blank"}{:rel="noopener noreferrer"} if you have any questions.
