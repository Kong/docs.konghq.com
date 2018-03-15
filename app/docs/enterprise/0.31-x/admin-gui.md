---
title: Kong Admin GUI
class: page-install-method
---

# Kong Admin GUI

## Access the GUI with SSL enabled
1. **Configure**
  
    The Admin GUI configuration settings in `kong.conf` to enable SSL.

2. **Navigate**
  
    Go to your configured Admin GUI `ip:port` using the https:// protocol.

3. **Confirm** 
  
    If you are using Kong .30 or newer, make sure you check the `admin_listen` parameter in `kong.conf`. This behavior was changed and by default only listens on the local interface 

> Note: If you access the Admin GUI over the `http://` protocol the Admin GUI will not attempt to connect to the Kong Admin API over SSL.
