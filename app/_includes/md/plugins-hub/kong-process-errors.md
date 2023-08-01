<!---shared with logging plugins --->

This logging plugin logs HTTP request and response data, and also supports stream
data (TCP, TLS, and UDP).

If you are looking for the Kong process error file (which is the Nginx error file),
you can find it at the following path:

`{prefix}/logs/error.log`

Configure the [prefix](/gateway/latest/reference/configuration/#prefix) in 
`kong.conf`.