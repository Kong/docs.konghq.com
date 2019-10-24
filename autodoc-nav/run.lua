#!/usr/bin/env resty

local lfs = require("lfs")

local KONG_VERSION = assert(os.getenv("KONG_VERSION"), "please specify the KONG_VERSION environment variable")

print("Building docs for Kong version " .. KONG_VERSION)

local function read_file(name, err)
  local fd = assert(io.open(name, "r"), err)
  local data = fd:read("*a")
  fd:close()
  return data
end

local prefix = "autodoc-nav/docs_nav_" .. KONG_VERSION .. ".yml"
local head_data = read_file(prefix .. ".head.in")
local admin_api_data = read_file(prefix .. ".admin-api.in", "Please run autodoc-admin-api first!")

local outfile = "app/_data/docs_nav_" .. KONG_VERSION .. ".yml"
local outfd = assert(io.open(outfile, "w+"))

lfs.mkdir("app")
lfs.mkdir("app/_data")

local function gen_pdk_data()
  local files = {}
  for file in lfs.dir("app/" .. KONG_VERSION .. "/pdk") do
    table.insert(files, file)
  end
  table.sort(files)
  local data = {
    "",
    "    - text: Plugin Development Kit",
    "      url: /pdk",
    "      items:",
  }
  for _, file in ipairs(files) do
    local mod = file:match("^(kong.*)%.md$")
    if mod then
      table.insert(data, "        - text: " .. mod)
      table.insert(data, "          url: /pdk/" .. mod)
      table.insert(data, "")
    end
  end
  table.insert(data, "")

  return table.concat(data, "\n")
end

local pdk_data = gen_pdk_data()

outfd:write("# Generated via autodoc-nav\n")
outfd:write(head_data)
outfd:write(pdk_data)
outfd:write(admin_api_data)

outfd:close()

print("Wrote " .. outfile)
