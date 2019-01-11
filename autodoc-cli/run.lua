#!/usr/bin/env resty

local lfs = require("lfs")

local data = require("autodoc-cli.data")

local KONG_PATH = assert(os.getenv("KONG_PATH"))
local KONG_VERSION = assert(os.getenv("KONG_VERSION"))

package.path = KONG_PATH .. "/?.lua;" .. KONG_PATH .. "/?/init.lua;" .. package.path

local cmds = {}
for file in lfs.dir(KONG_PATH .. "/kong/cmd") do
  local cmd = file:match("(.*)%.lua$")
  if cmd and cmd ~= "roar" and cmd ~= "init" then
    table.insert(cmds, cmd)
  end
end
table.sort(cmds)

local outpath = "app/" .. KONG_VERSION .. "/cli.md"
local outfd = assert(io.open(outpath, "w+"))

outfd:write(data.header)

local function write(str)
  outfd:write(str)
  outfd:write("\n")
end

for _, cmd in ipairs(cmds) do
  write("")
  write("### kong " .. cmd)
  write("")
  if data.command_intro[cmd] then
    write((("\n"..data.command_intro[cmd]):gsub("\n%s+", "\n"):gsub("^\n", "")))
  end
  write("```")
  local pd = io.popen("cd " .. KONG_PATH .. "; bin/kong " .. cmd .. " --help 2>&1")
  local info = pd:read("*a")
  info = info:gsub(" %-%-v[^\n]+\n", "")
  info = info:gsub("\nOptions:\n$", "")
  write(info)
  pd:close()
  write("```")
  write("")
  write("[Back to TOC](#table-of-contents)")
  write("")
  write("---")
  write("")
end

outfd:write(data.footer)

outfd:close()
