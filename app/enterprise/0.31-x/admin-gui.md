---
title: Kong Admin GUI
class: page-install-method
---

# Introduction

## Access the GUI with SSL enabled
1. **Configure**
  
    The Admin GUI configuration settings in `kong.conf` to enable SSL.

2. **Navigate**
  
    Go to your configured Admin GUI `ip:port` using the https:// protocol.

3. **Confirm** 
  
    If you are using Kong 0.30 or newer, make sure that the `admin_listen` configuration value binds to the desired network interface. By default, and for security reasons, this setting binds to the local interface only.

> Note: If you access the Admin GUI over the `http://` protocol the Admin GUI will not attempt to connect to the Kong Admin API over SSL.
