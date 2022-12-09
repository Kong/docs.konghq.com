---
title: MeshGatewayRoute
---

- `selectors` (required, repeated)

    Selectors is used to match this resource to MeshGateway listener.

- `conf` (required)

    Conf specifies the route configuration.

    Child properties:    
    
    - `udp` (optional)
    
        (Not implemented)
    
        Child properties:    
        
        - `rules` (required, repeated)    
    
    - `tcp` (optional)
    
        (Not implemented)
    
        Child properties:    
        
        - `rules` (required, repeated)    
    
    - `tls` (optional)
    
        (Not implemented)
    
        Child properties:    
        
        - `hostnames` (optional, repeated)
        
            Hostnames lists the server names for which this route is valid. The
            hostnames are matched against the TLS Server Name Indication extension
            send by the client.    
        
        - `rules` (required, repeated)    
    
    - `http` (optional)
    
        Specific a http route
    
        Child properties:    
        
        - `hostnames` (optional, repeated)
        
            Hostnames lists the server names for which this route is valid. The
            hostnames are matched against the TLS Server Name Indication extension
            if this is a TLS session. They are also matched against the HTTP host
            (authority) header in the client's HTTP request.    
        
        - `rules` (required, repeated)
        
            Rules specifies how the gateway should match and process HTTP requests.

