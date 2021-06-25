[![Netlify Status](https://api.netlify.com/api/v1/badges/ae60f2a4-488e-4771-b24a-c26badc5f45d/deploy-status)](https://app.netlify.com/sites/kongdocs/deploys)

# KONG's Documentation Website

This repository holds source code for [Kong](https://github.com/Kong/kong)'s documentation website. It's a [Jekyll](https://jekyllrb.com/) website deployed with [Netlify](https://www.netlify.com/).

If you'd like to contribute, head on over to [Issues](https://github.com/Kong/docs.konghq.com/issues). New beginners can find issues with the `good first issue` label, some of which can be handled via the GitHub GUI. 

Before submitting an issue or PR, please review our [Contributing Guide](https://docs.konghq.com/contributing/).

If you're looking to contribute to our open source API gateway, see our [Kong/kong](https://github.com/Kong/kong) repository.

## Run local project

For anything other than minor changes, clone the repository onto your local machine and build locally. We offer the option to build with or without Docker. 

## Run local project with Docker

### Prerequisites

- [gulp](https://gulpjs.com/docs/en/getting-started/quick-start/) globally
- [Docker](https://www.docker.com/products/docker-desktop)(Note that you will not need to run the Docker container via Docker Desktop.)

### Install dependencies and start container

Install dependencies:
```
make install
```

Start the Docker container:
```
make develop
```

### Run project using Docker

```
make run
```

Check the Docker build output at http://localhost:3000.

### Troubleshoot Docker issues

If you have issues getting the build output, you can try re-installing and re-running your build with: 
```
make clean && make run
``` 

### Test links with Docker

```
make check-links
```

## Develop locally without Docker

### Prerequisites

- [node and npm](https://www.npmjs.com/get-npm)
- [yarn](https://classic.yarnpkg.com)
- [gulp](https://gulpjs.com/docs/en/getting-started/quick-start/)
- [Bundler](https://bundler.io/) (< 2.0.0)
- [Ruby](https://www.ruby-lang.org) (> 2.6)
- [Python](https://www.python.org) (>= 2.7.X, < 3)

### Install dependencies

>
```
gem install bundler
npm install
```

### Run project using npm

>
```
npm start
```

Check the build output at http://localhost:8000.

### Test links 

```
make check-links-local
```

### Generate the PDK, Admin API, CLI, and Configuration documentation

The PDK docs, Admin API docs, `cli.md` and `configuration.md` for each release are generated from the Kong source code.

To generate them, go to the `Kong/kong` repo and run:

```
scripts/autodoc <docs-folder> <kong-version>
```

For example:

```
cd /path/to/kong
scripts/autodoc ../docs.konghq.com 2.4.x
```

This example assumes that the `Kong/docs.konghq.com` repo is cloned into the
same directory as the `Kong/kong` repo, and that you want to generate the docs
for version `2.4.x`. Adjust the paths and version as needed.

After everything is generated, review, open a branch with the changes, send a
pull request, and review the changes.

You usually want to open a PR against a `release/*` branch. For example, in the
example above the branch was `release/2.4`.

```
cd docs.konghq.com
git fetch --all
git checkout release/2.4
git checkout -b release/2.4-autodocos
git add -A .
git commit -m "docs(2.4.x) add autodocs"
git push
```

Then open a pull request against `release/2.4`.
