---
title: Contributing to the Kong docs
no_version: true
layout: 'docs-v2'
---

Hello, and welcome! Thanks for thinking about contributing to the Kong documentation.

This section of the docs is here to help you help us, so read on to learn how to ask questions and help effectively.
We respect your time, and the more you follow our guidelines the easier it is for us (docs maintainers) to respond
promptly and help you get your pull requests merged.

## What we're looking for

We welcome fixes to unclear prose, fixes to typos in docs for recent versions, docs for new features you've contributed to
the code, and more.

We are currently accepting plugin submissions, on a limited basis, from trusted technical partners to our plugin hub. To learn more about our partner program, see our [Kong Partners page](https://konghq.com/partners/).

Explore the existing documentation before you start a big docs contribution. Some types of docs don't belong on the site, including: end-to-end guides, tutorials, and anything better suited to a blog post. If you're interested in
this kind of content or have support questions, join the community on [Kong's forum](https://discuss.konghq.com/), on
[Gitter](https://gitter.im/Kong/kong), or on IRC at #kong.

We can't provide product support in this repository. To report Kong Gateway bugs, visit the [Kong product contributing guide](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#where-to-report-bugs).

## How to contribute

We adhere to our own [code of conduct](https://github.com/Kong/docs.konghq.com/blob/main/CODE_OF_CONDUCT.md) and we expect the same of our contributors.

If you find a problem in the docs, you can [file an issue](https://github.com/kong/docs.konghq.com/issues/new)
or you can submit a pull request (PR) with a fix. Please fill out the issue or PR template! We can't help if we don't understand the problem.

The Kong docs team assigns someone to review PRs every day, so you can expect acknowledgment of your contribution and at least preliminary
feedback within about a day of your initial PR. We ask that you respond to feedback within a week if we ask for changes; otherwise, we'll close
your issue or PR, although you can always reopen it to finish your work.

If you fix a typo, be sure to check for it everywhere, not just in the one instance you found. Currently docs for each version live in separate directories, not branches, and not much content changes from
version to version. Chances are good that a typo on a page in one version appears on the same page in other versions too.

### Content requirements

Before you change anything except for typos or grammatical errors, explore these resources:

* Our [style guide](/contributing/style-guide) provides a minimal set of style guidelines.
* Our set of [markdown rules](/contributing/markdown-rules) for making your content work with our Jekyll implementation. Specifies how you must
work with certain kinds of content - includes, variables, new pages.
* Our [list of Kong-specific terms](/contributing/terms). Includes product names and other terms the Kong docs use in specific ways.

### Build locally

Updates to the Kong docs `main` branch are automatically published with our Netlify integration. We also work with Netlify preview deploys, so when you create a pull request on GitHub, Netlify automatically provides a preview build that includes your changes.

If you are making substantial changes, we ask that you build locally before you create your PR. This lets you run tests locally, and helps you fix any build errors before working with Netlify.

See the [Kong docs README](https://github.com/Kong/docs.konghq.com/blob/main/README.md) for instructions to set up and build locally.

### First-time contributors

Fork the repository and create an appropriately named branch before you start working on any substantial changes.

### Git/GitHub resources

If you're new to Git and GitHub, we suggest you take some time with some of the great resources for learning these tools. Their basic purpose
is version control, but they were made to support open source projects, so their design and implementation might be different from what
you're used to. Resources we've found helpful, with thanks to the Write the Docs newsletter:

* [Learn Git in a Month of Lunches](https://www.amazon.com/Learn-Month-Lunches-Rick-Umali/dp/1617292419) (book). Recommended by the Write the Docs
community as a great "how to be productive with Git" tutorial.
* [Pro Git](https://git-scm.com/book/en/v2) (book).
* [Git Immersion](http://gitimmersion.com) (open source online course).
* [Git and GitHub for Poets](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6ZF9C0YMKuns9sLDzK6zoiV) (YouTube series, course).
* [Git and GitHub for Writers](https://www.udemy.com/course/git-and-github-for-writers) (Udemy course).

Or consider a GUI client instead of the command line, such as GitHub Desktop, TortoiseGit (Windows), Tower, Sourcetree, or GitKraken.

If you're making small spelling or grammar changes, you're welcome to skip the whole learn-Git-fork-branch-work-locally flow and make your changes directly in the GitHub web UI. The UI takes care of forking/branching automatically, so you don't need to worry about it. Because we work with deploy previews in Netlify, this approach means you also don't need to worry about building locally before you submit your PR.

### Contributor T-shirt

If your contribution to this repository was accepted and fixes a bug, adds
functionality, or makes it significantly easier to use or understand Kong,
congratulations! You are eligible to receive the very special Contributor
T-shirt! Fill out the [Contributors Submissions form](https://goo.gl/forms/5w6mxLaE4tz2YM0L2) and we'll
get it to you!

Thank you for contributing!
