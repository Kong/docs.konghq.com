---
title: HTTP API
---

Kuma ships with a RESTful HTTP interface that you can use to retrieve the state of your configuration and policies on every environment, and when running on Universal mode it will also allow to make changes to the state. On Kubernetes, you will use native CRDs to change the state in order to be consistent with Kubernetes best practices.

{% tip %}
**CI/CD**: The HTTP API can be used for infrastructure automation to either retrieve data, or to make changes when running in Universal mode. The [`kumactl`](/docs/{{ page.version }}/explore/cli) CLI is built on top of the HTTP API, which you can also access with any other HTTP client like `curl`.
{% endtip %}

By default the API Server is listening on port `5681` (HTTP) and on `5682` (HTTPS). The endpoints available are:

* `/config`
* `/versions`
* `/meshes`
* `/mesh-insights`
* `/mesh-insights/{name}`
* `/dataplanes`
* `/dataplanes+insights`
* `/health-checks`
* `/proxytemplates`
* `/traffic-logs`
* `/traffic-permissions`
* `/traffic-routes`
* `/fault-injections`
* `/service-insights`
* `/retries`
* `/secrets`
* `/global-secrets`
* `/global-secrets/{name}`
* `/meshes/{name}`
* `/meshes/{mesh}/dataplanes`
* `/meshes/{mesh}/dataplanes/{name}`
* `/meshes/{mesh}/dataplanes/{name}/policies`
* `/meshes/{mesh}/dataplanes/{name}/xds`
* `/zoneingresses/{name}/xds`
* `/zoneegresses/{name}/xds`
* `/meshes/{mesh}/dataplanes+insights`
* `/meshes/{mesh}/dataplanes+insights/{name}`
* `/meshes/{mesh}/health-checks`
* `/meshes/{mesh}/health-checks/{name}`
* `/meshes/{mesh}/proxytemplates`
* `/meshes/{mesh}/proxytemplates/{name}`
* `/meshes/{mesh}/traffic-logs`
* `/meshes/{mesh}/traffic-logs/{name}`
* `/meshes/{mesh}/traffic-permissions`
* `/meshes/{mesh}/traffic-permissions/{name}`
* `/meshes/{mesh}/traffic-routes`
* `/meshes/{mesh}/traffic-routes/{name}`
* `/meshes/{mesh}/fault-injections`
* `/meshes/{mesh}/fault-injections/{name}`
* `/meshes/{mesh}/{policy-type}/{policy-name}/dataplanes`  
* `/meshes/{mesh}/meshgateways/{gateway-name}/dataplanes`
* `/meshes/{mesh}/external-services`
* `/meshes/{mesh}/external-services/{name}`
* `/meshes/{mesh}/service-insights`
* `/meshes/{mesh}/service-insights/{name}`
* `/meshes/{mesh}/retries`
* `/meshes/{mesh}/retries/{name}`
* `/meshes/{mesh}/secrets`
* `/meshes/{mesh}/secrets/{name}`
* `/status/zones`
* `/tokens/dataplane`
* `/tokens/zone-ingress`
* `/zones`
* `/zones/{name}`
* `/zones+insights`
* `/zones+insights/{name}`
* [`/zone-ingresses`](#list-zone-ingresses)
* [`/zone-ingresses/{name}`](#get-zone-ingress)
* [`/zoneingresses+insights`](#list-zone-ingress-overviews)
* [`/zoneingresses+insights/{name}`](#get-zone-ingress-overview)
* [`/zoneegresses`](#list-zone-egresses)
* [`/zoneegresses/{name}`](#get-zone-egress)
* [`/zoneegressoverviews`](#list-zone-egress-overviews)
* [`/zoneegressoverviews/{name}`](#get-zone-egress-overview)
* `/global-insights`
* [`/policies`](#policies)

You can use `GET` requests to retrieve the state of Kuma on both Universal and Kubernetes, and `PUT` and `DELETE` requests on Universal to change the state.

## Pagination

Every resource list in Kuma is paginated. To use pagination, you can use following query parameters:
* `size` - size of the page (default - 1000, maximum value - 10000).
* `offset` - offset from which the page will be listed. The offset is a `string`, it does not have to be a number (it depends on the environment).

A response with a pagination contains `next` field with URL to fetch the next page. Example:
```json
{
  "items": [...],
  "next": "http://localhost:5681/meshes/default/dataplanes?offset=10"
}
```
If next field is `null` there is no more pages to fetch.

## Control Plane configuration

### Get effective configuration of the Control Plane

Request: `GET /config`

Response: `200 OK` with the effective configuration of the Control Plane (notice that secrets, such as database passwords, will never appear in the response)

Example:
```bash
curl http://localhost:5681/config
```
```json
{
  "adminServer": {
    "apis": {
      "dataplaneToken": {
        "enabled": true
      }
    },
    "local": {
      "port": 5679
    },
    "public": {
      "clientCertsDir": "/etc/kuma.io/kuma-cp/admin-api/tls/allowed-client-certs.d",
      "enabled": true,
      "interface": "0.0.0.0",
      "port": 5684,
      "tlsCertFile": "/etc/kuma.io/kuma-cp/admin-api/tls/server.cert",
      "tlsKeyFile": "/etc/kuma.io/kuma-cp/admin-api/tls/server.key"
    }
  },
  "apiServer": {
    "corsAllowedDomains": [
      ".*"
    ],
    "port": 5681,
    "readOnly": false
  },
  "bootstrapServer": {
    "params": {
      "adminAccessLogPath": "/dev/null",
      "adminAddress": "127.0.0.1",
      "adminPort": 0,
      "xdsConnectTimeout": "1s",
      "xdsHost": "kuma-control-plane.internal",
      "xdsPort": 5678
    },
    "port": 5682
  },
  "dataplaneTokenServer": {
    "enabled": true,
    "local": {
      "port": 5679
    },
    "public": {
      "clientCertsDir": "/etc/kuma.io/kuma-cp/admin-api/tls/allowed-client-certs.d",
      "enabled": true,
      "interface": "0.0.0.0",
      "port": 5684,
      "tlsCertFile": "/etc/kuma.io/kuma-cp/admin-api/tls/server.cert",
      "tlsKeyFile": "/etc/kuma.io/kuma-cp/admin-api/tls/server.key"
    }
  },
  "defaults": {
    "mesh": "type: Mesh\nname: default"
  },
  "discovery": {
    "universal": {
      "pollingInterval": "1s"
    }
  },
  "environment": "universal",
  "general": {
    "advertisedHostname": "kuma-control-plane.internal"
  },
  "guiServer": {
  },
  "monitoringAssignmentServer": {
    "assignmentRefreshInterval": "1s",
    "grpcPort": 5676
  },
  "reports": {
    "enabled": true
  },
  "runtime": {
    "kubernetes": {
      "admissionServer": {
        "address": "",
        "certDir": "",
        "port": 5443
      }
    }
  },
  "sdsServer": {
    "grpcPort": 5677,
    "tlsCertFile": "/tmp/117637813.crt",
    "tlsKeyFile": "/tmp/240596112.key"
  },
  "store": {
    "kubernetes": {
      "systemNamespace": "kuma-system"
    },
    "postgres": {
      "connectionTimeout": 5,
      "dbName": "kuma",
      "host": "127.0.0.1",
      "password": "*****",
      "port": 15432,
      "user": "kuma"
    },
    "type": "memory"
  },
  "xdsServer": {
    "dataplaneConfigurationRefreshInterval": "1s",
    "dataplaneStatusFlushInterval": "1s",
    "diagnosticsPort": 5680,
    "grpcPort": 5678
  }
}
```

## Supported Envoy versions

### List supported Envoy versions

Request: `GET /versions`

Response: `200 OK` with versions of Envoy supported by Kuma DPs

Example:
```bash
curl http://localhost:5681/versions
```
```json
{
  "kumaDp": {
    "1.0.0": {
      "envoy": "1.16.0"
    },
    "1.0.1": {
      "envoy": "1.16.0"
    },
    "1.0.2": {
      "envoy": "1.16.1"
    },
    "1.0.3": {
      "envoy": "1.16.1"
    },
    "1.0.4": {
      "envoy": "1.16.1"
    },
    "1.0.5": {
      "envoy": "1.16.2"
    },
    "1.0.6": {
      "envoy": "1.16.2"
    },
    "1.0.7": {
      "envoy": "1.16.2"
    },
    "1.0.8": {
      "envoy": "1.16.2"
    }
  }
}
```

## Meshes

### Get Mesh
Request: `GET /meshes/{name}`

Response: `200 OK` with Mesh entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1
```
```json
{
  "name": "mesh-1",
  "type": "Mesh",
  "creationTime": "2020-05-12T12:31:45.606217+02:00",
  "modificationTime": "2020-05-12T12:31:45.606217+02:00",
  "mtls": {
    "backends": [
      {
        "name": "ca-1",
        "type": "builtin"
      },
      {
        "name": "ca-2",
        "type": "provided",
        "conf": {
          "cert": {
            "secret": "provided-cert"
          },
          "key": {
            "secret": "provided-cert"
          }
        }
      }
    ],
    "enabledBackend": "ca-1"
  },
  "tracing": {
    "defaultBackend": "zipkin-1",
    "backends": [
      {
        "name": "zipkin-1",
        "type": "zipkin",
        "conf": {
          "url": "http://zipkin.local:9411/api/v2/spans"
        }
      }
    ]
  },
  "logging": {
    "backends": [
      {
        "name": "file-tmp",
        "format": "{ \"destination\": \"%KUMA_DESTINATION_SERVICE%\", \"destinationAddress\": \"%UPSTREAM_LOCAL_ADDRESS%\", \"source\": \"%KUMA_SOURCE_SERVICE%\", \"sourceAddress\": \"%KUMA_SOURCE_ADDRESS%\", \"bytesReceived\": \"%BYTES_RECEIVED%\", \"bytesSent\": \"%BYTES_SENT%\"}",
        "type": "file",
        "conf": {
          "path": "/tmp/access.log"
        }
      },
      {
        "name": "logstash",
        "type": "tcp",
        "conf": {
          "address": "logstash.internal:9000"
        }
      }
    ]
  },
  "metrics": {
    "enabledBackend": "prometheus-1",
    "backends": [
      {
        "name": "prometheus-1",
        "type": "prometheus",
        "conf": {
          "port": 1234,
          "path": "/metrics"
        }
      } 
    ]
  }
}
```

### Create/Update Mesh
Request: `PUT /meshes/{name}` with Mesh entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1 --data @mesh.json -H'content-type: application/json'
```
```json
{
  "name": "mesh-1",
  "type": "Mesh",
  "mtls": {
    "backends": [
      {
        "name": "ca-1",
        "type": "builtin"
      },
      {
        "name": "ca-2",
        "type": "provided",
        "conf": {
          "cert": {
            "secret": "provided-cert"
          },
          "key": {
            "secret": "provided-cert"
          }
        }
      }
    ],
    "enabledBackend": "ca-1"
  },
  "tracing": {
    "defaultBackend": "zipkin-1",
    "backends": [
      {
        "name": "zipkin-1",
        "type": "zipkin",
        "conf": {
          "url": "http://zipkin.local:9411/api/v2/spans"
        }
      }
    ]
  },
  "logging": {
    "backends": [
      {
        "name": "file-tmp",
        "format": "{ \"destination\": \"%KUMA_DESTINATION_SERVICE%\", \"destinationAddress\": \"%UPSTREAM_LOCAL_ADDRESS%\", \"source\": \"%KUMA_SOURCE_SERVICE%\", \"sourceAddress\": \"%KUMA_SOURCE_ADDRESS%\", \"bytesReceived\": \"%BYTES_RECEIVED%\", \"bytesSent\": \"%BYTES_SENT%\"}",
        "type": "file",
        "conf": {
          "path": "/tmp/access.log"
        }
      },
      {
        "name": "logstash",
        "type": "tcp",
        "conf": {
          "address": "logstash.internal:9000"
        }
      }
    ]
  },
  "metrics": {
    "enabledBackend": "prometheus-1",
    "backends": [
      {
        "name": "prometheus-1",
        "type": "prometheus",
        "conf": {

          "port": 1234,
          "path": "/metrics"
        }
      } 
    ]
  }
}
```

### List Meshes
Request: `GET /meshes`

Response: `200 OK` with body of Mesh entities

Example:
```bash
curl http://localhost:5681/meshes
```
```json
{
  "items": [
    {
      "name": "mesh-1",
      "type": "Mesh",
      "creationTime": "2020-05-12T12:31:45.606217+02:00",
      "modificationTime": "2020-05-12T12:31:45.606217+02:00",
      "mtls": {
        "backends": [
          {
            "name": "ca-1",
            "type": "builtin"
          },
          {
            "name": "ca-2",
            "type": "provided",
            "conf": {
              "cert": {
                "secret": "provided-cert"
              },
              "key": {
                "secret": "provided-cert"
              }
            }
          }
        ],
        "enabledBackend": "ca-1"
      },
      "tracing": {
        "defaultBackend": "zipkin-1",
        "backends": [
          {
            "name": "zipkin-1",
            "type": "zipkin",
            "conf": {
              "url": "http://zipkin.local:9411/api/v2/spans"
            }
          }
        ]
      },
      "logging": {
        "backends": [
          {
            "name": "file-tmp",
            "format": "{ \"destination\": \"%KUMA_DESTINATION_SERVICE%\", \"destinationAddress\": \"%UPSTREAM_LOCAL_ADDRESS%\", \"source\": \"%KUMA_SOURCE_SERVICE%\", \"sourceAddress\": \"%KUMA_SOURCE_ADDRESS%\", \"bytesReceived\": \"%BYTES_RECEIVED%\", \"bytesSent\": \"%BYTES_SENT%\"}",
            "type": "file",
            "conf": {
              "path": "/tmp/access.log"
            }
          },
          {
            "name": "logstash",
            "type": "tcp",
            "conf": {
              "address": "logstash.internal:9000"
            }
          }
        ]
      },
      "metrics": {
        "enabledBackend": "prometheus-1",
        "backends": [
          {
            "name": "prometheus-1",
            "type": "prometheus",
            "conf": {
              "port": 1234,
              "path": "/metrics"
            }
          } 
        ]
      }
    }
  ],
  "next": "http://localhost:5681/meshes?offset=1"
}
```

### Delete Mesh
Request: `DELETE /meshes/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1
```

## Mesh Insights

### Get Mesh Insights
Request: `GET /mesh-insights/{name}`

Response: `200 OK` with MeshInsight entity

Example:
```bash
curl http://localhost:5681/mesh-insights/default
```
```json
{
 "type": "MeshInsight",
 "name": "default",
 "creationTime": "2020-11-17T08:10:24.886346Z",
 "modificationTime": "2020-11-17T19:21:39.912878Z",
 "lastSync": "2020-11-17T12:21:39.912877Z",
 "dataplanes": {
  "total": 4,
  "offline": 2,
  "partiallyDegraded": 2
 },
 "dataplanesByType": {
  "standard": {
   "total": 2,
   "offline": 1,
   "partiallyDegraded": 1
  },
  "gateway": {
   "total": 2,
   "offline": 1,
   "partiallyDegraded": 1
  }
 },
 "policies": {
  "Secret": {
   "total": 1
  },
  "TrafficPermission": {
   "total": 1
  },
  "TrafficRoute": {
   "total": 1
  }
 },
 "dpVersions": {
  "kumaDp": {
   "1.0.0-rc2-119-g50e35395": {
    "total": 1,
    "online": 1,
    "partiallyDegraded": 1
   },
   "1.0.4": {
    "total": 1,
    "online": 1,
    "partiallyDegraded": 1
   },
   "unknown": {
    "total": 1,
    "online": 1,
    "partiallyDegraded": 1
   }
  },
  "envoy": {
   "1.15.0": {
    "total": 2,
    "online": 2,
    "partiallyDegraded": 1
   },
   "unknown": {
    "total": 1,
    "online": 1,
    "partiallyDegraded": 1
   }
  }
 },
 "mTLS": {
   "issuedBackends": {
     "ca-1": {
       "total": 1,
       "online": 1,
       "partiallyDegraded": 1
     }
   },
   "supportedBackends": {
     "ca-1": {
       "total": 1,
       "online": 1,
       "partiallyDegraded": 1
     }
   }
 },
 "services": {
  "total": 3,
  "internal": 2,
  "external": 1
 }
}
```

### List Mesh Insights
Request: `GET /mesh-insights`

Response: `200 OK` with body of Mesh Insight entities

Example:
```bash
curl http://localhost:5681/mesh-insights
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "MeshInsight",
   "name": "default",
   "creationTime": "0001-01-01T00:00:00Z",
   "modificationTime": "0001-01-01T00:00:00Z",
   "lastSync": "2020-11-17T12:24:11.905350Z",
   "dataplanes": {
    "total": 4,
    "offline": 2,
    "partiallyDegraded": 2
   },
   "dataplanesByType": {
    "standard": {
     "total": 2,
     "offline": 1,
     "partiallyDegraded": 1
    },
    "gateway": {
     "total": 2,
     "offline": 1,
     "partiallyDegraded": 1
    }
   },
   "policies": {
    "Secret": {
     "total": 1
    },
    "TrafficPermission": {
     "total": 1
    },
    "TrafficRoute": {
     "total": 1
    }
   },
   "dpVersions": {
    "kumaDp": {
     "1.0.0-rc2-119-g50e35395": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     },
     "1.0.4": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     },
     "unknown": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     }
    },
    "envoy": {
     "1.15.0": {
      "total": 2,
      "online": 2,
      "partiallyDegraded": 1
     },
     "unknown": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     }
    }
   },
   "mTLS": {
     "issuedBackends": {
       "ca-1": {
         "total": 1,
         "online": 1,
         "partiallyDegraded": 1
       }
     },
     "supportedBackends": {
       "ca-1": {
         "total": 1,
         "online": 1,
         "partiallyDegraded": 1
       }
     }
   }, 
   "services": {
    "total": 3,
    "internal": 2,
    "external": 1
   }
  },
  {
   "type": "MeshInsight",
   "name": "mymesh1",
   "creationTime": "0001-01-01T00:00:00Z",
   "modificationTime": "0001-01-01T00:00:00Z",
   "lastSync": "2020-11-17T12:24:11.941534Z",
   "dataplanes": {
    "total": 4,
    "offline": 2,
    "partiallyDegraded": 2
   },
   "dataplanesByType": {
    "standard": {
     "total": 2,
     "offline": 1,
     "partiallyDegraded": 1
    },
    "gateway": {
     "total": 2,
     "offline": 1,
     "partiallyDegraded": 1
    }
   },
   "policies": {
    "Secret": {
     "total": 1
    },
    "TrafficPermission": {
     "total": 1
    },
    "TrafficRoute": {
     "total": 1
    }
   },
   "dpVersions": {
    "kumaDp": {
     "1.0.0-rc2-119-g50e35395": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     },
     "1.0.4": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     },
     "unknown": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     }
    },
    "envoy": {
     "1.15.0": {
      "total": 2,
      "online": 2,
      "partiallyDegraded": 1
     },
     "unknown": {
      "total": 1,
      "online": 1,
      "partiallyDegraded": 1
     }
    }
   },
   "mTLS": {
     "issuedBackends": {
       "ca-1": {
         "total": 1,
         "online": 1,
         "partiallyDegraded": 1
       }
     },
     "supportedBackends": {
       "ca-1": {
         "total": 1,
         "online": 1,
         "partiallyDegraded": 1
       }
     }
   },
   "services": {
    "total": 3,
    "internal": 2,
    "external": 1
   }
  }
 ],
 "next": null
}
```

## Dataplanes

### Get Dataplane
Request: `GET /meshes/{mesh}/dataplanes/{name}`

Response: `200 OK` with Mesh entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/dataplanes/backend-1
```
```json
{
  "type": "Dataplane",
  "name": "backend-1",
  "mesh": "mesh-1",
  "creationTime": "2020-05-12T12:31:45.606217+02:00",
  "modificationTime": "2020-05-12T12:31:45.606217+02:00",
  "networking": {
    "address": "127.0.0.1",
    "inbound": [
      {
        "port": 11011,
        "servicePort": 11012,
        "tags": {
          "service": "backend",
          "version": "2.0",
          "env": "production"
        }
      }
    ],
    "outbound": [
      {
        "port": 33033,
        "service": "database"
      },
      {
        "port": 44044,
        "service": "user"
      }
    ]
  }
}
```

### Create/Update Dataplane
Request: `PUT /meshes/{mesh}/dataplanes/{name}` with Dataplane entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/dataplanes/backend-1 --data @dataplane.json -H'content-type: application/json'
```
```json
{
  "type": "Dataplane",
  "name": "backend-1",
  "mesh": "mesh-1",
  "networking": {
    "address": "127.0.0.1",
    "inbound": [
      {
        "port": 11011,
        "servicePort": 11012,
        "tags": {
          "kuma.io/service": "backend",
          "version": "2.0",
          "env": "production"
        }
      }
    ],
    "outbound": [
      {
        "port": 33033,
        "tags": {
          "kuma.io/service": "database"
        }
      },
      {
        "port": 44044,
        "tags": {
          "kuma.io/service": "user"
        }
      }
    ]
  }
}
```

### List Dataplanes
Request: `GET /meshes/{mesh}/dataplanes`

Response: `200 OK` with body of Dataplane entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/dataplanes
```
```json
{
  "items": [
    {
      "type": "Dataplane",
      "name": "backend-1",
      "mesh": "mesh-1",
      "creationTime": "2020-05-12T12:31:45.606217+02:00",
      "modificationTime": "2020-05-12T12:31:45.606217+02:00",
      "networking": {
        "address": "127.0.0.1",
        "inbound": [
          {
            "port": 11011,
            "servicePort": 11012,
            "tags": {
              "kuma.io/service": "backend",
              "version": "2.0",
              "env": "production"
            }
          }
        ],
        "outbound": [
          {
            "port": 33033,
            "tags": {
              "kuma.io/service": "database"
            }
          },
          {
            "port": 44044,
            "tags": {
              "kuma.io/service": "user"
            }
          }
        ]
      }
    }
  ],
  "next": "http://localhost:5681/meshes/mesh-1/dataplanes?offset=1"
}
```

### Delete Dataplane
Request: `DELETE /meshes/{mesh}/dataplanes/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/dataplanes/backend-1
```

## Dataplane Overviews

### Get Dataplane Overview
Request: `GET /meshes/{mesh}/dataplane+insights/{name}`

Response: `200 OK` with Dataplane entity including insight

Example:
```bash
curl http://localhost:5681/meshes/default/dataplanes+insights/example
```
```json
{
 "type": "DataplaneOverview",
 "mesh": "default",
 "name": "example",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "dataplane": {
  "networking": {
   "address": "127.0.0.1",
   "inbound": [
    {
     "port": 11011,
     "servicePort": 11012,
     "tags": {
      "env": "production",
      "kuma.io/service": "backend",
      "version": "2.0"
     }
    }
   ],
   "outbound": [
    {
     "port": 33033,
     "tags": {
      "kuma.io/service": "database"
     }
    }
   ]
  }
 },
 "dataplaneInsight": {
  "mTLS": {
    "certificateExpirationTime": "2019-10-24T14:04:57.832482Z", 
    "lastCertificateRegeneration": "2019-10-24T12:04:57.832482Z",
    "certificateRegenerations": 3,
    "issuedBackend": "ca-1",
    "supportedBackends": ["ca-1"]
  },
  "subscriptions": [
   {
    "id": "426fe0d8-f667-11e9-b081-acde48001122",
    "controlPlaneInstanceId": "06070748-f667-11e9-b081-acde48001122",
    "connectTime": "2019-10-24T14:04:56.820350Z",
    "status": {
     "lastUpdateTime": "2019-10-24T14:04:57.832482Z",
     "total": {
      "responsesSent": "3",
      "responsesAcknowledged": "3"
     },
     "cds": {
      "responsesSent": "1",
      "responsesAcknowledged": "1"
     },
     "eds": {
      "responsesSent": "1",
      "responsesAcknowledged": "1"
     },
     "lds": {
      "responsesSent": "1",
      "responsesAcknowledged": "1"
     },
     "rds": {}
    }
   }
  ]
 }
}
```

### List Dataplane Overviews
Request: `GET /meshes/{mesh}/dataplane+insights/`

Response: `200 OK` with Dataplane entities including insight

Example:
```bash
curl http://localhost:5681/meshes/default/dataplanes+insights
```
```json
{
  "items": [
    {
     "type": "DataplaneOverview",
     "mesh": "default",
     "name": "example",
     "creationTime": "2020-05-12T12:31:45.606217+02:00",
     "modificationTime": "2020-05-12T12:31:45.606217+02:00",
     "dataplane": {
      "networking": {
       "address": "127.0.0.1",
       "inbound": [
        {
         "port": 11011,
         "servicePort": 11012,
         "tags": {
          "env": "production",
          "kuma.io/service": "backend",
          "version": "2.0"
         }
        }
       ],
       "outbound": [
        {
         "port": 33033,
         "tags": {
          "kuma.io/service": "database"
         }
        }
       ]
      }
     },
     "dataplaneInsight": {
      "mTLS": {
        "certificateExpirationTime": "2019-10-24T14:04:57.832482Z",
        "lastCertificateRegeneration": "2019-10-24T12:04:57.832482Z",
        "certificateRegenerations": 3,
        "issuedBackend": "ca-1",
        "supportedBackends": ["ca-1"]
      },
      "subscriptions": [
       {
        "id": "426fe0d8-f667-11e9-b081-acde48001122",
        "controlPlaneInstanceId": "06070748-f667-11e9-b081-acde48001122",
        "connectTime": "2019-10-24T14:04:56.820350Z",
        "status": {
         "lastUpdateTime": "2019-10-24T14:04:57.832482Z",
         "total": {
          "responsesSent": "3",
          "responsesAcknowledged": "3"
         },
         "cds": {
          "responsesSent": "1",
          "responsesAcknowledged": "1"
         },
         "eds": {
          "responsesSent": "1",
          "responsesAcknowledged": "1"
         },
         "lds": {
          "responsesSent": "1",
          "responsesAcknowledged": "1"
         },
         "rds": {}
        }
       }
      ]
     }
    }
  ],
  "total": 2,
  "next": "http://localhost:5681/meshes/default/dataplanes+insights?offset=1"
}
```

## Health Check

### Get Health Check
Request: `GET /meshes/{mesh}/health-checks/{name}`

Response: `200 OK` with Health Check entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/health-checks/web-to-backend
```
```json
{
 "type": "HealthCheck",
 "mesh": "mesh-1",
 "name": "web-to-backend",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "sources": [
  {
   "match": {
    "kuma.io/service": "web"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "interval": "10s",
  "timeout": "2s",
  "unhealthyThreshold": 3,
  "healthyThreshold": 1,
  "reuseConnection": false,
  "tcp": {
   "send": "Zm9v",
   "receive": [
    "YmFy",
    "YmF6"
   ]
  },
  "http": {
   "path": "/health",
   "requestHeadersToAdd": [
    {
     "append": false,
     "header": {
      "key": "Content-Type",
      "value": "application/json"
     }
    },
    {
     "header": {
      "key": "Accept",
      "value": "application/json"
     }
    }
   ],
   "expectedStatuses": [
    200,
    201
   ],
   "useHttp1": true
  }
 }
}
```

### Create/Update Health Check
Request: `PUT /meshes/{mesh}/health-checks/{name}` with Health Check entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/health-checks/web-to-backend --data @healthcheck.json -H'content-type: application/json'
```
```json
{
 "type": "HealthCheck",
 "mesh": "mesh-1",
 "name": "web-to-backend",
 "sources": [
  {
   "match": {
    "kuma.io/service": "web"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "interval": "10s",
  "timeout": "2s",
  "unhealthyThreshold": 3,
  "healthyThreshold": 1,
  "reuseConnection": false,
  "tcp": {
   "send": "Zm9v",
   "receive": [
    "YmFy",
    "YmF6"
   ]
  },
  "http": {
   "path": "/health",
   "requestHeadersToAdd": [
    {
     "append": false,
     "header": {
      "key": "Content-Type",
      "value": "application/json"
     }
    },
    {
     "header": {
      "key": "Accept",
      "value": "application/json"
     }
    }
   ],
   "expectedStatuses": [
    200,
    201
   ],
   "useHttp1": true
  }
 }
}
```

### List Health Checks
Request: `GET /meshes/{mesh}/health-checks`

Response: `200 OK` with body of Health Check entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/health-checks
```
```json
{
 "items": [
  {
   "type": "HealthCheck",
   "mesh": "mesh-1",
   "name": "web-to-backend",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "sources": [
    {
     "match": {
      "kuma.io/service": "web"
     }
    }
   ],
   "destinations": [
    {
     "match": {
      "kuma.io/service": "backend"
     }
    }
   ],
   "conf": {
    "interval": "10s",
    "timeout": "2s",
    "unhealthyThreshold": 3,
    "healthyThreshold": 1,
    "reuseConnection": false,
    "tcp": {
     "send": "Zm9v",
     "receive": [
      "YmFy",
      "YmF6"
     ]
    },
    "http": {
     "path": "/health",
     "requestHeadersToAdd": [
      {
       "append": false,
       "header": {
        "key": "Content-Type",
        "value": "application/json"
       }
      },
      {
       "header": {
        "key": "Accept",
        "value": "application/json"
       }
      }
     ],
     "expectedStatuses": [
      200,
      201
     ],
     "useHttp1": true
    }
   }
  }
 ],
 "next": "http://localhost:5681/meshes/mesh-1/health-checks?offset=1"
}
```

### Delete Health Check
Request: `DELETE /meshes/{mesh}/health-checks/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/health-checks/web-to-backend
```

## Proxy Template

### Get Proxy Template
Request: `GET /meshes/{mesh}/proxytemplates/{name}`

Response: `200 OK` with Proxy Template entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/proxytemplates/pt-1
```
```json
{
 "type": "ProxyTemplate",
 "mesh": "mesh-1",
 "name": "pt-1",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "selectors": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "imports": [
   "default-proxy"
  ],
  "resources": [
   {
    "name": "raw-name",
    "version": "raw-version",
    "resource": "'@type': type.googleapis.com/envoy.api.v2.Cluster\nconnectTimeout: 5s\nloadAssignment:\n  clusterName: localhost:8443\n  endpoints:\n    - lbEndpoints:\n        - endpoint:\n            address:\n              socketAddress:\n                address: 127.0.0.1\n                portValue: 8443\nname: localhost:8443\ntype: STATIC\n"
   }
  ]
 }
}
```

### Create/Update Proxy Template
Request: `PUT /meshes/{mesh}/proxytemplates/{name}` with Proxy Template entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/proxytemplates/pt-1 --data @proxytemplate.json -H'content-type: application/json'
```
```json
{
  "type": "ProxyTemplate",
  "name": "pt-1",
  "mesh": "mesh-1",
  "selectors": [
    {
      "match": {
          "kuma.io/service": "backend"
      }
    }
  ],
  "conf": {
    "imports": [
      "default-proxy"
    ],
    "resources": [
      {
        "name": "raw-name",
        "version": "raw-version",
        "resource": "'@type': type.googleapis.com/envoy.api.v2.Cluster\nconnectTimeout: 5s\nloadAssignment:\n  clusterName: localhost:8443\n  endpoints:\n    - lbEndpoints:\n        - endpoint:\n            address:\n              socketAddress:\n                address: 127.0.0.1\n                portValue: 8443\nname: localhost:8443\ntype: STATIC\n"
      }
    ]
  }
}
```

### List Proxy Templates
Request: `GET /meshes/{mesh}/proxytemplates`

Response: `200 OK` with body of Proxy Template entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/proxytemplates
```
```json
{
 "items": [
  {
   "type": "ProxyTemplate",
   "mesh": "mesh-1",
   "name": "pt-1",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "selectors": [
    {
     "match": {
      "kuma.io/service": "backend"
     }
    }
   ],
   "conf": {
    "imports": [
     "default-proxy"
    ],
    "resources": [
     {
      "name": "raw-name",
      "version": "raw-version",
      "resource": "'@type': type.googleapis.com/envoy.api.v2.Cluster\nconnectTimeout: 5s\nloadAssignment:\n  clusterName: localhost:8443\n  endpoints:\n    - lbEndpoints:\n        - endpoint:\n            address:\n              socketAddress:\n                address: 127.0.0.1\n                portValue: 8443\nname: localhost:8443\ntype: STATIC\n"
     }
    ]
   }
  }
 ],
 "next": "http://localhost:5681/meshes/mesh-1/proxytemplates?offset=1"
}
```

### Delete Proxy Template
Request: `DELETE /meshes/{mesh}/proxytemplates/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/proxytemplates/pt-1
```

## Traffic Permission

### Get Traffic Permission
Request: `GET /meshes/{mesh}/traffic-permissions/{name}`

Response: `200 OK` with Traffic Permission entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-permissions/tp-1
```
```json
{
 "type": "TrafficPermission",
 "mesh": "mesh-1",
 "name": "tp-1",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "sources": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "kuma.io/service": "redis"
   }
  }
 ]
}
```

### Create/Update Traffic Permission
Request: `PUT /meshes/{mesh}/trafficpermissions/{name}` with Traffic Permission entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/traffic-permissions/tp-1 --data @trafficpermission.json -H'content-type: application/json'
```
```json
{
  "type": "TrafficPermission",
  "name": "tp-1",
  "mesh": "mesh-1",
  "sources": [
    {
      "match": {
        "kuma.io/service": "backend"
      }
    }
  ],
  "destinations": [
    {
      "match": {
        "kuma.io/service": "redis"
      }
    }
  ]
}
```

### List Traffic Permissions
Request: `GET /meshes/{mesh}/traffic-permissions`

Response: `200 OK` with body of Traffic Permission entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-permissions
```
```json
{
 "items": [
  {
   "type": "TrafficPermission",
   "mesh": "mesh-1",
   "name": "tp-1",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "sources": [
    {
     "match": {
      "kuma.io/service": "backend"
     }
    }
   ],
   "destinations": [
    {
     "match": {
      "kuma.io/service": "redis"
     }
    }
   ]
  }
 ],
 "next": "http://localhost:5681/meshes/mesh-1/traffic-permissions?offset=1"
}
```

### Delete Traffic Permission
Request: `DELETE /meshes/{mesh}/traffic-permissions/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/traffic-permissions/pt-1
```

## Traffic Log

### Get Traffic Log
Request: `GET /meshes/{mesh}/traffic-logs/{name}`

Response: `200 OK` with Traffic Log entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-logs/tl-1
```
```json
{
 "type": "TrafficLog",
 "mesh": "mesh-1",
 "name": "tl-1",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "sources": [
  {
   "match": {
    "kuma.io/service": "web",
    "version": "1.0"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "backend": "file"
 }
}
```

### Create/Update Traffic Log
Request: `PUT /meshes/{mesh}/traffic-logs/{name}` with Traffic Log entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/traffic-logs/tl-1 --data @trafficlog.json -H'content-type: application/json'
```
```json
{
  "type": "TrafficLog",
  "mesh": "mesh-1",
  "name": "tl-1",
  "sources": [
    {
      "match": {
        "kuma.io/service": "web",
        "version": "1.0"
      }
    }
  ],
  "destinations": [
    {
      "match": {
        "kuma.io/service": "backend"
      }
    }
  ],
  "conf": {
    "backend": "file"
  }
}
```

### List Traffic Logs
Request: `GET /meshes/{mesh}/traffic-logs`

Response: `200 OK` with body of Traffic Log entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-logs
```
```json
{
 "items": [
  {
   "type": "TrafficLog",
   "mesh": "mesh-1",
   "name": "tl-1",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "sources": [
    {
     "match": {
      "kuma.io/service": "web",
      "version": "1.0"
     }
    }
   ],
   "destinations": [
    {
     "match": {
      "kuma.io/service": "backend"
     }
    }
   ],
   "conf": {
    "backend": "file"
   }
  }
 ],
 "next": "http://localhost:5681/meshes/mesh-1/traffic-logs?offset=1"
}
```

### Delete Traffic Log
Request: `DELETE /meshes/{mesh}/traffic-logs/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/traffic-logs/tl-1
```

## Traffic Route

### Get Traffic Route
Request: `GET /meshes/{mesh}/traffic-routes/{name}`

Response: `200 OK` with Traffic Route entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-routes/web-to-backend
```
```json
{
 "type": "TrafficRoute",
 "mesh": "mesh-1",
 "name": "web-to-backend",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "sources": [
  {
   "match": {
    "region": "us-east-1",
    "kuma.io/service": "web",
    "version": "v10"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "split": [
    {
     "weight": 90,
     "destination": {
      "region": "us-east-1",
      "kuma.io/service": "backend",
      "version": "v2"
     }
    },
    {
     "weight": 10,
     "destination": {
      "kuma.io/service": "backend",
      "version": "v3"
     }
    }
   ]
 }
}
```

### Create/Update Traffic Route
Request: `PUT /meshes/{mesh}/traffic-routes/{name}` with Traffic Route entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/traffic-routes/web-to-backend --data @trafficroute.json -H'content-type: application/json'
```
```json
{
 "type": "TrafficRoute",
 "name": "web-to-backend",
 "mesh": "mesh-1",
 "sources": [
  {
   "match": {
    "region": "us-east-1",
    "kuma.io/service": "web",
    "version": "v10"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
    "split": [
    {
     "weight": 90,
     "destination": {
      "region": "us-east-1",
      "kuma.io/service": "backend",
      "version": "v2"
     }
    },
    {
     "weight": 10,
     "destination": {
      "kuma.io/service": "backend",
      "version": "v3"
     }
    }
   ]
 }
}
```

### List Traffic Routes
Request: `GET /meshes/{mesh}/traffic-routes`

Response: `200 OK` with body of Traffic Route entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-routes
```
```json
{
 "items": [
  {
   "type": "TrafficRoute",
   "mesh": "mesh-1",
   "name": "web-to-backend",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "sources": [
    {
     "match": {
      "region": "us-east-1",
      "kuma.io/service": "web",
      "version": "v10"
     }
    }
   ],
   "destinations": [
    {
     "match": {
      "kuma.io/service": "backend"
     }
    }
   ],
   "conf": {
    "split": [
       {
        "weight": 90,
        "destination": {
         "region": "us-east-1",
         "kuma.io/service": "backend",
         "version": "v2"
        }
       },
       {
        "weight": 10,
        "destination": {
         "kuma.io/service": "backend",
         "version": "v3"
        }
       }
    ]
   }
  }
 ],
 "next": "http://localhost:5681/meshes/mesh-1/traffic-routes?offset=1"
}
```

### Delete Traffic Route
Request: `DELETE /meshes/{mesh}/traffic-routes/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/traffic-routes/web-to-backend
```

## Traffic Trace

### Get Traffic Trace
Request: `GET /meshes/{mesh}/traffic-traces/{name}`

Response: `200 OK` with Traffic Trace entity

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-traces/tt-1
```
```json
{
 "type": "TrafficTrace",
 "mesh": "mesh-1",
 "name": "tt-1",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "conf": {
  "backend": "my-zipkin"
 },
 "selectors": [
  {
   "match": {
    "kuma.io/service": "*"
   }
  }
 ]
}
```

### Create/Update Traffic Trace
Request: `PUT /meshes/{mesh}/traffic-traces/{name}` with Traffic Trace entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/mesh-1/traffic-traces/tt-1 --data @traffictrace.json -H'content-type: application/json'
```
```json
{
 "type": "TrafficTrace",
 "mesh": "mesh-1",
 "name": "tt-1",
 "conf": {
  "backend": "my-zipkin"
 },
 "selectors": [
  {
   "match": {
    "kuma.io/service": "*"
   }
  }
 ]
}
```

### List Traffic Traces
Request: `GET /meshes/{mesh}/traffic-traces`

Response: `200 OK` with body of Traffic Trace entities

Example:
```bash
curl http://localhost:5681/meshes/mesh-1/traffic-traces
```
```json
{
 "items": [
  {
   "type": "TrafficTrace",
   "mesh": "mesh-1",
   "name": "tt-1",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "selectors": [
    {
     "match": {
      "kuma.io/service": "*"
     }
    }
   ],
   "conf": {
    "backend": "my-zipkin"
   }
  }
 ],
 "next": "http://localhost:5681/meshes/mesh-1/traffic-traces?offset=1"
}
```

### Delete Traffic Trace
Request: `DELETE /meshes/{mesh}/traffic-traces/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/mesh-1/traffic-traces/tt-1
```

## Fault Injection

### Get Fault Injection
Request: `GET /meshes/{mesh}/fault-injections/{name}`

Response: `200 OK` with Fault Injection entity

Example:
```bash
curl http://localhost:5681/meshes/default/fault-injections/fi1
```
```json
{
 "type": "FaultInjection",
 "mesh": "default",
 "name": "fi1",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "sources": [
  {
   "match": {
    "protocol": "http",
    "kuma.io/service": "frontend",
    "version": "0.1"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "protocol": "http",
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "delay": {
   "percentage": 50.5,
   "value": "5s"
  },
  "abort": {
   "percentage": 50,
   "httpStatus": 500
  },
  "responseBandwidth": {
   "percentage": 50,
   "limit": "50 mbps"
  }
 }
}
```

### Create/Update Fault Injection
Request: `PUT /meshes/{mesh}/fault-injections/{name}` with Fault Injection entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/default/fault-injections/fi1 --data @faultinjection.json -H'content-type: application/json'
```
```json
{
  "type": "FaultInjection",
  "mesh": "default",
  "name": "fi1",
  "sources": [
    {
      "match": {
        "kuma.io/service": "frontend",
        "version": "0.1",
        "protocol": "http"
      }
    }
  ],
  "destinations": [
    {
      "match": {
        "kuma.io/service": "backend",
        "protocol": "http"
      }
    }
  ],
  "conf": {
    "delay": {
      "percentage": 50.5,
      "value": "5s"
    },
    "abort": {
      "httpStatus": 500,
      "percentage": 50
    },
    "responseBandwidth": {
      "limit": "50 mbps",
      "percentage": 50
    }
  }
}
```

### List Fault Injections
Request: `GET /meshes/{mesh}/fault-injections`

Response: `200 OK` with body of Fault Injection entities

Example:
```bash
curl http://localhost:5681/meshes/default/fault-injections
```
```json
{
 "items": [
  {
   "type": "FaultInjection",
   "mesh": "default",
   "name": "fi1",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "sources": [
    {
     "match": {
      "protocol": "http",
      "kuma.io/service": "frontend",
      "version": "0.1"
     }
    }
   ],
   "destinations": [
    {
     "match": {
      "protocol": "http",
      "kuma.io/service": "backend"
     }
    }
   ],
   "conf": {
    "delay": {
     "percentage": 50.5,
     "value": "5s"
    },
    "abort": {
     "percentage": 50,
     "httpStatus": 500
    },
    "responseBandwidth": {
     "percentage": 50,
     "limit": "50 mbps"
    }
   }
  }
 ],
 "next": "http://localhost:5681/meshes/default/fault-injections?offset=1"
}
```

### Delete Fault Injection
Request: `DELETE /meshes/{mesh}/fault-injections/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/default/fault-injections/fi1
```

{% tip %}
The [`kumactl`](/docs/{{ page.version }}/explore/cli) CLI under the hood makes HTTP requests to this API.
{% endtip %}

## Retry

### Get Retry
Request: `GET /meshes/{mesh}/retries/{name}`

Response: `200 OK` with Retry entity

Example:
```bash
curl http://localhost:5681/meshes/default/retries/r1
```
```json
{
 "type": "Retry",
 "mesh": "default",
 "name": "r1",
 "creationTime": "2020-05-12T12:31:45.606217+02:00",
 "modificationTime": "2020-05-12T12:31:45.606217+02:00",
 "sources": [
  {
   "match": {
    "protocol": "http",
    "kuma.io/service": "frontend",
    "version": "0.1"
   }
  }
 ],
 "destinations": [
  {
   "match": {
    "protocol": "http",
    "kuma.io/service": "backend"
   }
  }
 ],
 "conf": {
  "http": {
   "numRetries": 5,
   "perTryTimeout": "0.2s",
   "backOff": {
    "baseInterval": "0.02s",
    "maxInterval": "1s"
   },
   "retriableStatusCodes": [500, 504]
  },
  "grpc": {
   "numRetries": 5,
   "perTryTimeout": "0.3s",
   "backOff": {
    "baseInterval": "0.03s",
    "maxInterval": "1.2s"
   },
   "retryOn": [
    "cancelled",
    "deadline_exceeded",
    "internal",
    "resource_exhausted",
    "unavailable"
   ]
  },
  "tcp": {
   "maxConnectAttempts": 4
  }
 }
}
```

### Create/Update Retry
Request: `PUT /meshes/{mesh}/retries/{name}` with Retry entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/default/retries/fi1 --data @retry.json -H'content-type: application/json'
```
```json
{
  "type": "Retry",
  "mesh": "default",
  "name": "r1",
  "sources": [
    {
      "match": {
        "kuma.io/service": "frontend",
        "version": "0.1",
        "protocol": "http"
      }
    }
  ],
  "destinations": [
    {
      "match": {
        "kuma.io/service": "backend",
        "protocol": "http"
      }
    }
  ],
  "conf": {
    "http": {
     "numRetries": 5,
     "perTryTimeout": "0.2s",
     "backOff": {
      "baseInterval": "0.02s",
      "maxInterval": "1s"
     },
     "retriableStatusCodes": [500, 504]
    },
    "grpc": {
     "numRetries": 5,
     "perTryTimeout": "0.3s",
     "backOff": {
      "baseInterval": "0.03s",
      "maxInterval": "1.2s"
     },
     "retryOn": [
      "cancelled",
      "deadline_exceeded",
      "internal",
      "resource_exhausted",
      "unavailable"
     ]
    },
    "tcp": {
     "maxConnectAttempts": 4
    }
  }
}
```

### List Retries
Request: `GET /meshes/{mesh}/retries`

Response: `200 OK` with body of Retry entities

Example:
```bash
curl http://localhost:5681/meshes/default/retries
```
```json
{
 "items": [
  {
   "type": "Retry",
   "mesh": "default",
   "name": "r1",
   "creationTime": "2020-05-12T12:31:45.606217+02:00",
   "modificationTime": "2020-05-12T12:31:45.606217+02:00",
   "sources": [
    {
     "match": {
      "protocol": "http",
      "kuma.io/service": "frontend",
      "version": "0.1"
     }
    }
   ],
   "destinations": [
    {
     "match": {
      "protocol": "http",
      "kuma.io/service": "backend"
     }
    }
   ],
   "conf": {
    "http": {
     "numRetries": 5,
     "perTryTimeout": "0.2s",
     "backOff": {
      "baseInterval": "0.02s",
      "maxInterval": "1s"
     },
     "retriableStatusCodes": [500, 504]
    },
    "grpc": {
     "numRetries": 5,
     "perTryTimeout": "0.3s",
     "backOff": {
      "baseInterval": "0.03s",
      "maxInterval": "1.2s"
     },
     "retryOn": [
      "cancelled",
      "deadline_exceeded",
      "internal",
      "resource_exhausted",
      "unavailable"
     ]
    },
    "tcp": {
     "maxConnectAttempts": 4
    }
   }
  }
 ],
 "next": "http://localhost:5681/meshes/default/retries?offset=1"
}
```

### Delete Retry
Request: `DELETE /meshes/{mesh}/retries/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/default/retries/r1
```

{% tip %}
The [`kumactl`](/docs/{{ page.version }}/explore/cli) CLI under the hood makes HTTP requests to this API.
{% endtip %}

## Timeout

### Get Timeout
Request: `GET /meshes/{mesh}/timeouts/{name}`

Response: `200 OK` with Timeout entity

Example:
```bash
curl http://localhost:5681/meshes/default/timeouts/default-timeouts-web
```
```json
{
  "type": "Timeout",
  "mesh": "default",
  "name": "default-timeouts-web",
  "creationTime": "2021-02-16T18:41:26.016089+07:00",
  "modificationTime": "2021-02-16T18:41:26.016089+07:00",
  "sources": [
    {
      "match": {
        "kuma.io/service": "*"
      }
    }
  ],
  "destinations": [
    {
      "match": {
        "kuma.io/service": "web"
      }
    }
  ],
  "conf": {
    "connectTimeout": "10s",
    "grpc": {
      "streamIdleTimeout": "4s",
      "maxStreamDuration": "15s"
    }
  }
}
```

### Create/Update Timeout
Request: `PUT /meshes/{mesh}/timeouts/{name}` with Timeout entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/default/timeouts/fi1 --data @timeout.json -H'content-type: application/json'
```
```json
{
  "type": "Timeout",
  "mesh": "default",
  "name": "default-timeouts-web",
  "sources": [
    {
      "match": {
        "kuma.io/service": "*"
      }
    }
  ],
  "destinations": [
    {
      "match": {
        "kuma.io/service": "web"
      }
    }
  ],
  "conf": {
    "connectTimeout": "10s",
    "grpc": {
      "streamIdleTimeout": "4s",
      "maxStreamDuration": "15s"
    }
  }
}
```

### List Timeouts
Request: `GET /meshes/{mesh}/retries`

Response: `200 OK` with body of Timeout entities

Example:
```bash
curl http://localhost:5681/meshes/default/timeouts
```
```json
{
  "total": 2,
  "items": [
    {
      "type": "Timeout",
      "mesh": "default",
      "name": "default-timeouts-web",
      "creationTime": "2021-02-16T18:41:26.016089+07:00",
      "modificationTime": "2021-02-16T18:41:26.016089+07:00",
      "sources": [
        {
          "match": {
            "kuma.io/service": "*"
          }
        }
      ],
      "destinations": [
        {
          "match": {
            "kuma.io/service": "web"
          }
        }
      ],
      "conf": {
        "connectTimeout": "10s",
        "grpc": {
          "streamIdleTimeout": "4s",
          "maxStreamDuration": "15s"
        }
      }
    },
    {
      "type": "Timeout",
      "mesh": "default",
      "name": "timeout-all-default",
      "creationTime": "2021-02-16T14:01:53.532599+07:00",
      "modificationTime": "2021-02-16T14:01:53.532599+07:00",
      "sources": [
        {
          "match": {
            "kuma.io/service": "*"
          }
        }
      ],
      "destinations": [
        {
          "match": {
            "kuma.io/service": "*"
          }
        }
      ],
      "conf": {
        "connectTimeout": "5s",
        "tcp": {
          "idleTimeout": "3600s"
        },
        "http": {
          "requestTimeout": "15s",
          "idleTimeout": "3600s"
        },
        "grpc": {
          "streamIdleTimeout": "300s"
        }
      }
    }
  ],
  "next": null
}
```

### Delete Timeout
Request: `DELETE /meshes/{mesh}/timeouts/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/default/timeouts/t1
```

{% tip %}
The [`kumactl`](/docs/{{ page.version }}/explore/cli) CLI under the hood makes HTTP requests to this API.
{% endtip %}


## Zones

### Get Zone
Request: `GET /zones/{name}`

Response: `200 OK` with Zone entity

Example:
```bash
curl http://localhost:5681/zones/cluster-1
```
```json
{
 "type": "Zone",
 "name": "cluster-1",
 "creationTime": "2020-07-28T13:14:48Z",
 "modificationTime": "2020-07-28T13:14:48Z",
 "enabled": true
}
```

### Create/Update Zone

Request: `PUT /zones/{name}` with Zone entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/zones/cluster-1 --data @zone.json -H'content-type: application/json'
```
```json
{
 "type": "Zone",
 "name": "cluster-1",
 "enabled": true
}
```

### List Zones

Request: `GET /zones`

Response: `200 OK` with body of Zone entities

Example:
```bash
curl http://localhost:5681/zones
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "Zone",
   "name": "cluster-1",
   "creationTime": "2020-07-28T13:14:48Z",
   "modificationTime": "2020-07-28T13:14:48Z",
   "enabled": true
  },
  {
   "type": "Zone",
   "name": "cluster-2",
   "creationTime": "2020-07-28T13:14:50Z",
   "modificationTime": "2020-07-28T13:14:50Z",
   "enabled": false
  }
 ],
 "next": null
}
```

### Delete Zone
Request: `DELETE /zones/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/zones/cluster-1
```

## Zone Overview

#### Get Zone Overview

Request: `GET /zones+insights/{name}`

Response: `200 OK` with Zone entity including insight

Example:
```bash
curl http://localhost:5681/zones+insights/cluster-1
```
```json
{
 "type": "ZoneOverview",
 "mesh": "default",
 "name": "cluster-1",
 "creationTime": "2020-07-28T23:08:22.317322+07:00",
 "modificationTime": "2020-07-28T23:08:22.317322+07:00",
 "zone": {
   "enabled": true
 },
 "zoneInsight": {
  "subscriptions": [
   {
    "config": "\"whole /config from zone\"",
    "id": "466aa63b-70e8-4435-8bee-a7146e2cdf11",
    "globalInstanceId": "66309679-ee95-4ea8-b17f-c715ca03bb38",
    "connectTime": "2020-07-28T16:08:09.743141Z",
    "disconnectTime": "2020-07-28T16:08:09.743194Z",
    "status": {
     "total": {}
    },
    "version": {
      "kumaCp": {
       "version": "1.2.0-rc2-211-g823fe8ce",
       "gitTag": "1.0.0-rc2-211-g823fe8ce",
       "gitCommit": "823fe8cef6430a8f75e72a7224eb5a8ab571ec42",
       "buildDate": "2021-02-18T13:22:30Z"
     }
    }
   },
   {
    "config": "\"whole /config from zone\"",
    "id": "f586f89c-2c4e-4f93-9a56-f0ea2ff010b7",
    "globalInstanceId": "66309679-ee95-4ea8-b17f-c715ca03bb38",
    "connectTime": "2020-07-28T16:08:24.760801Z",
    "status": {
     "lastUpdateTime": "2020-07-28T16:08:25.770774Z",
     "total": {
      "responsesSent": "11",
      "responsesAcknowledged": "11"
     },
     "stat": {
      "CircuitBreaker": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "Dataplane": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "FaultInjection": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "HealthCheck": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "Mesh": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "ProxyTemplate": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "Secret": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "TrafficLog": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "TrafficPermission": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "TrafficRoute": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      },
      "TrafficTrace": {
       "responsesSent": "1",
       "responsesAcknowledged": "1"
      }
     }
    }
   }
  ]
 }
}
```

#### List Zone Overview

Request: `GET /zones+insights`

Response: `200 OK` with Zone entities including insight

Example:
```bash
curl http://localhost:5681/zones+insights
```
```json
{
  "total": 1,
  "items": [
  {
   "type": "ZoneOverview",
   "mesh": "default",
   "name": "cluster-1",
   "creationTime": "2020-07-28T23:08:22.317322+07:00",
   "modificationTime": "2020-07-28T23:08:22.317322+07:00",
   "zone": {
     "enabled": true
   },
   "zoneInsight": {
    "subscriptions": [
     {
      "config": "\"whole /config from zone\"",
      "id": "466aa63b-70e8-4435-8bee-a7146e2cdf11",
      "globalInstanceId": "66309679-ee95-4ea8-b17f-c715ca03bb38",
      "connectTime": "2020-07-28T16:08:09.743141Z",
      "disconnectTime": "2020-07-28T16:08:09.743194Z",
      "status": {
       "total": {}
      },
      "version": {
       "kumaCp": {
         "version": "1.2.0-rc2-211-g823fe8ce",
         "gitTag": "1.0.0-rc2-211-g823fe8ce",
         "gitCommit": "823fe8cef6430a8f75e72a7224eb5a8ab571ec42",
         "buildDate": "2021-02-18T13:22:30Z"
        }
      }
     },
     {
      "config": "\"whole /config from zone\"",
      "id": "f586f89c-2c4e-4f93-9a56-f0ea2ff010b7",
      "globalInstanceId": "66309679-ee95-4ea8-b17f-c715ca03bb38",
      "connectTime": "2020-07-28T16:08:24.760801Z",
      "status": {
       "lastUpdateTime": "2020-07-28T16:08:25.770774Z",
       "total": {
        "responsesSent": "11",
        "responsesAcknowledged": "11"
       },
       "stat": {
        "CircuitBreaker": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "Dataplane": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "FaultInjection": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "HealthCheck": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "Mesh": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "ProxyTemplate": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "Secret": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "TrafficLog": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "TrafficPermission": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "TrafficRoute": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        },
        "TrafficTrace": {
         "responsesSent": "1",
         "responsesAcknowledged": "1"
        }
       }
      },
      "version": {
       "kumaCp": {
         "version": "1.2.0-rc2-211-g823fe8ce",
         "gitTag": "1.0.0-rc2-211-g823fe8ce",
         "gitCommit": "823fe8cef6430a8f75e72a7224eb5a8ab571ec42",
         "buildDate": "2021-02-18T13:22:30Z"
        }
      }
     }
    ]
   }
  }
  ],
 "next": null
}
```
## Zone Ingresses

#### List Zone Ingresses

Request: `GET /zone-ingresses`

Response: `200 OK` with ZoneIngresses entities

Example:
```bash
curl http://localhost:5681/zone-ingresses
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "ZoneIngress",
   "name": "zi-1",
   "creationTime": "2022-04-01T18:33:41Z",
   "modificationTime": "2022-04-01T18:33:41Z",
   "zone": "kuma-4",
   "networking": {
    "address": "192.168.64.9",
    "advertisedAddress": "192.168.64.9",
    "port": 30685,
    "advertisedPort": 30685
   },
   "availableServices": [
    {
     "tags": {
      "kuma.io/service": "zone4-demo-client",
      "kuma.io/zone": "kuma-4",
      "team": "client-owners"
     },
     "instances": 1,
     "mesh": "default"
    },
    {
     "tags": {
      "kuma.io/protocol": "http",
      "kuma.io/service": "external-service-in-zone4",
      "kuma.io/zone": "kuma-4",
      "mesh": "default"
     },
     "instances": 1,
     "mesh": "default",
     "externalService": true
    }
   ]
  },
  {
   "type": "ZoneIngress",
   "name": "zi-2",
   "creationTime": "2022-04-01T18:33:15Z",
   "modificationTime": "2022-04-01T18:33:15Z",
   "networking": {
    "address": "10.42.0.6",
    "advertisedAddress": "192.168.64.4",
    "port": 10001,
    "advertisedPort": 31882
   },
   "availableServices": [
    {
     "tags": {
      "app": "demo-client",
      "k8s.kuma.io/namespace": "kuma-test",
      "kuma.io/instance": "demo-client-6794456845-fr4gf",
      "kuma.io/protocol": "tcp",
      "kuma.io/service": "demo-client_kuma-test_svc",
      "kuma.io/zone": "kuma-1-zone",
      "pod-template-hash": "6794456845"
     },
     "instances": 1,
     "mesh": "default"
    },
    {
     "tags": {
      "kuma.io/protocol": "http",
      "kuma.io/service": "external-service-in-zone1",
      "kuma.io/zone": "kuma-1-zone",
      "mesh": "default"
     },
     "instances": 1,
     "mesh": "default",
     "externalService": true
    }
   ]
  }
 ],
 "next": null
}
```

#### Get Zone Ingress

Request: `GET /zone-ingress/{name}`

Response: `200 OK` with ZoneIngress entity

Example:
```bash
curl http://localhost:5681/zone-ingresses/ze-1
```
```json
{
 "type": "ZoneIngress",
 "name": "zi-1",
 "creationTime": "2022-04-01T18:33:41Z",
 "modificationTime": "2022-04-01T18:33:41Z",
 "zone": "kuma-4",
 "networking": {
  "address": "192.168.64.9",
  "advertisedAddress": "192.168.64.9",
  "port": 30685,
  "advertisedPort": 30685
 },
 "availableServices": [
  {
   "tags": {
    "kuma.io/service": "zone4-demo-client",
    "kuma.io/zone": "kuma-4",
    "team": "client-owners"
   },
   "instances": 1,
   "mesh": "default"
  },
  {
   "tags": {
    "kuma.io/protocol": "http",
    "kuma.io/service": "external-service-in-zone4",
    "kuma.io/zone": "kuma-4",
    "mesh": "default"
   },
   "instances": 1,
   "mesh": "default",
   "externalService": true
  }
 ]
}
```

## Zone Ingress Overviews

#### List Zone Ingress Overviews

Request: `GET /zoneingresses+insights`

Response: `200 OK` with `ZoneIngressOverview` entities (which are combination of
`ZoneIngress` and `ZoneIngressInsight` entities)

Example:
```bash
curl http://localhost:5681/zoneingresses+insights
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "ZoneIngressOverview",
   "name": "zi-1",
   "creationTime": "2022-04-01T19:45:11Z",
   "modificationTime": "2022-04-01T19:45:11Z",
   "zoneIngress": {
    "zone": "kuma-4",
    "networking": {
     "address": "192.168.64.9",
     "advertisedAddress": "192.168.64.9",
     "port": 30685,
     "advertisedPort": 30685
    },
    "availableServices": [
     {
      "tags": {
       "kuma.io/service": "zone4-demo-client",
       "kuma.io/zone": "kuma-4",
       "team": "client-owners"
      },
      "instances": 1,
      "mesh": "default"
     },
     {
      "tags": {
       "kuma.io/protocol": "http",
       "kuma.io/service": "external-service-in-zone4",
       "kuma.io/zone": "kuma-4",
       "mesh": "default"
      },
      "instances": 1,
      "mesh": "default",
      "externalService": true
     }
    ]
   }
  },
  {
   "type": "ZoneIngressOverview",
   "name": "zi-2",
   "creationTime": "2022-04-01T19:44:46Z",
   "modificationTime": "2022-04-01T19:44:46Z",
   "zoneIngress": {
    "networking": {
     "address": "10.42.0.6",
     "advertisedAddress": "192.168.64.2",
     "port": 10001,
     "advertisedPort": 30103
    },
    "availableServices": [
     {
      "tags": {
       "app": "demo-client",
       "k8s.kuma.io/namespace": "kuma-test",
       "kuma.io/instance": "demo-client-59ff94f647-8wqw7",
       "kuma.io/protocol": "tcp",
       "kuma.io/service": "demo-client_kuma-test_svc",
       "kuma.io/zone": "kuma-1-zone",
       "pod-template-hash": "59ff94f647"
      },
      "instances": 1,
      "mesh": "default"
     },
     {
      "tags": {
       "kuma.io/protocol": "http",
       "kuma.io/service": "external-service-in-zone1",
       "kuma.io/zone": "kuma-1-zone",
       "mesh": "default"
      },
      "instances": 1,
      "mesh": "default",
      "externalService": true
     }
    ]
   },
   "zoneIngressInsight": {
    "subscriptions": [
     {
      "id": "e92113b3-f01c-43cf-a21e-2b7064eb5bf8",
      "controlPlaneInstanceId": "kuma-control-plane-7cc9ffd8f9-s79r8-5b83",
      "connectTime": "2022-04-01T19:44:52.306011636Z",
      "status": {
       "lastUpdateTime": "2022-04-01T19:45:14.389007660Z",
       "total": {
        "responsesSent": "8",
        "responsesAcknowledged": "9"
       },
       "cds": {
        "responsesSent": "3",
        "responsesAcknowledged": "3"
       },
       "eds": {
        "responsesSent": "2",
        "responsesAcknowledged": "3"
       },
       "lds": {
        "responsesSent": "3",
        "responsesAcknowledged": "3"
       },
       "rds": {}
      },
      "version": {
       "kumaDp": {
        "version": "dev-d66126389",
        "gitTag": "1.5.0-rc1-156-gd66126389",
        "gitCommit": "d66126389d1842fb459b4db399e2db82781527bf",
        "buildDate": "2022-04-01T19:43:19Z"
       },
       "envoy": {
        "version": "1.21.1",
        "build": "af50070ee60866874b0a9383daf9364e884ded22/1.21.1/Clean/RELEASE/BoringSSL",
        "kumaDpCompatible": true
       }
      },
      "generation": 18
     }
    ]
   }
  }
 ],
 "next": null
}
```

#### Get Zone Ingress Overview

Request: `GET /zoneingresses+insights/{name}`

Response: `200 OK` with `ZoneIngressOverview` entity (which is a combination of
`ZoneIngress` and `ZoneIngressInsight` entities)

Example:
```bash
curl http://localhost:5681/zoneingresses+insights/zi-1
```
```json
{
 "type": "ZoneIngressOverview",
 "name": "zi-1",
 "creationTime": "2022-04-01T19:45:11Z",
 "modificationTime": "2022-04-01T19:45:11Z",
 "zoneIngress": {
  "zone": "kuma-4",
  "networking": {
   "address": "192.168.64.9",
   "advertisedAddress": "192.168.64.9",
   "port": 30685,
   "advertisedPort": 30685
  },
  "availableServices": [
   {
    "tags": {
     "kuma.io/service": "zone4-demo-client",
     "kuma.io/zone": "kuma-4",
     "team": "client-owners"
    },
    "instances": 1,
    "mesh": "default"
   },
   {
    "tags": {
     "kuma.io/protocol": "http",
     "kuma.io/service": "external-service-in-zone4",
     "kuma.io/zone": "kuma-4",
     "mesh": "default"
    },
    "instances": 1,
    "mesh": "default",
    "externalService": true
   }
  ]
 },
 "zoneIngressInsight": {}
}
```

## Zone Egresses

#### List Zone Egresses

Request: `GET /zoneegresses`

Response: `200 OK` with ZoneEgress entities

Example:
```bash
curl http://localhost:5681/zoneegresses
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "ZoneEgress",
   "name": "kuma-1-zone.kuma-egress-6f7c8bbcc9-rzxnw.kuma-system",
   "creationTime": "2022-02-18T13:39:39Z",
   "modificationTime": "2022-02-18T13:39:39Z",
   "zone": "kuma-1-zone",
   "networking": {
    "address": "10.42.0.6",
    "port": 10002
   }
  },
  {
   "type": "ZoneEgress",
   "name": "kuma-3.egress",
   "creationTime": "2022-02-18T13:40:30.086380212Z",
   "modificationTime": "2022-02-18T13:40:30.086380212Z",
   "zone": "kuma-3",
   "networking": {
    "address": "172.21.0.11",
    "port": 30685
   }
  }
 ],
 "next": null
}
```

#### Get Zone Egress

Request: `GET /zoneegresses/{name}`

Response: `200 OK` with ZoneEgress entity 

Example:
```bash
curl http://localhost:5681/zoneegresses/ze-1
```
```json
{
 "type": "ZoneEgress",
 "name": "ze-1",
 "creationTime": "2022-02-18T13:40:30.086380212Z",
 "modificationTime": "2022-02-18T13:40:30.086380212Z",
 "zone": "zone-1",
 "networking": {
  "address": "172.21.0.11",
  "port": 30685
 }
}
```

## Zone Egress Overviews

#### List Zone Egress Overviews

Request: `GET /zoneegressoverviews`

Response: `200 OK` with `ZoneEgressOverview` entities (which are combination of
`ZoneEgress` and `ZoneEgressInsight` entities)

Example:
```bash
curl http://localhost:5681/zoneegressoverviews
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "ZoneEgressOverview",
   "name": "kuma-1-zone.kuma-egress-6f7c8bbcc9-rzxnw.kuma-system",
   "creationTime": "2022-02-18T13:39:39Z",
   "modificationTime": "2022-02-18T13:39:39Z",
   "zoneEgress": {
    "zone": "kuma-1-zone",
    "networking": {
     "address": "10.42.0.6",
     "port": 10002
    }
   },
   "zoneEgressInsight": {
    "subscriptions": [
     {
      "id": "bb56359c-5b1c-4a9e-af3f-0982e1f37b74",
      "controlPlaneInstanceId": "kuma-control-plane-b799fb878-w2d9l-97fb",
      "connectTime": "2022-02-18T13:39:48.312313103Z",
      "status": {
       "lastUpdateTime": "2022-02-18T13:40:41.338203595Z",
       "total": {
        "responsesSent": "11",
        "responsesAcknowledged": "13"
       },
       "cds": {
        "responsesSent": "4",
        "responsesAcknowledged": "4"
       },
       "eds": {
        "responsesSent": "3",
        "responsesAcknowledged": "5"
       },
       "lds": {
        "responsesSent": "4",
        "responsesAcknowledged": "4"
       },
       "rds": {}
      },
      "version": {
       "kumaDp": {
        "version": "dev-60984ad8d",
        "gitTag": "1.5.0-rc1-18-g60984ad8d",
        "gitCommit": "60984ad8d66a59b269b3493172a6a22edc310515",
        "buildDate": "2022-02-18T13:38:45Z"
       },
       "envoy": {
        "version": "1.21.0",
        "build": "a9d72603c68da3a10a1c0d021d01c7877e6f2a30/1.21.0/Clean/RELEASE/BoringSSL"
       }
      }
     }
    ]
   }
  },
  {
   "type": "ZoneEgressOverview",
   "name": "kuma-3.egress",
   "creationTime": "2022-02-18T13:40:30.086380212Z",
   "modificationTime": "2022-02-18T13:40:30.086380212Z",
   "zoneEgress": {
    "zone": "kuma-3",
    "networking": {
     "address": "172.21.0.11",
     "port": 30685
    }
   },
   "zoneEgressInsight": {
    "subscriptions": [
     {
      "id": "9f3766b3-f560-422f-b2ab-d8276f67d6d0",
      "controlPlaneInstanceId": "69150c6bc245-f8ba",
      "connectTime": "2022-02-18T13:40:30.084188804Z",
      "status": {
       "lastUpdateTime": "2022-02-18T13:40:39.129293439Z",
       "total": {
        "responsesSent": "6",
        "responsesAcknowledged": "7"
       },
       "cds": {
        "responsesSent": "2",
        "responsesAcknowledged": "2"
       },
       "eds": {
        "responsesSent": "2",
        "responsesAcknowledged": "3"
       },
       "lds": {
        "responsesSent": "2",
        "responsesAcknowledged": "2"
       },
       "rds": {}
      },
      "version": {
       "kumaDp": {
        "version": "dev-60984ad8d",
        "gitTag": "1.5.0-rc1-18-g60984ad8d",
        "gitCommit": "60984ad8d66a59b269b3493172a6a22edc310515",
        "buildDate": "2022-02-18T13:38:45Z"
       },
       "envoy": {
        "version": "1.21.0",
        "build": "a9d72603c68da3a10a1c0d021d01c7877e6f2a30/1.21.0/Clean/RELEASE/BoringSSL"
       }
      }
     }
    ]
   }
  }
 ],
 "next": null
}
```

#### Get Zone Egress Overview

Request: `GET /zoneegressoverviews/{name}`

Response: `200 OK` with `ZoneEgressOverview` entity (which is a combination of
`ZoneEgress` and `ZoneEgressInsight` entities)

Example:
```bash
curl http://localhost:5681/zonesegressoverviews/ze-1
```
```json
{
 "type": "ZoneEgressOverview",
 "name": "ze-1",
 "creationTime": "2022-02-18T13:40:30.086380212Z",
 "modificationTime": "2022-02-18T13:40:30.086380212Z",
 "zoneEgress": {
  "zone": "zone-1",
  "networking": {
   "address": "172.21.0.11",
   "port": 30685
  }
 },
 "zoneEgressInsight": {
  "subscriptions": [
   {
    "id": "9f3766b3-f560-422f-b2ab-d8276f67d6d0",
    "controlPlaneInstanceId": "69150c6bc245-f8ba",
    "connectTime": "2022-02-18T13:40:30.084188804Z",
    "status": {
     "lastUpdateTime": "2022-02-18T13:40:39.129293439Z",
     "total": {
      "responsesSent": "6",
      "responsesAcknowledged": "7"
     },
     "cds": {
      "responsesSent": "2",
      "responsesAcknowledged": "2"
     },
     "eds": {
      "responsesSent": "2",
      "responsesAcknowledged": "3"
     },
     "lds": {
      "responsesSent": "2",
      "responsesAcknowledged": "2"
     },
     "rds": {}
    },
    "version": {
     "kumaDp": {
      "version": "dev-60984ad8d",
      "gitTag": "1.5.0-rc1-18-g60984ad8d",
      "gitCommit": "60984ad8d66a59b269b3493172a6a22edc310515",
      "buildDate": "2022-02-18T13:38:45Z"
     },
     "envoy": {
      "version": "1.21.0",
      "build": "a9d72603c68da3a10a1c0d021d01c7877e6f2a30/1.21.0/Clean/RELEASE/BoringSSL"
     }
    }
   }
  ]
 }
}
```

## External Services

### Get External Service
Request: `GET /meshes/{mesh}/external-services/{name}`

Response: `200 OK` with External Service entity

Example:
```bash
curl localhost:5681/meshes/default/external-services/httpbin
```
```json
{
 "type": "ExternalService",
 "mesh": "default",
 "name": "httpbin",
 "creationTime": "2020-10-12T09:40:27.224648+03:00",
 "modificationTime": "2020-10-12T09:40:27.224648+03:00",
 "networking": {
  "address": "httpbin.org:80",
  "tls": {}
 },
 "tags": {
  "kuma.io/protocol": "http",
  "kuma.io/service": "httpbin"
 }
}
```

### Create/Update External Service

Request: `PUT /meshes/{mesh}/external-services/{name}` with External Service entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/default/external-services/es --data @es.json -H'content-type: application/json'
```
```json
{
 "type": "ExternalService",
 "mesh": "default",
 "name": "es",
 "networking": {
  "address": "httpbin.org:80",
  "tls": {}
 },
 "tags": {
  "kuma.io/protocol": "http",
  "kuma.io/service": "es"
 }
}
```

### List External Services

Request: `GET /external-services`

Response: `200 OK` with body of Zone entities

Example:
```bash
curl http://localhost:5681/external-services
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "ExternalService",
   "mesh": "default",
   "name": "httpbin",
   "creationTime": "2020-10-12T09:40:27.224648+03:00",
   "modificationTime": "2020-10-12T09:40:27.224648+03:00",
   "networking": {
    "address": "httpbin.org:80",
    "tls": {}
   },
   "tags": {
    "kuma.io/protocol": "http",
    "kuma.io/service": "httpbin"
   }
  },
  {
   "type": "ExternalService",
   "mesh": "default",
   "name": "httpsbin",
   "creationTime": "2020-10-12T09:41:07.275867+03:00",
   "modificationTime": "2020-10-12T09:41:07.275867+03:00",
   "networking": {
    "address": "httpbin.org:443",
    "tls": {
     "enabled": true,
     "caCert": {
      "inline": "LS0tLS1=="
     }
    }
   },
   "tags": {
    "kuma.io/protocol": "http",
    "kuma.io/service": "httpsbin"
   }
  }
 ],
 "next": null
}
```

### Delete External Services
Request: `DELETE /meshes/{mesh}/external-services/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/default/external-services/es
```

## Service Insights

### Get Service Insight
Request: `GET /meshes/{mesh}/service-insights/{name}`

Response: `200 OK` with Service Insight entity

Example:
```bash
curl localhost:5681/meshes/default/service-insights/backend
```
```json
{
 "type": "ServiceInsight",
 "mesh": "default",
 "name": "backend",
 "creationTime": "2020-10-12T09:40:27.224648+03:00",
 "modificationTime": "2020-10-12T09:40:27.224648+03:00",
 "status": "partially_degraded",
 "dataplanes": {
   "online": 1,
   "offline": 1,
   "total": 2
 }
}
```

### List Service Insights

Request: `GET /service-insights`

Response: `200 OK` with body of Service Insights entities

Example:
```bash
curl http://localhost:5681/service-insights
```
```json
{
 "total": 2,
 "items": [
  {
   "type": "ServiceInsight",
   "mesh": "default",
   "name": "backend",
   "creationTime": "2020-10-12T09:40:27.224648+03:00",
   "modificationTime": "2020-10-12T09:40:27.224648+03:00",
   "status": "partially_degraded",
   "dataplanes": {
     "online": 1,
     "offline": 1,
     "total": 2
   }
  },
  {
   "type": "ServiceInsight",
   "mesh": "default",
   "name": "backend-api",
   "creationTime": "2020-10-12T09:40:27.224648+03:00",
   "modificationTime": "2020-10-12T09:40:27.224648+03:00",
   "status": "partially_degraded", 
   "dataplanes": {
     "online": 1,
     "offline": 1,
     "total": 2
   }
  }
 ],
 "next": null
}
```

## Secrets

### Get Secret
Request: `GET /meshes/{mesh}/secrets/{name}`

Response: `200 OK` with Secret entity

Example:
```bash
curl localhost:5681/meshes/default/secrets/sample-secret
```
```json
{
  "type": "Secret",
  "mesh": "default",
  "name": "sample-secret",
  "creationTime": "2021-02-18T18:46:42.195647+01:00",
  "modificationTime": "2021-02-18T18:46:42.195647+01:00",
  "data": "dGVzdAo="
}
```

### Create/Update Secret

Request: `PUT /meshes/{mesh}/secrets/{name}` with Secret entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/meshes/default/secrets/sample-secret --data @secret.json -H'content-type: application/json'
```
```json
{
  "type": "Secret",
  "mesh": "default",
  "name": "sample-secret",
  "data": "dGVzdAo="
}
```

### List Secrets

Request: `GET /meshes/{mesh}/secrets`

Response: `200 OK` with body of Secret entities

Example:
```bash
curl http://localhost:5681/meshes/default/secrets
```
```json
{
  "total": 1,
  "items": [
    {
      "type": "Secret",
      "name": "sample-secret",
      "mesh": "default",
      "creationTime": "2021-02-18T18:46:42.195647+01:00",
      "modificationTime": "2021-02-18T18:46:42.195647+01:00",
      "data": "dGVzdAo="
    }
  ],
  "next": null
}
```

### Delete Secret
Request: `DELETE /meshes/{mesh}/secrets/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/meshes/default/secrets/sample-secret
```

## Global Secrets

### Get Global Secret
Request: `GET /global-secrets/{name}`

Response: `200 OK` with Global Secret entity

Example:
```bash
curl localhost:5681/sample-global-secret
```
```json
{
  "type": "Secret",
  "name": "sample-global-secret",
  "creationTime": "2021-02-18T18:46:42.195647+01:00",
  "modificationTime": "2021-02-18T18:46:42.195647+01:00",
  "data": "dGVzdAo="
}
```

### Create/Update Global Secret

Request: `PUT /global-secrets/{name}` with Global Secret entity in body

Response: `201 Created` when the resource is created and `200 OK` when it is updated

Example:
```bash
curl -XPUT http://localhost:5681/global-secrets/sample-global-secret --data @secret.json -H'content-type: application/json'
```
```json
{
  "type": "Secret",
  "name": "sample-global-secret",
  "data": "dGVzdAo="
}
```

### List Global Secrets

Request: `GET /global-secrets`

Response: `200 OK` with body of Global Secret entities

Example:
```bash
curl http://localhost:5681/global-secrets
```
```json
{
  "total": 1,
  "items": [
    {
      "type": "Secret",
      "name": "sample-global-secret",
      "creationTime": "2021-02-18T18:46:42.195647+01:00",
      "modificationTime": "2021-02-18T18:46:42.195647+01:00",
      "data": "dGVzdAo="
    }
  ],
  "next": null
}
```

### Delete Global Secret
Request: `DELETE /global-secrets/{name}`

Response: `200 OK`

Example:
```bash
curl -XDELETE http://localhost:5681/global-secrets/sample-global-secret
```


## Multi-zone

These APIs are available on the `Global` control plane, when running in a distributed [multi-zone mode](/docs/{{ page.version }}/introduction/deployments/).

### Zones status
Request: `GET /status/zones`

Response: `200 OK`

Example:
```bash
curl -XGET http://localhost:5681/status/zones
```

```json
[
 {
  "name": "zone-1",
  "url": "grpcs://1.1.1.1:5685",
  "active": true
 },
 {
  "name": "zone-2",
  "url": "grpcs://2.2.2.2:5685",
  "active": false
 }
]
```

## Dataplane Proxy Tokens

Generate the data plane proxy tokens required for data plane proxy authentication.

{% warning %}
Requires [authentication to the control plane by the user](/docs/{{ page.version }}/security/certificates#authentication).
{% endwarning %}

For details, see [data plane proxy authentication](/docs/{{ page.version }}/security/certificates#data-plane-proxy-to-control-plane-communication).

### Generate dataplane proxy token

Request: `PUT /tokens/dataplane` with the following body:
```json
{
  "name": "dp-echo-1",
  "mesh": "default",
  "tags": {
    "kuma.io/service": ["backend", "backend-admin"]
  }
}
```

Response: `200 OK`

Example:
```bash
curl -XPOST \ 
  -H "Content-Type: application/json" \
  --data '{"name": "dp-echo-1", "mesh": "default", "tags": {"kuma.io/service": ["backend", "backend-admin"]}}' \
  http://localhost:5681/tokens/dataplane
```

## Zone Ingress Tokens

Generate token which zone ingress can use to authenticate itself.

{% warning %}
Requires [authentication to the control plane by the user](/docs/{{ page.version }}/security/certificates/#authentication).
{% endwarning %}

For details, see [zone ingress authentication](/docs/{{ page.version }}/security/zone-ingress-auth/#zone-ingress-token).

### Generate Zone Ingress Token

Example:
```bash
curl -XPOST \
  -H "Content-Type: application/json" \
  --data '{"zone": "us-east", "validFor": "720h"}' \
  http://localhost:5681/tokens/zone-ingress
```

## Global Insights

### Get Global Insights

Request: `GET /global-insights`

Response: `200 OK` with Global Insights entity

Example:
```bash
curl localhost:5681/global-insights
```
```json
{
 "type": "GlobalInsights",
 "creationTime": "2021-11-05T08:11:37.880477+01:00",
 "resources": {
  "GlobalSecret": {
   "total": 3
  },
  "Mesh": {
   "total": 1
  },
  "Zone": {
   "total": 0
  },
  "ZoneIngress": {
   "total": 0
  }
 }
}
```

## Inspect API

### Get policies matched for the data plane proxy

Request: `GET /meshes/{mesh}/dataplanes/{dataplane}/policies`

Example:
```bash
curl localhost:5681/meshes/default/dataplanes/backend-1/policies
```
```json
{
 "total": 3,
 "kind": "SidecarDataplane",
 "items": [
  {
   "type": "inbound",
   "name": "127.0.0.1:10010:10011",
   "matchedPolicies": {
    "TrafficPermission": [
     {
      "type": "TrafficPermission",
      "mesh": "default",
      "name": "allow-all-default",
      ...  
     }
    ]
   }
  },
  {
   "type": "outbound",
   "name": "127.0.0.1:10006",
   "matchedPolicies": {
    "Timeout": [
     {
      "type": "Timeout",
      "mesh": "default",
      "name": "timeout-all-default",
      ...
     }
    ]
   }
  },
  {
   "type": "service",
   "name": "gateway",
   "matchedPolicies": {
    "CircuitBreaker": [
     {
      "type": "CircuitBreaker",
      "mesh": "default",
      "name": "circuit-breaker-all-default",
      ...
     }
    ],
    "HealthCheck": [
     {
      "type": "HealthCheck",
      "mesh": "default",
      "name": "gateway-to-backend",
      ...
     }
    ],
    "Retry": [
     {
      "type": "Retry",
      "mesh": "default",
      "name": "retry-all-default",
      ...
     }
    ]
   }
  }
 ]
}
```

`MeshGateway`-configured `Dataplane` example:
```bash
curl localhost:5681/meshes/default/dataplanes/gateway-1/policies
```
```json
{
 "gateway": {
  "mesh": "default",
  "name": "foo-gateway.default"
 },
 "kind": "MeshGatewayDataplane",
 "listeners": [
  {
   "hosts": [
    {
     "hostName": "go.com",
     "routes": [
      {
       "destinations": [
        {
         "policies": {
          "CircuitBreaker": {
           "type": "CircuitBreaker"
           "mesh": "default",
           "name": "circuit-breaker-all-default",
           ...
          },
          "Retry": {
           "type": "Retry"
           "mesh": "default",
           "name": "retry-all-default",
           ...
          },
          "Timeout": {
           "type": "Timeout"
           "mesh": "default",
           "name": "timeout-all-default",
           ...
          }
         },
         "tags": {
          "kuma.io/service": "demo-app_kuma-demo_svc_5000"
         }
        },
        {
         "policies": {
          "CircuitBreaker": {
           "type": "CircuitBreaker"
           "mesh": "default",
           "name": "circuit-breaker-all-default",
           ...
          },
          "Retry": {
           "type": "Retry"
           "mesh": "default",
           "name": "retry-all-default",
           ...
          },
          "Timeout": {
           "type": "Timeout"
           "mesh": "default",
           "name": "timeout-all-default",
           ...
          }
         },
         "tags": {
          "kuma.io/service": "httpbin"
         }
        }
       ],
       "route": "default-foo-gateway-hw6n5"
      }
     ]
    }
   ],
   "port": 80,
   "protocol": "HTTP"
  }
 ]
}
```

### Get data plane proxies affected by policy

Request: `GET /meshes/{mesh}/{policy-type}/{policy}/dataplanes`

Example:
```bash
curl localhost:5681/meshes/default/circuit-breakers/circuit-breaker-all-default/dataplanes
```
```json
{
 "total": 2,
 "items": [
  {
   "kind": "SidecarDataplane",
   "dataplane": {
    "mesh": "default",
    "name": "demo-app-1"
   },
   "attachments": [
    {
     "type": "service",
     "name": "demo-app_kuma-demo_svc_5000",
     "service": "demo-app_kuma-demo_svc_5000"
    }
   ]
  },
  {
   "kind": "MeshGatewayDataplane",
   "dataplane": {
    "mesh": "default",
    "name": "gateway-1"
   },
   "gateway": {
    "mesh": "default",
    "name": "edge-gateway"
   },
   "listeners": [
    {
     "port": 80,
     "protocol": "HTTP",
     "hosts": [
      {
       "hostName": "go.com",
       "routes": [
        {
         "route": "default-gateway",
         "destinations": [
          {
           "kuma.io/service": "demo-app_kuma-demo_svc_5000"
          }
         ]
        }
       ]
      }
     ]
    }
   ]
  }
 ]
}
```

### Get data plane proxies configured by `MeshGateway`

Request: `GET /meshes/{mesh}/meshgateways/{meshgateway}/dataplanes`

Example:
```bash
curl localhost:5681/meshes/default/meshgateways/edge-gateway/policies
```
```json
{
 "items": [
  {
   "dataplane": {
    "mesh": "default",
    "name": "gateway-1"
   }
  }
 ],
 "total": 1
}
```

### Get envoy config dump for data plane proxy

Request: `GET /meshes/{mesh}/dataplanes/{dataplane}/xds`

Example:
```bash
curl localhost:5681/meshes/default/dataplane/backend-1/xds
```
```json
{
 "configs": [
  {
   "@type": "type.googleapis.com/envoy.admin.v3.BootstrapConfigDump",
   "bootstrap": {
    "node": {
     "id": "default.backend-1",
     "cluster": "backend",
     "metadata": {
       "dataplane.admin.port": "6606"
     }
    }
   }
  }
 ]
}
```

### Get envoy config dump for ZoneIngress

Request: `GET /zoneingresses/{name}/xds`

Example:
```bash
curl localhost:5681/zoneingresses/zi-1/xds
```
```json
{
 "configs": [
  {
   "@type": "type.googleapis.com/envoy.admin.v3.BootstrapConfigDump",
   "bootstrap": {
    "node": {
     "id": "default.zi-1",
     "cluster": "zi",
     "metadata": {
       "dataplane.admin.port": "6606"
     }
    }
   }
  }
 ]
}
```

### Get envoy config dump for ZoneEgress

Request: `GET /zoneegresses/{name}/xds`

Example:
```bash
curl localhost:5681/zoneegresses/ze-1/xds
```
```json
{
 "configs": [
  {
   "@type": "type.googleapis.com/envoy.admin.v3.BootstrapConfigDump",
   "bootstrap": {
    "node": {
     "id": "default.ze-1",
     "cluster": "ze",
     "metadata": {
       "dataplane.admin.port": "6606"
     }
    }
   }
  }
 ]
}
```


### Policies

Show all policies that are usable on the control plane

Request: `GET /policies`

Example:
```bash
curl localhost:5681/policies
```

```json
{
 "policies": [
  {
   "name": "CircuitBreaker",
   "readOnly": false,
   "path": "circuit-breakers",
   "displayName": "Circuit Breakers"
  },
  {
   "name": "ExternalService",
   "readOnly": false,
   "path": "external-services",
   "displayName": "External Services"
  },
  {
   "name": "FaultInjection",
   "readOnly": false,
   "path": "fault-injections",
   "displayName": "Fault Injections"
  },
  {
   "name": "HealthCheck",
   "readOnly": false,
   "path": "health-checks",
   "displayName": "Health Checks"
  },
  {
   "name": "MeshGateway",
   "readOnly": false,
   "path": "meshgateways",
   "displayName": "Mesh Gateways"
  },
  {
   "name": "MeshGatewayRoute",
   "readOnly": false,
   "path": "meshgatewayroutes",
   "displayName": "Mesh Gateway Routes"
  },
  {
   "name": "ProxyTemplate",
   "readOnly": false,
   "path": "proxytemplates",
   "displayName": "Proxy Templates"
  },
  {
   "name": "RateLimit",
   "readOnly": false,
   "path": "rate-limits",
   "displayName": "Rate Limits"
  },
  {
   "name": "Retry",
   "readOnly": false,
   "path": "retries",
   "displayName": "Retries"
  },
  {
   "name": "Timeout",
   "readOnly": false,
   "path": "timeouts",
   "displayName": "Timeouts"
  },
  {
   "name": "TrafficLog",
   "readOnly": false,
   "path": "traffic-logs",
   "displayName": "Traffic Logs"
  },
  {
   "name": "TrafficPermission",
   "readOnly": false,
   "path": "traffic-permissions",
   "displayName": "Traffic Permissions"
  },
  {
   "name": "TrafficRoute",
   "readOnly": false,
   "path": "traffic-routes",
   "displayName": "Traffic Routes"
  },
  {
   "name": "TrafficTrace",
   "readOnly": false,
   "path": "traffic-traces",
   "displayName": "Traffic Traces"
  },
  {
   "name": "VirtualOutbound",
   "readOnly": false,
   "path": "virtual-outbounds",
   "displayName": "Virtual Outbounds"
  }
 ]
}
```
