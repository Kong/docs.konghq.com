---
name: Kong Path Allow
publisher: Seifchen

categories:
  - security

type: plugin

desc: Determine if the path is in the path allow list, and if not, return a 403

description: |
  You can use the Kong Path Allow plugin on a Service, Route, or Consumer with paths. The plugin will check if the path is in the path allow list, and if not, return a 403.

support_url: https://github.com/seifchen/kong-path-allow/issues

source_url: https://github.com/seifchen/kong-path-allow

license_type: Apache-2.0

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x

params:
  name: kong-path-allow
  api_id: false
  service_id: true
  consumer_id: true
  route_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes

  config:
    - name: allow_paths
      required: yes
      default: []
      value_in_examples: ["/api/services", "/api/routes"]
      description: An allowed path. Any request path that does not match one of the paths in this list will be forbidden and return a 403 error code.
    - name: regex
      required: true
      default: true
      value_in_examples:
      description: A boolean value that specifies whether the plugin uses regex for path matching. If `true`, the plugin will use `ngx.re.match` to match the `request_path` and `allow_paths` values. If `false`, it will strictly judge whether the two paths are equal.

---

# Install
### Luarocks
```
luarocks install kong-path-allow
```

### Source Code
```
$ git clone https://github.com/seifchen/kong-path-allow.git
$ cd /path/to/kong/plugins/kong-path-allow
$ luarocks make *.rockspec
```
See the README in the plugin source repository for more usage examples.

### Maintainers
[seifchen](https://github.com/seifchen){:target="_blank"}{:rel="noopener noreferrer"}
