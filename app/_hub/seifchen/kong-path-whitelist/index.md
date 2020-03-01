---
name: Kong Path White Lists
publisher: Seifchen

categories:
  - security

type: plugin

desc: Determine if the path is in the path whitelist, if not, return 403

description: |

  Determine if the path is in the path whitelist, if not, return 403 Support regex.

support_url: https://github.com/seifchen/kong-path-whitelist/issues

source_url: https://github.com/seifchen/kong-path-whitelist

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
    incompatible:
      - 1.1.x
      - 1.0.x
      - 0.15.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.3.x
      - 0.2.x

params:
  name: kong-path-whitelist
  api_id: false
  service_id: true
  consumer_id: true
  route_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes

  config:
    - name: white_paths
      required: yes
      default: []
      value_in_examples: ["/api/services", "/api/routes"]
      description: The request path not match this path will forbidden with 403 code
    - name: regex
      required: true
      default: true
      value_in_examples:
      description: boolean, if true will use ngx.re.match to match the request_path and white_paths,if false, Will strictly judge whether the two path are equal

---

# Install
### Luarocks
```
luarocks install kong-path-whitelist
```

### Source Code
```
$ git clone https://github.com/seifchen/kong-path-whitelist.git
$ cd /path/to/kong/plugins/kong-path-whitelist
$ luarocks make *.rockspec
```

### Maintainers
[seifchen](https://github.com/seifchen)


