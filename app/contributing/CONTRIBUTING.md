---
title: Contributing to the Kong docs
---

Hello, and welcome! Thanks for thinking about contributing to the Kong documentation.

This section of the docs is here to help you help us, so read on to learn how to ask questions and help effectively. 
We respect your time, and the more you follow our guidelines the easier it is for us (docs maintainers) to respond 
promptly and help you get your pull requests merged.

## What we're looking for

We welcome fixes to unclear prose, fixes to typos in docs for recent versions, docs for new features you've contributed to
the code, and more.

If you've written a Kong plug-in and need to contribute documentation for it, see the docs [about plug-in docs](../plugin-docs). 
There are special guidelines for these docs.

We ask that you explore the existing documentation before you start a big docs contribution. Some types of docs
don't belong on the site: end-to-end guides, tutorials, anything better suited to a blog post. If you're interested in 
this kind of content, though, join the community on [Kong's forum](https://discuss.konghq.com/), on 
[Gitter](https://gitter.im/Kong/kong), or on IRC at #kong.

The community is the place to ask support questions, too. We can't help you with the product in this repository.

For bugs against Kong Gateway functionality, see the [code repository]
(https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#where-to-report-bugs).

## How to contribute

We adhere to our own [code of conduct](https://github.com/Kong/docs.konghq.com/blob/main/CODE_OF_CONDUCT.md) and we expect the same of our contributors. 

If you find a problem in the docs, you can [file an issue against the docs](https://github.com/kong/docs.konghq.com/issues/new) 
or you can submit a pull request with a fix. If you submit a PR without an issue, make sure to fill out the PR template to explain why 
you're making the change. We require the information we ask for in the template, and it's especially important if we don't have 
an issue to refer to.

The Kong docs team assigns someone to review PRs every day, so you can expect acknowledgment of your contribution and at least preliminary 
feedback within about a day of your initial PR. We ask that you respond to feedback within a week if we ask for changes; otherwise, we'll close 
your issue or PR, although you can always reopen it to finish your work.

If you fix a typo (and we welcome typo fixes!), be sure to check for it everywhere, not just in the one instance you might 
have found. Currently docs for each version live in separate directories, not branches, and much content doesn't change from 
version to version. Chances are good that a typo on a page in one version appears on the same page in other versions too.

### Content requirements

Before you change anything except fixes for typos or well-known grammar rules, look through our [style guide](../style-guide) and [markdown rules](../markdown-rules). The style guide provides a minimal set of style guidelines we ask you to adhere to, and the markdown rules specify how you must
work with certain kinds of content -- includes, variables, new pages -- to make sure they integrate with our Jekyll implementation.

### First-time contributors

Make sure to fork the repository and create an appropriately named branch before you start working on any substantial changes.

### Git/GitHub resources

If you're new to Git and GitHub, we suggest you take some time with some of the great resources for learning these tools. Their basic purpose 
is version control, but they were made to support open source projects, so their design and implemenation might be different from what 
you're used to. Resources we've found helpful, with thanks to the Write the Docs newsletter:

* [Learn Git in a Month of Lunches](https://www.amazon.com/Learn-Month-Lunches-Rick-Umali/dp/1617292419) (book). Recommended by the Write the Docs 
community as a great "how to be productive with Git" tutorial.
* [Pro Git](https://git-scm.com/book/en/v2) (book).
* [Git Immersion](http://gitimmersion.com) (open source online course).
* [Git and GitHub for Poets](https://www.youtube.com/playlist?list=PLRqwX-V7Uu6ZF9C0YMKuns9sLDzK6zoiV) (YouTube series, course).
* [Git and GitHub for Writers](https://www.udemy.com/course/git-and-github-for-writers) (Udemy course).

Or consider a GUI client instead of the command line, such as GitHub Desktop, TortoiseGit (Windows), Tower, Sourcetree, or GitKraken.

If you're making small spelling or grammar changes, you're welcome to skip the whole learn-Git-fork-branch-work-locally flow and make your changes directly in the GitHub web UI. The UI takes care of forking/branching automatically, so you don't need to worry about it. Because we work with deploy previews in Netlify, this approach means you also don't need to worry about building locally before you submit your PR.

If you're making more substantial changes, however, we ask that you take the time to build locally and make sure your changes appear as they 
should in your local build. See [the README](https://github.com/Kong/docs.konghq.com/blob/main/README.md) for details.

### Contributor T-shirt

If your contribution to this repository was accepted and fixes a bug, adds
functionality, or makes it significantly easier to use or understand Kong,
congratulations! You are eligible to receive the very special Contributor
T-shirt! Fill out the [Contributors Submissions form](https://goo.gl/forms/5w6mxLaE4tz2YM0L2) and we'll 
get it to you!

Thank you for contributing!
