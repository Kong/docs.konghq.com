---
title: Streams and Service Mesh
---


## Introduction

Kong `0.15.0` / `1.0.0` added the capability to proxy and route raw `tcp` and `tls`
streams and deploy Kong using a service-mesh sidecar pattern with mutual
`tls` between Kong nodes. This tutorial walks you trough a basic setup of
a simplified Service Mesh deployment using simple tooling: two servers,
talking with each other via two Kong nodes, in a single host. It introduces
new concepts, configuration settings and tools along the way. In a production
environment, almost all of this should be automated. It is still nice to
know how things work on a lower level. If you are interested in running
Service Mesh with Kubernetes, please head over to our
[Kubernetes and Service Mesh example repo](https://github.com/Kong/kong-mesh-dist-kubernetes).

Kong supports gradual deployment of a sidecar pattern. It can work both as
a traditional gateway and as a service mesh node at the same time. In Kong
the service mesh is built dynamically, and it only exists when there are
active connections between the Kong nodes. In short it means that Kong nodes
do not have to know about other Kong nodes, and services do not have to
know about Kong.


## Prerequisites

You need **Kong 1.1.0 or later** to run through different deployment scenarios
in this tutorial. It is recommended to use Linux distribution to run
the demos, e.g. a recent version of Ubuntu. You will also need some additional
tools to be installed on your system:

- `ncat` (usually comes with `nmap`)
- `iptables` (**Linux**) or `pfctl` (**macOS** / **BSD**)
- `curl`

Your host machine needs to bind `lo0` (or similar) network adapter to these
localhost IPs:

- `127.0.0.1` (**Host C** running **Kong Control Plane**)
- `127.0.0.2` (**Host A** running **Service A**)
- `127.0.0.3` (**Host A** running **Kong A**)
- `127.0.0.4` (**Host B** running **Kong B**)
- `127.0.0.5` (**Host B** running **Service B**)

We are running everything in a single host on this tutorial, but you are allowed
to use two separate nodes to run the demos. In such case, please note that there
will be differences in IP addresses in related commands and configurations.
For the sake of simplicity we also configure everything using just IP addresses
instead of using DNS.

For some of the configuration changes, you may also need **root** privileges on
a target host.


## Terms and Definitions


**Kong Control Plane** is started on network address `127.0.0.1`. It listens on Kong
Admin API on ports `8001` (`http`), and `8444` (`https`), and it won't proxy any traffic.

**Service A** represents an imaginary business entity (microservice, app) making the network
connections to **Service B**. On this tutorial **Service A** is modelled by
direct invocations of `ncat` and `curl`. **Service A**'s network address is `127.0.0.2`.

**Service B** represent a business entity which accepts network connections from **Service A**.
On this tutorial it is implemented via several `ncat` processes, kept open. Its network address
is `127.0.0.5`, and it listens on ports `18000`(`http`), `18443`(`https`), `19000`(`tcp`), and
`19443`(`tls`).

**Kong A** is the sidecar proxy in-front of **Service A**. It listens on network address
`127.0.0.3` on proxy ports `8000` (`http`), `8443` (`https`), `9000` (`tcp`), and `9443` (`tls`).
It does not listen or provide Kong Admin API.

**Kong B** is the sidecar proxy in-front of **Service B**. It listens on network address
`127.0.0.4` on proxy ports `8000` (`http`), `8443` (`https`), `9000` (`tcp`), and `9443` (`tls`).
It does not listen or provide Kong Admin API.

The examples presented here are run directly from a `terminal`, such as `bash` shell.
Please follow each step as it gradually builds the understanding and introduces new
concepts along the way.


## Step 1: Start Service B

As we said before, **Service B** can be modelled as several `ncat` processes. We need
several in order to model all possible Service Mesh combinations.


Start **Service B** listening on TCP traffic:

```
$ ncat --listen \
       --keep-open \
       --verbose \
       --sh-exec "echo 'Hello from Service B (TCP)'" \
       127.0.0.5 19000
```

You should see output similar to one below:

```
Ncat: Version 7.70 ( https://nmap.org/ncat )
Ncat: Listening on 127.0.0.5:19000
```

Leave the command running.


Open a new console and start **Service B** listening on TLS traffic:

```
$ ncat --listen \
       --keep-open \
       --verbose \
       --ssl \
       --sh-exec "echo 'Hello from Service B (TLS)'" \
       127.0.0.5 19443
```

You should see output similar to one below:

```
Ncat: Version 7.70 ( https://nmap.org/ncat )
Ncat: Listening on 127.0.0.5:19443
```

Leave it running.


Open a new console and start **Service B** listening on HTTP traffic:

```
ncat --listen \
     --keep-open \
     --verbose \
     --sh-exec "echo 'HTTP/1.1 200 OK\r\n\r\nHello from Service (HTTP)'" \
     127.0.0.5 18000
```

You should see output similar to one below:

```
Ncat: Version 7.70 ( https://nmap.org/ncat )
Ncat: Listening on 127.0.0.5:18000
```

Again, leave that running.


Open a fourth console and start **Service B** listening on HTTPS traffic:

```
ncat --listen \
     --keep-open \
     --verbose \
     --ssl \
     --sh-exec "echo 'HTTP/1.1 200 OK\r\n\r\nHello from Service B (HTTPS)'" \
     127.0.0.5 18443
```

You should see output similar to one below:

```
Ncat: Version 7.70 ( https://nmap.org/ncat )
Ncat: Listening on 127.0.0.5:18443
```

Leave this command running as well.

At this point you should have four `ncat` processes in 4 consoles,
representing the **Service B** listening with different protocols.


## Step 2: Ensure that Service A can connect Service B

Our **Service A** is just direct invocations of `ncat` and `curl`.


Connect with **Service B** using TCP:

```
ncat --source 127.0.0.2 --recv-only 127.0.0.5 19000
```

You should see output similar to one below:

```
Hello from Service B (TCP)
```


Connect with **Service B** using TLS:

```
ncat --source 127.0.0.2 --recv-only --ssl 127.0.0.5 19443
```

You should see output similar to one below:

```
Hello from Service B (TLS)
```


Connect with **Service B** using HTTP:

```
curl --interface 127.0.0.2 http://127.0.0.5:18000
```

You should see output similar to one below:

```
Hello from Service B (HTTP)
```


Connect with **Service B** using HTTPS:

```
curl --interface 127.0.0.2 --insecure https://127.0.0.5:18443
```

You should see output similar to one below:

```
Hello from Service B (HTTPS)
```

At this point you have **Service B** running at `127.0.0.5` and our
**Service A** at `127.0.0.2` can directly and successfully connect
to it.


## Step 3: Start Kong Control Plane

Start a Kong node that only listens to its Kong Admin API:

```
$ KONG_PREFIX=kong-c \
  KONG_LOG_LEVEL=debug \
  KONG_STREAM_LISTEN="off" \
  KONG_PROXY_LISTEN="off" \
  KONG_ADMIN_LISTEN="127.0.0.1:8001, 127.0.0.1:8444 ssl" \
    kong start
```

You should see this message:

```
Kong started
```


## Step 4: Start Kong A

**Kong A**, will be a Kong instance acting as sidecar for **Service A**.

Start it like this:

```
$ KONG_PREFIX=kong-a \
  KONG_LOG_LEVEL=debug \
  KONG_STREAM_LISTEN="127.0.0.3:9000 transparent, 127.0.0.3:9443 transparent" \
  KONG_PROXY_LISTEN="127.0.0.3:8000 transparent, 127.0.0.3:8443 ssl transparent" \
  KONG_ADMIN_LISTEN="off" \
  KONG_NGINX_PROXY_PROXY_BIND="127.0.0.3" \
  KONG_NGINX_SPROXY_PROXY_BIND="127.0.0.3" \
    kong start
```

On `macOS` / `BSD` use this instead:

```
$ KONG_PREFIX=kong-a \
  KONG_LOG_LEVEL=debug \
  KONG_STREAM_LISTEN="127.0.0.3:9000, 127.0.0.3:9443" \
  KONG_PROXY_LISTEN="127.0.0.3:8000, 127.0.0.3:8443 ssl" \
  KONG_ADMIN_LISTEN="off" \
  KONG_NGINX_PROXY_PROXY_BIND="127.0.0.3" \
  KONG_NGINX_SPROXY_PROXY_BIND="127.0.0.3" \
    kong start
```

You should see this message:

```
Kong started
```


### About the `transparent`  option

The `transparent` listen option makes it possible for Kong to answer requests
mangled with `iptables` `PREROUTING` rules, and to read the original destination
address and the port that client tried to connect before `iptables` rules
did `transparently` proxy it to its sidecar proxy.

**Note:** `transparent` is only supported on `Linux`, and specifying
it may require you to start Kong as a `root` user. If you are **not** running
`Linux` (e.g. `macOS` or `BSD`), the transparent proxying is supported by default.


## Step 5: Start Kong B

**Kong B** will be the sidecar Kong instance for **Service B**.

```
$ KONG_PREFIX=kong-b \
  KONG_LOG_LEVEL=debug \
  KONG_STREAM_LISTEN="127.0.0.4:9000 transparent, 127.0.0.4:9443 transparent" \
  KONG_PROXY_LISTEN="127.0.0.4:8000 transparent, 127.0.0.4:8443 transparent ssl" \
  KONG_ADMIN_LISTEN="off" \
  KONG_NGINX_PROXY_PROXY_BIND="127.0.0.4" \
  KONG_NGINX_SPROXY_PROXY_BIND="127.0.0.4" \
    kong start
```

On `macOS` / `BSD` use this instead:

```
$ KONG_PREFIX=kong-b \
  KONG_LOG_LEVEL=debug \
  KONG_STREAM_LISTEN="127.0.0.4:9000, 127.0.0.4:9443" \
  KONG_PROXY_LISTEN="127.0.0.4:8000, 127.0.0.4:8443 ssl" \
  KONG_ADMIN_LISTEN="off" \
  KONG_NGINX_PROXY_PROXY_BIND="127.0.0.4" \
  KONG_NGINX_SPROXY_PROXY_BIND="127.0.0.4" \
    kong start
```

You should see this message if the Kong node starts successfully:

```
Kong started
```

**Note**: In the real world, you should use `nginx worker user` to make the exceptions
to `iptables` rules (see step 7), but for this simplified demo, we use the `proxy_bind`
for the exceptions on rules.


## Step 6: Create Kong Services and Routes

Create Kong Service for **Service B**'s TCP Traffic:

```
$ curl -X PUT \
       -d url=tcp://127.0.0.5:19000 \
       http://127.0.0.1:8001/services/service-b-tcp
```

Create one Kong Route for that Kong Service:

```
$ curl -X POST \
       -d name=service-b-tcp \
       -d protocols=tcp \
       -d destinations[1].ip=127.0.0.5 \
       -d destinations[1].port=19000 \
       http://127.0.0.1:8001/services/service-b-tcp/routes
```

Create a Kong Service for **Service B**'s TLS Traffic:

```
$ curl -X PUT \
       -d url=tls://127.0.0.5:19443 \
       http://127.0.0.1:8001/services/service-b-tls
```

And one Route for it:

```
$ curl -X POST \
       -d name=service-b-tls \
       -d protocols=tls \
       -d destinations[1].ip=127.0.0.5 \
       -d destinations[1].port=19443 \
       http://127.0.0.1:8001/services/service-b-tls/routes
```

Create a Kong Service for **Service B**'s HTTP Traffic:

```
$ curl -X PUT \
       -d url=http://127.0.0.5:18000 \
       http://127.0.0.1:8001/services/service-b-http
```

Create a Kong Route for this Kong Service as well:

```
$ curl -X POST \
       -d name=service-b-http \
       -d protocols=http \
       -d hosts=127.0.0.5 \
       http://127.0.0.1:8001/services/service-b-http/routes
```

Finally, create a Kong Service for **Service B**'s HTTPS Traffic:

```
$ curl -X PUT \
       -d url=https://127.0.0.5:18443/ \
       http://127.0.0.1:8001/services/service-b-https
```

And a Kong Route to go with it:

```
$ curl -X POST \
       -d name=service-b-https \
       -d protocols=https \
       -d hosts=127.0.0.5 \
       http://127.0.0.1:8001/services/service-b-https/routes
```


## Step 7: Configure Transparent Proxying Rules

Following `iptables` commands add transparent proxying rules for **Service A**.
They make **Service A** to connect **Kong A** instead of connecting to to **Service B**
directly as we saw on Step 2.

Configure `iptables` on **Service A**:

```
$ sudo iptables --insert PREROUTING \
                --table mangle \
                --protocol tcp \
                --dport 19000 \
                --source 127.0.0.2 \
                --jump TPROXY \
                --on-port=9000 \
                --on-ip=127.0.0.3

$ sudo iptables --insert PREROUTING \
                --table mangle \
                --protocol tcp \
                --dport 19443 \
                --source 127.0.0.2 \
                --jump TPROXY \
                --on-port=9443 \
                --on-ip=127.0.0.3

$ sudo iptables --insert PREROUTING \
                --table mangle \
                --protocol tcp \
                --dport 18000 \
                --source 127.0.0.2 \
                --jump TPROXY \
                --on-port=8000 \
                --on-ip=127.0.0.3

$ sudo iptables --insert PREROUTING \
                --table mangle \
                --protocol tcp \
                --dport 18443 \
                --source 127.0.0.2 \
                --jump TPROXY \
                --on-port=8443 \
                --on-ip=127.0.0.3
```

And then configure more rules for intercepting traffic destined for **Service B**, and send
it to **Kong B** instead:

```
$ sudo iptables --append PREROUTING \
                --table mangle \
                --protocol tcp \
                "!" --source 127.0.0.4 \
                --dport 19000 \
                --destination 127.0.0.5 \
                --jump TPROXY \
                --on-port=9000 \
                --on-ip=127.0.0.4

$ sudo iptables --append PREROUTING \
                --table mangle \
                --protocol tcp \
                "!" --source 127.0.0.4 \
                --dport 19443 \
                --destination 127.0.0.5 \
                --jump TPROXY \
                --on-port=9443 \
                --on-ip=127.0.0.4

$ sudo iptables --append PREROUTING \
                --table mangle \
                --protocol tcp \
                "!" --source 127.0.0.4 \
                --dport 18000 \
                --destination 127.0.0.5 \
                --jump TPROXY \
                --on-port=8000 \
                --on-ip=127.0.0.4

$ sudo iptables --append PREROUTING \
                --table mangle \
                --protocol tcp \
                "!" --source 127.0.0.4 \
                --dport 18443 \
                --destination 127.0.0.5 \
                --jump TPROXY \
                --on-port=8443 \
                --on-ip=127.0.0.4
```


The equivalent `TPROXY` rules with `macOS` or `BSDs` is a bit tricky, so we leave that
to the reader. If we find a simple way to define them, we'll update this article.


## Step 8: Start tailing Kong Logs

We do this so that you can view that the requests on next step do pass both **Kong A**
and **Kong B**. Run this command for **Kong A**:

```
$ tail -F kong-a/logs/error.log
```

Leave it running, and in another console, run this command for **Kong B**:

```
$ tail -F kong-b/logs/error.log
```


## Step 9: Connect Service A to Service B using Two Sidecars

Connect from **Service A** to **Service B** using TCP:

```
ncat --source 127.0.0.2 127.0.0.5 19000
```

**Note:** at the moment you need to write around twenty bytes to
the stream with the client to actually receive the response from
the server (we are working on it).

You should see output similar to one below:

```
Hello from Service B (TCP)
```

Connect using TLS:

```
ncat --source 127.0.0.2 --recv-only --ssl 127.0.0.5 19443
```

You should see output similar to one below:

```
Hello from Service B (TLS)
```

Connect using HTTP:

```
curl --interface 127.0.0.2 http://127.0.0.5:18000
```

You should see output similar to one below:

```
Hello from Service B (HTTP)
```

Connect using HTTPS:

```
curl --interface 127.0.0.2 --insecure https://127.0.0.5:18443
```

You should see output similar to one below:

```
Hello from Service B (HTTPS)
```

As you can see, step 9 looks exactly the same as step 2. We did not need to
make any changes to **Service A** or **Service B**, but we introduced a sidecar proxy
to each of them while successfully demonstrating that Kong is capable to proxy
both raw `tcp` and `tls` streams and `http` and `https` traffic.


### About Service Mesh

In Kong we call it Service Mesh only when the connection between the two sidecars,
**Kong A** and **Kong B**, is mutually TLS authenticated. That is not obviously the
case in this document with the `tcp` and `http` demos. But what makes things interesting
is that Kong can automatically update unprotected `tcp` and `http` connections to `tls`
protected connections so that **Kong A** will always talk to **Kong B** using either `tls`
or `https`. And on the other side, **Kong B**, Kong can also downgrade the `tls` and `https`
connections to unprotected `tcp` or `http` before making that final proxy connection
to the local **Service B**. You can adjust these settings by modifying the Service
entities (or adjusting the `KONG_ORIGINS` setting on **Kong B** which we didn't cover
on this tutorial).

## Step 10: Stop Kong Nodes and Cleanup

Cleanup the `iptables` rules:

```
sudo iptables --table mangle --flush PREROUTING
```

Stop **Kong B**:

```
KONG_PREFIX=kong-b kong stop
```

Stop **Kong A**:

```
KONG_PREFIX=kong-a kong stop
```

Stop Kong Control Plane:

```
KONG_PREFIX=kong-c kong stop
```

Stop Tailing Kong Logs:

```
pkill tail
```

Stop Ncat Servers:

```
pkill ncat
```
