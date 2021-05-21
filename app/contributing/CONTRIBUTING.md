

> **TO DO: Jennifer will tackle this mess**

# Contributing to docs.konghq.com 📜 🦍

Hello, and welcome! Thanks for thinking about contributing to the Kong documentation.

This section of the docs is here to help you help us, so read on to learn how to ask questions and help effectively. 
We respect your time, and the more you follow our guidelines the easier it is for us (docs maintainers) to respond 
promptly and help you get your pull requests merged.

## What we're looking for

We welcome fixes to unclear prose, fixes to typos in docs for recent versions, docs for new features you've contributed to
the code, and more.

If you've written a Kong plug-in and need to contribute documentation for it, see [the page about plug-in docs](plugin-docs). 
There are special guidelines for these docs.

We ask that you explore the existing documentation before you start a big docs contribution, though. Some types of docs
don't belong on the site: end-to-end guides, tutorials, anything better suited to a blog post. If you're interested in 
this kind of content, though, join the community on [Kong's forum](https://discuss.konghq.com/), on 
[Gitter](https://gitter.im/Kong/kong), or on IRC at #kong.

The community is the place to ask support questions, too. We can't help you with the product in this repository.

## How to contribute

Depending on the bug, you can either [file an issue against the docs](https://github.com/kong/docs.konghq.com/issues/new) 
or submit a pull request with a fix. If you submit a PR without an issue, you must fill out the PR template to explain why 
you're making the change.

For bugs against Kong Gateway functionality, see the [code repository]
(https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#where-to-report-bugs).

If you fix a typo (and we welcome typo fixes!), be sure to check for it everywhere, not just in the one instance you might 
have found. Currently docs for each version live in separate directories, not branches, and much content doesn't change from 
version to version. Chances are good that a typo on a page in one version appears on the same page in other versions too.

> TODO expand based on some of the old material and on https://github.com/nayafia/contributing-template/blob/master/CONTRIBUTING-template.md

## Kong's Technical Writing Guide & Style Guide

To ensure consistency throughout all of Kong's documentation, we ask that all contributors reference our [Technical Writing Guide ](https://github.com/Kong/docs.konghq.com/blob/master/TECHNICAL-WRITING-GUIDE.md) and [Style Guide](https://github.com/Kong/docs.konghq.com/blob/master/STYLEGUIDE.md).

## Git Best Practices

> TODO trim and make sure relevant content is here or on another page. Removed branching section bc it's no longer relevant. Note netlify builds?

Link to good git tutorials elsewhere.

#### Linting

put in readme, as part of running locally -- or remove? we don't seem to actually require it

As mentioned in the guidelines, to submit a patch, the linter must succeed. You
can run the linter like so:

```bash
$ npm run test
```

### Contributing images, videos, etc

> TODO check whether this is still current. Recommend not mentioning videos <shudder>

Binary files like images and videos should not be included in your pull
request, except custom icons for the Kong Hub - any request
including them will be rejected.

Instead, please:

1. Include the HTML necessary to display your binary file in your code
1. In place of the link to the binary file, use `FIXME`
1. Email your binary files to support@konghq.com, and include a link to your
   pull request
1. Kong staff will host your binary files on our CDN, and will replace the
   `FIXME`s in your code with URLs of the binaries


### Contributor T-shirt

> TODO check whether this is still current.

If your contribution to this repository was accepted and fixes a bug, adds
functionality, or makes it significantly easier to use or understand Kong,
congratulations! You are eligible to receive the very special Contributor
T-shirt! Find out how to request your shirt
[here](https://github.com/Kong/kong/blob/main/CONTRIBUTING.md#contributor-t-shirt).

Thank you for contributing!
