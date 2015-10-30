---
title: Plugin Development - Writing tests
book: plugin_dev
chapter: 8
---

# {{page.title}}

---

If you are serious about your plugins, you probably want to write tests for it. Unit testing Lua is easy, and [many testing frameworks](http://lua-users.org/wiki/UnitTesting) are available. However, you might also want to write integration tests. Again, Kong has your back.

---

### Write integration tests

The preferred testing framework for Kong is [busted](http://olivinelabs.com/busted/), though you are free to use another one if you wish.

Kong provides you with a helper to start and stop it from Lua code in your test suite: `spec.spec_helpers`. This helper also provides you with ways to insert fixtures in your datastore before running your tests, as well as dropping it, and various other helpers.

Assuming you have a configuration file obtained from running `make dev` in your Kong repository in your current folder, and that the `spec.spec_helpers` module is available in your `LUA_PATH`, you can use the following Lua code in busted to start and stop Kong:

```lua
local spec_helper = require "spec.spec_helpers"

setup(function()
  -- Run the migrations to prepare the database
  spec_helper.prepare_db()

  -- Insert some fixtures in the database before running your tests
  spec_helper.insert_fixtures {
    api = {
      {name = "fixture-api", request_host = "fixture.com", upstream_url = "http://mockbin.com"}
    },
    consumer = {
      {username = "fixture-consumer"}
    },
    plugin = {
      {name = "key-auth", config = {key_names = {"apikey"}}, __api = 1},
      {name = "key-auth", config = {key_names = {"apikey"}, hide_credentials = true}, __api = 2}
    }
  }

  -- start Kong with your local kong_TEST.yml configuration
  spec_helper.start_kong()
end)

teardown(function()
  -- stop Kong with your local kong_TEST.yml configuration
  spec_helper.stop_kong()
end)

describe("thing", function()
  it("should do thing", function()
    -- send requests through Kong
  end)
end)
```

> Reminder: With the kong_TEST.yml file, Kong is running with its proxy listening on port 8100 and Admin API on port 8101.

---

Next: [Distribute your plugin &rsaquo;]({{page.book.next}})
