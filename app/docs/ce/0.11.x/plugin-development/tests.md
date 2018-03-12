---
title: Plugin Development - Writing tests
book: plugin_dev
chapter: 9
---

# {{page.title}}

---

If you are serious about your plugins, you probably want to write tests for it. Unit testing Lua is easy, and [many testing frameworks](http://lua-users.org/wiki/UnitTesting) are available. However, you might also want to write integration tests. Again, Kong has your back.

---

### Write integration tests

The preferred testing framework for Kong is [busted](http://olivinelabs.com/busted/) running with the [resty-cli](https://github.com/openresty/resty-cli) interpreter, though you are free to use another one if you wish. In the Kong repository, the busted executable can be found at `bin/busted`.

Kong provides you with a helper to start and stop it from Lua in your test suite: `spec.helpers`. This helper also provides you with ways to insert fixtures in your datastore before running your tests, as well as dropping it, and various other helpers.

If you are writing your plugin in your own repository, you will need to copy the following files until the Kong testing framework is released:

- `bin/busted`: the busted executable running with the resty-cli interpreter
- `spec/helpers.lua`: helper functions to start/stop Kong from busted
- `spec/kong_tests.conf`: a configuration file for your running your test Kong instances with the helpers module

Assuming that the `spec.helpers` module is available in your `LUA_PATH`, you can use the following Lua code in busted to start and stop Kong:

```lua
local helpers = require "spec.helpers"

describe("my plugin", function()

  local proxy_client
  local admin_client

  setup(function()
    assert(helpers.dao.apis:insert {
      name         = "test-api",
      hosts        = "test.com",
      upstream_url = "http://httpbin.org"
    })

    -- start Kong with your testing Kong configuration (defined in "spec.helpers")
    assert(helpers.start_kong())

    admin_client = helpers.admin_client()
  end)

  teardown(function()
    if admin_client then
      admin_client:close()
    end

    helpers.stop_kong()
  end)

  before_each(function()
    proxy_client = helpers.proxy_client()
  end)

  after_each(function()
    if proxy_client then
      proxy_client:close()
    end
  end)

  describe("thing", function()
    it("should do thing", function()
      -- send requests through Kong
      local res = assert(proxy_client:send {
        method = "GET",
        path   = "/get",
        headers = {
          ["Host"] = "test.com"
        }
      })

      local body = assert.res_status(200, res)

      -- body is a string containing the response
    end)
  end)
end)
```

> Reminder: With the test Kong configuration file, Kong is running with its proxy listening on port 8100 and Admin API on port 8101.

---

Next: [Distribute your plugin &rsaquo;]({{page.book.next}})
