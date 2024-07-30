We run various quality checks at build time to ensure that the documentation is maintainable.



## Overriding default CI checks

Some of the checks can be manually adjusted depending on a PR's needs:
	
* Set labels:
    * `ci:manual-approve:link-validation` label - mark link checking as successful. Useful when Netlify returns an `HTTP 400` error and the links are validated manually.
    * `skip-changelog` - mark an item that you don't want to appear in the weekly [docs changelog](https://github.com/Kong/docs.konghq.com/blob/main/changelog.md).

* Set `[skip ci]` in the title of a PR to skip Netlify preview generation. This is useful for PRs that don't have any visual effect on the docs site, such as editing the repo README.

### include-check

The `include-check.sh` script checks for any files in the `app/_includes` folder that depend on a `page.*` variable (e.g. `page.url`). This is not compatible with the `include_cached` gem that we use, and so using `page.*` in an include will fail the build.

> To run the script locally, open a terminal, navigate to the documentation
folder, and run `./include-check.sh`. If there is no output, everything is
successful.

In the following example, we can see that `admin-listen.md` uses a `page.*` variable, and that the include is used in the `docker.md` file:

```bash
❯ ./include-check.sh
Page variables must not be used in includes.
Pass them in via include_cached instead

Files that currently use page.*:
File: app/_includes/md/admin-listen.md
via:
app/_src/gateway/install/docker.md
```

Here are sample contents for those files:

In `docker.md`:

```md
{% include_cached app/_includes/md/admin-listen.md %}
```

In `deployment-options-k8s`:

```md
This is an include that uses {{ page.release }}
```

To resolve this, the two files should be updated to pass in the URL when `include_cached` is called:

In `docker.md`:

```md
{% include_cached app/_includes/md/admin-listen.md release=page.release %}
```

In `admin-listen`:

```md
This is an include that uses {{ include.release }}
```

The `include_cached` gem uses all passed parameters as the cache lookup key, and this ensures that all required permutations of an include file will be generated.

For guidelines on how to write includes and call them in target topics, see the
[Kong Docs contributing guidelines](https://docs.konghq.com/contributing/includes).
