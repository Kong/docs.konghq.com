# About this tool

These are tools to generate Kuma/Kong Mesh navigation files.

You'll usually want to start with Kong Mesh and generate Kuma's navigation from that file, as Kong Mesh has more pages due to enterprise features.

How it works (Mesh to Kuma):

- Remove any pages that don't have a `src` entry that starts with `/.repos/kuma`. These are Mesh specific files
- Replace `Kong Mesh` with `Kuma` in titles and URLs
- Adds `group: true` to top level items for the Kuma nav

How it works (Kuma to Mesh):

- Replace `Kuma` with `Kong Mesh` in titles and URLs
- Remove any `group` entries
- For every page with a `url`, set `src` to be `/.repos/kuma/src/$url`

# Usage

Run `npm ci` then run the commands below:

### Mesh to Kuma

```bash
node mesh-to-kuma.js docs_nav_mesh_2.0.x.yml > /path/to/kuma-website/app/_data/docs_nav_kuma_2.0.x.yml
```

### Kuma to Mesh

You usually don't want to do this. But just in case you know what you're doing:

```bash
node kuma-to-mesh.js docs_nav_kuma_2.0.x.yml > /path/to/docs.konghq.com/app/_data/docs_nav_mesh_2.0.x.yml
```

When generating a Mesh doc nav from Kuma, you may want to see a warning when there is a `url` and child `items` set on the same entry. This is disallowed by our style guide.

To see these warnings:

```bash
DEBUG="kong" node kuma-to-mesh.js fixtures/kuma.yml > /dev/null
```
