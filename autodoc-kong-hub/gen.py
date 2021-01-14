#!/usr/bin/env python3
from git import Repo
import re
import argparse

parser = argparse.ArgumentParser(description='Update Kong plugin version information. ' \
                                             'This tool updates the latest plugin version ' \
                                             'and compatible Kong version info in plugin hub docs.')
parser.add_argument('--latest-version', help='tag of the latest version of Kong release, can not be prereleases such as x.y.zrc1', required=True, metavar='x.y.z')
parser.add_argument('--kong-repo', help='path to a freshly cloned Kong Git repository', required=True, metavar="PATH")
parser.add_argument('--kong-doc-repo', help='path to the Kong Doc repository where the change should be applied to', required=True, metavar='PATH')

args = parser.parse_args()

# transforms old plugin names to new ones
MAP = {
    "ip_restriction": "ip-restriction",
    "log_serializers": "log-serializers",
    "tcplog": "tcp-log",
    "udplog": "udp-log",
    "httplog": "http-log",
    "filelog": "file-log",
    "request_transformer": "request-transformer",
    "ratelimiting": "rate-limiting",
    "basicauth": "basic-auth",
    "keyauth": "key-auth",
    "requestsizelimiting": "request-size-limiting",
    "response_transformer": "response-transformer",
}


result = {}
latest = {}


LATEST = args.latest_version
repo = Repo(args.kong_repo)

for t in repo.tags:
    ts = str(t)
    if re.match(r"\d\.\d+(?:\.\d)*$", ts):
        if ts == LATEST:
            target = t.commit.tree
            for n in target.blobs:
                if 'rockspec' in n.name:
                    spec = target / n.name
                    spec = spec.data_stream.read().decode("utf-8")
                    for m in re.finditer(r'"kong-plugin-(.+) .+ (.+)",', spec):
                        latest[m[1]] = m[2]

                    for m in re.finditer(r'"kong-(.+)-plugin .+ (.+)",', spec):
                        latest[m[1]] = m[2]
                    break

        target = t.commit.tree / "kong/plugins"
        for plugin in target.trees:
            if ts == LATEST:
                try:
                    handler = plugin / "handler.lua"
                except KeyError:
                  continue

                handler = handler.data_stream.read().decode("utf-8")
                ver = re.search(r'VERSION = "(\d\.\d\.\d)"', handler)
                if ver:
                  latest[plugin.name] = ver[1]

                else:
                  print(handler)

            l = result.setdefault(MAP.get(plugin.name) or plugin.name, set())

            ts_mask = ts[:-1] + 'x'
            l.add(ts_mask)

        target = t.commit.tree
        for n in target.blobs:
            if 'rockspec' in n.name:
                spec = target / n.name
                spec = spec.data_stream.read().decode("utf-8")
                for m in re.finditer(r'"kong-plugin-(.+) .+ .+",', spec):
                    l = result.setdefault(MAP.get(m[1]) or m[1], set())

                    ts = ts[:-1] + 'x'
                    l.add(ts)

                for m in re.finditer(r'"kong-(.+)-plugin .+ .+",', spec):
                    l = result.setdefault(MAP.get(m[1]) or m[1], set())

                    ts = ts[:-1] + 'x'
                    l.add(ts)
                break

result = { k: list(v) for k, v in result.items() }

for v in result.values():
    v.sort(key=lambda s: list(map(int, s.split('.')[:-1])), reverse=True)

for k, v in result.items():
    path = "%s/app/_hub/kong-inc/%s/index.md" % (args.kong_doc_repo, k)
    try:
        f = open(path, "r")
        lines = f.readlines()
        f.close()

        ce_yaml = ["    community_edition:\n", "      compatible:\n"]
        for ce in v:
            ce_yaml.append("        - " + ce + "\n")

        start_ce = None
        for i, l in enumerate(lines):
            if "community_edition:" in l:
                start_ce = i

            if start_ce and "enterprise_edition:" in l:
                end_ce = i - 1
                lines[start_ce:end_ce] = ce_yaml
                break

        for i, l in enumerate(lines):
            if latest.get(k) and l.startswith("version:"):
                lines[i] = "version: " + latest[k] + '\n'

        f = open(path, "w")
        content = f.write(''.join(lines))
        f.close()

    except FileNotFoundError:
      continue
