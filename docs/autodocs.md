* **Some of our docs are generated**.
    * [API docs](https://docs.konghq.com/api/)
    * [CLI reference](https://docs.konghq.com/gateway/latest/reference/cli/)
    * [OSS upgrade guide](https://docs.konghq.com/gateway/latest/upgrade/)
    * [PDK reference](https://docs.konghq.com/gateway/latest/pdk)

All pull requests for these docs should be opened in the [Kong/kong](https://github.com/Kong/kong) repository. Fork the repository and submit PRs from your fork.

For the [Gateway configuration reference](https://docs.konghq.com/gateway/latest/reference/configuration), open an issue on this repo and we'll update the docs.



## Generate the PDK, Admin API, CLI, and Configuration documentation

> This section is for Kong source code maintainers. You don't need to do anything here if you're contributing to this repo!

The PDK docs, Admin API docs, `cli.md`, and `configuration.md` for each release are generated from the Kong source code.

To generate them, go to the `Kong/kong` repo and run:

```bash
scripts/autodoc <docs-folder> <kong-version>
```

For example:

```bash
cd /path/to/kong
scripts/autodoc ../docs.konghq.com 2.4.x
```

This example assumes that the `Kong/docs.konghq.com` repo is cloned into the
same directory as the `Kong/kong` repo, and that you want to generate the docs
for version `3.7.x`. Adjust the paths and version as needed.

After everything is generated, review, open a branch with the changes, send a
pull request, and review the changes.

You usually want to open a PR against a `release/*` branch. For example, in the
example above, the branch was `release/3.7`.

```bash
cd docs.konghq.com
git fetch --all
git checkout release/2.4
git checkout -b release/2.4-autodocos
git add -A .
git commit -m "docs(2.4.x) add autodocs"
git push
```

Then open a pull request against `release/2.4`.