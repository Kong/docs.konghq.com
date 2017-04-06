---
title: Linux services templates
---

# Linux services templates

### Table of Contents

- [Systemd service file](#systemd-service-file)

### Systemd service file

On Linux operating systems supporting `systemd`, Kong can be managed as a service

The following file as to be saved as `/etc/systemd/system/kong.service` :
```text
[Unit]
Description=The Kong API Gateway
Documentation=https://getkong.org/
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Restart=always
LimitNOFILE=4096
ExecStart=/usr/local/bin/kong start
ExecReload=/usr/local/bin/kong reload
ExecStop=/usr/local/bin/kong stop
Type=forking
PIDFile=/usr/local/kong/pids/nginx.pid

[Install]
WantedBy=multi-user.target
```

You must run the following commands in order to enable the service :
```
systemctl daemon-reload
systemctl enable kong.service
```


You can start Kong with the `start` command :
```
service kong  start
```

You can start Kong with the `reload` command :
```
service kong  reload
```

You can start Kong with the `restart` command :
```
service kong  restart
```

You can start Kong with the `stop` command :
```
service kong  stop
```

[Back to TOC](#table-of-contents)

##### Requires

If Kong need to start another service before starting itself, `Requires` option can be added in `[Unit]` section :
```text
[Unit]
...
Requires=database.service

[Service]
...
```


[Back to TOC](#table-of-contents)
