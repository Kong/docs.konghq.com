<!---shared with logging plugins --->

This logging plugin logs HTTP request and response data, and also supports stream
data (TCP, TLS, and UDP).

The Kong process error file is the Nginx error file.
You can find it at the following path:

`{prefix}/logs/error.log`

Configure the [prefix](/gateway/latest/reference/configuration/#prefix) in 
`kong.conf`.