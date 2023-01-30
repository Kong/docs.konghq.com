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

source_code: https://github.com/seifchen/kong-path-allow

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
