# Writing documentation

After starting the site locally, navigate to `http://localhost:8080/docs/`. This is where you can view your work 
as you write your documentation.

## Versions

The code uses trunk based development where `master` is the `trunk` branch.

A folder in [app/docs](app/docs) exists for each minor version of Kuma. 
There is a special folder for the future non patch version of Kuma which is called [dev](app/docs/dev).

## Writing docs for a new feature

If you are writing docs for a new feature you'll want to add it in the [dev](app/docs/dev) folder.

## Diagrams

The team is moving diagrams to [Google slides](https://docs.google.com/presentation/d/1qvIKeYfcuowrHW1hV9fk9mCptt3ywroPBUYFjMj9gkk/edit#slide=id.g13d0c1ffb72_0_67).
Instructions are in the first slide.
Ask a maintainer to get write access.

## Cutting a new release

To cut the dev release copy paste the `dev` folder and rename it to the correct version:

```shell
# Create a 1.5.x release
cp app/docs/dev app/docs/1.5.x
cp app/_data/docs_nav_kuma_dev.yml app/_data/docs_nav_kuma_1.5.x.yml
```

Update the `app/_data/versions.yml` file with metadata specific to this release e.g: actual patches released, helm versions.

## Set up local builds with yarn

Before start, make sure that installed Ruby version is the same as in the `.ruby-version` file.

1.  Install:

    ```bash
    make install
    ```

1.  Build:

    ```bash
    make build
    ```

1.  Serve:

    ```bash
    make serve
    ```

You will need to run `make build` after making any changes to the content. Automatic rebuilding will be added in November 2022.

## Set up local builds with Netlify

If you get errors on the Netlify server, it can help to [set up a local Netlify environment](https://docs.netlify.com/cli/get-started/).

It has happened, however, that `make build` and the local Netlify build succeed, and the build still fails upstream. At which point … sometimes the logs can help, but not always.

WARNING: when you run a local Netlify build it modifies your local `netlify.toml`. Make sure to revert/discard the changes before you push your local.

## Add generated docs from protobufs

If you create a new policy resource for Kuma, you should rebuild the generated policy reference documentation.

## Markdown features
If you want to see the full set of markdown features VuePress offers, please refer to [the official VuePress
markdown documentation](https://vuepress.vuejs.org/guide/markdown.html).

## Vale

Vale is the tool used for linting the Kuma docs.
The Github action only checks changed lines in your PR.

You can [install Vale](https://vale.sh/docs/vale-cli/installation/)
and run it locally from the repository root with:

```shell
vale sync # only necessary once in order to download the styles
vale <any files changed in your PR or ones you want to check>
```

### Spurious warnings

If Vale warns or errors incorrectly,
the usual fix is to add the word or phrase
to the vocab list in `.github/styles/Vocab`.
