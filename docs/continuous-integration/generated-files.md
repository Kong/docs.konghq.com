# Generated files

Some files in the docs are generated from a single source of truth. When there are issues in these files, it's easy to fix the generated file and not know that we need to update the source file too.

To help with this, any generated files must contain a `source_url` entry in their frontmatter. When a pull request changes a file that contains this entry, a warning will be added as a comment:

```
⚠️ This PR edits generated files. Please make sure that the source file is updated.

https://github.com/Kong/kong/blob/master/scripts/autodoc/admin-api/generate.lua:

    app/gateway/2.8.x/admin-api/index.md
```

The PR will also have the `ci:prevent-merge:generated-files` label which will fail the build until it is removed.

The label may be removed by a maintainer at any time. This is usually done once a pull request has been raised against the source material (we don't have to wait for merge as they can take a while sometimes).